# Localization TODO (list-only)

This file lists user-facing hard-coded strings found in the codebase that should be replaced with `AppLocalizations.of(context)!.<key>` and added to your l10n sources (ARB or gen-l10n inputs).

Priority: High → Medium → Low (recommended order to convert)

---

## High priority (convert first)

- `lib/features/profile/presentation/pages/profile_screen.dart`
  - Examples:
    - `Text('الملف الشخصي')` -> key: `profileTitle`
    - Menu items and subtitles (e.g., 'تعديل الملف الشخصي', 'تغيير كلمة المرور', 'طرق الدفع', 'سجل الطلبات') -> keys: `editProfile`, `changePassword`, `paymentMethods`, `bookings`
    - Logout dialog strings -> keys: `logoutTitle`, `logoutConfirm`, `cancel`, `logout`

- `lib/features/home/presentation/widgets/dashboard_profile_tab.dart`
  - Examples:
    - `Text('Select Language')`, `Text('English')`, `Text('العربية')` -> keys: `selectLanguage`, `english`, `arabic`
    - `Text('Profile')`, `Text('Settings')`, `Text('Help')`, `Text('Logout')` -> keys: `profile`, `settings`, `help`, `logout`

- `lib/features/home/presentation/pages/home_screen.dart`
  - Examples: top-level tab labels and menu text -> keys aligned with the above

## Medium priority

- `lib/features/settings/presentation/pages/settings_screen.dart`
  - Examples:
    - `Text('Error: ${state.message}')` -> `errorMessage` (use with interpolation)
    - `Text('Try Again')`, `Text('Something went wrong')` -> `tryAgain`, `somethingWentWrong`
    - `Text('Terms of Service screen coming soon!')`, `Text('Privacy Policy screen coming soon!')` -> `termsComingSoon`, `privacyComingSoon`

- `lib/features/services/presentation/pages/service_selection_screen.dart`
  - Examples: `Text('Services')`, `Text('Search Services')`, `Text('Cancel')`, `Text('Search')` -> `services`, `searchServices`, `cancel`, `search`

- `lib/features/services/presentation/pages/services_screen.dart` and `service_details_screen.dart`
  - Examples: `Retry`, `Close`, `Service Details`, snackbars -> `retry`, `close`, `serviceDetails`, `shareError`

- `lib/features/providers/**`
  - Examples: `Sort`, `Filters`, `Apply`, `Reset`, `Try Again`, `Price: Low to High`, `Distance` -> `sort`, `filters`, `apply`, `reset`, `tryAgain`, `priceLowToHigh`, `distance`

- `lib/features/payment/presentation/pages/payment_methods_screen.dart` and related widgets
  - Examples: `Payment Methods`, `Add Payment Method`, `Add Card`, `Cancel`, `Delete` -> `paymentMethods`, `addPaymentMethod`, `addCard`, `cancel`, `delete`

- `lib/features/help_support/presentation/pages/*`
  - Examples: `About`, `Contact Support`, `Message sent successfully!` -> `about`, `contactSupport`, `messageSent`

## Lower priority

- `lib/features/booking/**`
  - Examples: `Upcoming`, `History`, `Cancelled`, booking snackbars -> `upcoming`, `history`, `cancelled`, `bookingUpdated`

- `lib/features/notifications/**`
  - Examples: `تحديد الكل كمقروء`, `إغلاق`, `حذف الإشعار`, `حذف جميع الإشعارات`, `حذف`, `إلغاء` -> `markAllAsRead`, `close`, `deleteNotification`, `deleteAllNotifications`, `delete`, `cancel`

- `lib/features/chat/**`
  - Examples: `Archived Chats`, `Blocked Users`, `Chat Settings`, `No archived chats` -> `archivedChats`, `blockedUsers`, `chatSettings`, `noArchivedChats`

- Misc snackbars and small UI strings across features (search results, empty states, errors). These should be audited by feature and replaced with localized keys.

## Suggested localization keys (starter set)

Add these to your l10n sources (English + Arabic translations as a minimum):

- `profileTitle`: "Profile" / "الملف الشخصي"
- `profile`: "Profile" / "الملف الشخصي"
- `settings`: "Settings" / "الإعدادات"
- `help`: "Help" / "المساعدة"
- `selectLanguage`: "Select Language" / "اختر اللغة"
- `english`: "English" / "الإنجليزية"
- `arabic`: "Arabic" / "العربية"
- `logout`: "Logout" / "تسجيل الخروج"
- `logoutConfirm`: "Are you sure you want to logout?" / "هل أنت متأكد من رغبتك في تسجيل الخروج؟"
- `cancel`: "Cancel" / "إلغاء"
- `tryAgain`: "Try Again" / "إعادة المحاولة"
- `somethingWentWrong`: "Something went wrong" / "حدث خطأ"
- `services`: "Services" / "الخدمات"
- `search`: "Search" / "بحث"
- `searchServices`: "Search Services" / "بحث في الخدمات"
- `paymentMethods`: "Payment Methods" / "طرق الدفع"
- `addPaymentMethod`: "Add Payment Method" / "إضافة طريقة دفع"
- `about`: "About" / "حول التطبيق"
- `contactSupport`: "Contact Support" / "اتصل بالدعم"

## How to apply the changes (quick path)

1. Add keys above to your l10n ARB files (English and Arabic). Example ARB snippets:

```json
{
  "profileTitle": "Profile",
  "profileTitle": "الملف الشخصي",
  ...
}
```

2. Run your localization generator (gen-l10n) to regenerate `AppLocalizations`:

```powershell
flutter gen-l10n
flutter analyze
```

3. Replace hard-coded `Text('...')` usages in the files listed above with `Text(AppLocalizations.of(context)!.<key>)`.

## Notes
- This list was generated from a repository-wide scan for `Text('...')` and prioritized by user-surface impact.
- Some strings are already localized; this file focuses on hard-coded occurrences.
- For interpolated messages (e.g., `Error: ${state.message}`) use parameterized messages in ARB or use `AppLocalizations` variants that accept arguments.

If you want, I can apply the quick-path changes for the top 3 high-priority files (add keys, run gen-l10n, and update the files) in the next step.
