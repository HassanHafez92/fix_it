# Fix It - Technical Plan

## 1. Overview

### Project Goal
Develop a mobile application connecting users in Egypt with home-repair technicians for various services including electrical, plumbing, carpentry, AC installation, and more.

### Architecture
- **Frontend**: Flutter with BLoC architecture
- **Backend**: REST API with PostgreSQL database
- **Authentication**: Firebase Authentication
- **Notifications**: Firebase Cloud Messaging (FCM)
- **Language Support**: Arabic (RTL) first
- **Dependency Injection**: GetIt
- **Networking**: Dio/Retrofit
- **Data Persistence**: Shared preferences, SQLite
- **Security**: Flutter Secure Storage

### Identity Management
- Firebase Authentication only
- Backend verifies Firebase ID Tokens per request via Admin SDK
- No backend JWTs or refresh endpoints

## 2. Authentication System

### Client Implementation (Flutter)
- Firebase Auth SDK integration
- Support for email/password authentication
- Phone number sign-in as a first-class option for Egyptian users

### Server Implementation
- All protected requests include `Authorization: Bearer <Firebase ID Token>` over HTTPS
- Token verification on each request using Firebase Admin SDK's `verifyIdToken`
- Extract UID for Role-Based Access Control (RBAC) and data ownership
- Optional short-term caching of decoded tokens to reduce verification overhead
- Custom claims for access control flags only when needed
- User data stored in the database rather than in tokens

### Data Model
- Store `firebase_uid` as UNIQUE constraint on Users table
- Email and phone fields are optional to support phone-first onboarding for technicians

## 3. Payment System

### MVP Approach: Cash Only
- No payment gateway integration in the initial release
- UI displays "Cash on completion" in booking confirmation

### Backend Implementation
- Providers mark job as completed
- Require client confirmation (two-step process) to finalize cash status
- This reduces disputes and potential fraud
- Auto-completion after N hours with a dispute_window flag for support intervention

### Database Structure
- Payments table designed for future extensibility
- Payment method: "cash"
- Transaction status flow: pending → completed (after client confirmation) → refunded (manual if needed)

## 4. Proximity Search

### Data Storage
- **ServiceProviders**: Store latitude, longitude, and last_location_updated_at
- **Bookings**: address_details_json includes latitude and longitude

### API Implementation
```
GET /providers?service_id=&search_query=&min_rating=&available_at=&lat=&lng=&radius_km=&max_price=&sort=distance|rating|price
```
- Response includes distance_km (rounded to 0.1km)
- Optional ETA_hint_minutes (simple heuristic, e.g., 25km/h intra-city)
- ETA flagged as estimate_only

### Query Strategy
1. Bounding box prefilter using lat/lng ranges
2. Haversine formula to compute accurate distance
3. Filter results with `HAVING distance <= radius_km`
4. Order by distance when requested

### Future Enhancements
- Feature flag to switch to Postgres earthdistance or PostGIS
- earthdistance: ll_to_earth + earth_distance for simpler accurate queries
- PostGIS geography: ST_Distance and spatial indexes for scalability

## 5. Core Features (MVP)

### User Features
- Browse categories and services
- List nearby technicians with ratings and prices
- Book appointment (service, provider, date/time, address on map, notes)
- Track booking status (pending, confirmed, in_progress, completed, cancelled)
- Receive notifications for booking updates
- Rate providers after completion (verified booking only)

### Provider Features
- Professional profile (profession, services, pricing, bio)
- Coverage configuration (center and radius) and availability schedule
- Accept/decline jobs
- Update job status
- View job address details

### Admin Features (Light Initially)
- Manage categories and services
- KYC review and provider verification
- Monitor bookings, disputes, and timeouts

## 6. Data Model (PostgreSQL)

### Users
```sql
user_id UUID PK,
firebase_uid VARCHAR UNIQUE NOT NULL,
full_name,
email UNIQUE NULL,
phone_number UNIQUE NULL,
role ENUM('client','provider','admin'),
profession,
profile_picture_url,
created_at,
updated_at
```

### ServiceCategories
```sql
category_id UUID PK,
name UNIQUE,
icon_url
```

### Services
```sql
service_id UUID PK,
category_id FK,
name,
description,
image_url,
base_price
```

### ServiceProviders
```sql
provider_id UUID PK (FK Users.user_id),
bio,
average_rating REAL default 0,
total_ratings INT default 0,
is_verified BOOLEAN default false,
availability_json JSONB,
latitude REAL,
longitude REAL,
last_location_updated_at TIMESTAMP,
coverage_center_lat REAL,
coverage_center_lng REAL,
coverage_radius_km REAL,
kyc_status ENUM('pending','approved','rejected'),
kyc_documents JSONB
```
*Indexes: composite (latitude, longitude); plus individual where helpful*

### ProviderServices (M2M)
```sql
provider_service_id UUID PK,
provider_id FK,
service_id FK,
price REAL,
UNIQUE(provider_id, service_id)
```

### Bookings
```sql
booking_id UUID PK,
user_id FK,
provider_id FK,
service_id FK,
status ENUM('pending','confirmed','in_progress','completed','cancelled','disputed'),
booking_timestamp TIMESTAMP NOT NULL,
scheduled_start_time TIMESTAMP NOT NULL,
scheduled_end_time TIMESTAMP NULL,
address_details_json JSONB NOT NULL (includes latitude, longitude),
total_price REAL NOT NULL,
payment_id FK NULL,
user_rating_id FK NULL,
provider_rating_id FK NULL,
notes TEXT
```
*Audit/flow: expires_at TIMESTAMP, accepted_at, in_progress_at, completed_at, cancelled_at, cancelled_by ENUM('client','provider','system'), requires_client_confirmation BOOLEAN, client_confirmed_at TIMESTAMP*

*Concurrency: prevent overlapping confirmed/in_progress bookings per provider via transactional checks*

### Payments (cash)
```sql
payment_id UUID PK,
booking_id UUID UNIQUE FK,
amount REAL,
currency VARCHAR(3),
payment_method ENUM('cash'),
transaction_status ENUM('pending','completed','failed','refunded'),
transaction_timestamp TIMESTAMP,
external_transaction_id VARCHAR NULL
```

### Ratings
```sql
rating_id UUID PK,
booking_id FK NOT NULL,
rater_user_id FK NOT NULL,
rated_entity_id UUID (provider_id),
rating_value INT CHECK 1..5,
comment TEXT,
rating_timestamp default now(),
verified_booking BOOLEAN default true,
UNIQUE(booking_id, rater_user_id)
```

### Notifications
```sql
notification_id UUID PK,
user_id FK,
title,
body,
type ENUM('booking_confirmation','review_request','booking_reschedule','app_update','special_offer','payment_success'),
timestamp default now(),
is_read BOOLEAN default false,
target_data_json JSONB includes type, ids, version
```

### AppSettings, FAQs
*(As previously defined)*

## 7. Database Indexes

### Key Indexes
- **Users**: idx_users_firebase_uid, idx_users_email, idx_users_phone_number, idx_users_role
- **ServiceProviders**: composite idx_providers_lat_lng(latitude, longitude), idx_providers_verification, idx_providers_rating
- **Services**: idx_services_category_id, idx_services_name
- **ProviderServices**: idx_provider_services_provider_id, idx_provider_services_service_id
- **Bookings**: idx_bookings_user_id, idx_bookings_provider_id, idx_bookings_status, idx_bookings_scheduled_start_time, idx_bookings_expires_at
- **Payments**: idx_payments_booking_id, idx_payments_transaction_status
- **Ratings**: idx_ratings_rated_entity_id, idx_ratings_rater_user_id
- **Notifications**: idx_notifications_user_id, idx_notifications_timestamp, idx_notifications_is_read

### Future Considerations
- Optional: Postgres earthdistance or PostGIS indexes for geo queries

## 8. API Contract

### Authentication
- All protected endpoints require `Authorization: Bearer <Firebase ID Token>`
- Backend verifies each call via Admin SDK verifyIdToken
- `GET /auth/me` → returns current DB user resolved from token for client bootstrap convenience

### Services
- `GET /service-categories`
- `GET /services`
- `GET /services/{service_id}`

### Providers
- `GET /providers?service_id=&search_query=&min_rating=&available_at=&lat=&lng=&radius_km=&max_price=&sort=distance|rating|price` → includes distance_km and availability_preview
- `GET /providers/{provider_id}`

### Bookings
- `POST /bookings` → validates provider coverage and time-slot conflicts; creates booking status=pending; returns expires_at for acceptance window
- `PUT /bookings/{id}/accept` (provider)
- `PUT /bookings/{id}/decline` (provider)
- `PUT /bookings/{id}/start` (provider)
- `PUT /bookings/{id}/complete` (provider)
- `PUT /bookings/{id}/confirm-completion` (client) → finalizes cash completion
- `PUT /bookings/{id}/cancel` (client/provider/admin)
- `PUT /bookings/{id}/dispute` (client/provider) within window
- `GET /users/{user_id}/bookings?status=upcoming|past|all`
- `GET /bookings/{booking_id}`

### Payments (cash flow only)
- `PUT /bookings/{id}/complete-payment-cash` → internally set pending client confirmation; finalization via confirm-completion

### Profile & Settings
- `GET/PUT /users/{user_id}/profile`
- `GET/PUT /users/{user_id}/app-settings`

### Notifications
- `GET /users/{user_id}/notifications`
- `PUT /notifications/{notification_id}/read`

### Ratings
- `POST /ratings { booking_id, rated_entity_id, rating_value 1..5, comment? }` → only for completed bookings (verified_booking=true)
- `GET /providers/{provider_id}/ratings`

## 9. Booking Lifecycle and SLAs

### Acceptance Window
- Provider must accept/decline within X minutes
- System auto-cancels or reassigns if timeout occurs
- Notifications sent via FCM with deep links

### Status Transitions
```
pending → confirmed (accept) → in_progress (start) → completed (complete) → payment completed after client confirmation
```
- Any stage can move to cancelled with cancelled_by recorded
- Disputes allowed within a specific window
- Audit timestamps for all transitions to support support workflows and analytics

## 10. Availability and Double-Booking Prevention

### Availability Schema
```json
{
  "weekly_blocks": [
    {
      "day_of_week": 1,
      "start_time": "09:00",
      "end_time": "17:00"
    }
  ],
  "exceptions": [
    {
      "date": "2023-12-25",
      "available": false
    }
  ]
}
```
- Backend validates schema and overlapping ranges

### Double-Booking Prevention
- Transactional query ensures no overlapping confirmed/in_progress bookings for the provider in the requested window
- Consider Postgres range types and exclusion constraints once stabilizing

## 11. Provider Verification, Coverage, and Safety

### KYC Workflow
- Providers upload national ID and skill proof
- kyc_status transitions: pending → approved/rejected
- Only approved providers are surfaced prominently

### Coverage Enforcement
- Defined by coverage_center_lat/lng + coverage_radius_km
- Block bookings outside radius unless provider explicitly accepts (future: surcharge option)

### Safety Features
- is_verified badge and filter
- Emergency contact field
- Optional trade license upload

## 12. Notifications and Conventions

### Notification Data Structure
```json
{
  "target_data_json": {
    "type": "booking" | "rating" | "offer",
    "booking_id": "uuid",
    "provider_id": "uuid",
    "version": 1
  }
}
```

### Implementation
- Scheduled jobs handle acceptance timeouts and auto-completions
- All changes trigger FCM notifications with deep-links

## 13. Security

### General
- HTTPS everywhere
- Consider SSL pinning in app later
- Server-side token verification on every protected call
- Never trust client-only claims

### Client-Side
- Store tokens securely in flutter_secure_storage
- Do not embed secrets in the app

### Server-Side
- Input validation and RBAC on server
- Structured audit logging for booking and payment transitions (actor_uid, IP/device if available)

## 14. Performance and Scalability

### Frontend
- Use const widgets, builder lists, image compression/lazy loading
- Implement pagination and caching

### Backend
- Optimize indexes as specified
- Use bounding-box prefilter before Haversine
- Optional upgrade to earthdistance or PostGIS when scale requires it

### Token Verification
- Consider short-lived cache of decoded tokens to reduce overhead while maintaining correctness

## 15. Testing and Operations

### Testing Strategy
- **Unit Tests**: UseCases, Repositories, BLoCs with mocks; focus on booking lifecycle, availability validation, and provider search filtering
- **Widget Tests**: For key flows
- **Integration Tests**: End-to-end flows (auth→search→booking→accept→complete→confirm→rate)

### CI/CD
- Run tests + static analysis on PRs
- Error logging via Crashlytics/Sentry for clients
- Structured logs on server

### Operations
- Admin panel (read-first, then write): KYC review, booking monitors, disputes, status overrides with audit logs

## 16. Development Roadmap (6-week MVP)

### Week 1
- Project setup
- Firebase Auth integration
- Users(firebase_uid) model
- /auth/me endpoint
- Base services/categories

### Week 2
- Providers listing with proximity (bounding-box + Haversine)
- Provider profile
- Composite lat/lng index

### Week 3
- Booking flow
- Coverage and slot conflict checks
- Acceptance window and expires_at

### Week 4
- Provider dashboard (accept/decline/start/complete)
- FCM notifications
- User bookings list

### Week 5
- Ratings (verified booking)
- Profile/settings
- KYC review basics
- Fraud controls (two-step completion)

### Week 6
- RTL QA
- Security hardening (token verification paths, logging)
- Performance optimization
- Pilot release

## 17. Implementation Snippets (Server-Side Proximity)

### Bounding Box Parameters
```sql
dLat = radius_km/111;
dLng = radius_km/(111*cos(radians(:lat)));
```

### Haversine Distance Calculation (km)
```sql
distance_km = 6371 * acos(
    cos(radians(:lat)) * 
    cos(radians(latitude)) * 
    cos(radians(longitude) - radians(:lng)) + 
    sin(radians(:lat)) * 
    sin(radians(latitude))
);
```

### Postgres Alternatives
- **earthdistance**: 
  ```sql
  earth_distance(ll_to_earth(:lat,:lng), ll_to_earth(latitude,longitude))
  ```
- **PostGIS**: 
  ```sql
  ST_Distance(
      geography, 
      ST_MakePoint(:lng,:lat)::geography
  ) with spatial index if upgraded
   ```

---

## Conclusion

This technical plan provides a comprehensive blueprint for the Fix It application, outlining the architecture, implementation details, and development roadmap. The plan follows clean architecture principles with Flutter+BLoC for the frontend and a REST API with PostgreSQL for the backend.

Key aspects of the implementation include:
- Firebase Authentication for secure user management
- Proximity-based provider search using efficient geospatial algorithms
- A robust booking system with status tracking and fraud prevention
- Cash-based payments with two-step completion for security
- RTL support for Arabic language users

The 6-week development roadmap prioritizes core functionality while ensuring security, performance, and quality. The plan is designed to evolve as development progresses and new requirements emerge.

By following this technical plan, the Fix It team will be able to deliver a reliable, scalable, and user-friendly platform connecting Egyptian homeowners with trusted repair technicians.
  ```
