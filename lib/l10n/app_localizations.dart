import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Fix It'**
  String get appTitle;

  /// Settings page title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Notifications section title
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Push notifications setting
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get pushNotifications;

  /// Push notifications description
  ///
  /// In en, this message translates to:
  /// **'Receive notifications on your device'**
  String get pushNotificationsDesc;

  /// Email notifications setting
  ///
  /// In en, this message translates to:
  /// **'Email Notifications'**
  String get emailNotifications;

  /// Email notifications description
  ///
  /// In en, this message translates to:
  /// **'Receive notifications via email'**
  String get emailNotificationsDesc;

  /// Booking reminders setting
  ///
  /// In en, this message translates to:
  /// **'Booking Reminders'**
  String get bookingReminders;

  /// Booking reminders description
  ///
  /// In en, this message translates to:
  /// **'Get reminded about upcoming bookings'**
  String get bookingRemindersDesc;

  /// Privacy section title
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// Location services setting
  ///
  /// In en, this message translates to:
  /// **'Location Services'**
  String get locationServices;

  /// Location services description
  ///
  /// In en, this message translates to:
  /// **'Allow app to access your location'**
  String get locationServicesDesc;

  /// Data sharing setting
  ///
  /// In en, this message translates to:
  /// **'Data Sharing'**
  String get dataSharing;

  /// Data sharing description
  ///
  /// In en, this message translates to:
  /// **'Share anonymous usage data to improve the app'**
  String get dataSharingDesc;

  /// Preferences section title
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// Language setting
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Currency setting
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// About menu item
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Help and support menu item
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// Terms of service menu item
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// Privacy policy menu item
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// Language selection dialog title
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// Currency selection dialog title
  ///
  /// In en, this message translates to:
  /// **'Select Currency'**
  String get selectCurrency;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Success message for settings update
  ///
  /// In en, this message translates to:
  /// **'Settings updated successfully!'**
  String get settingsUpdatedSuccess;

  /// Success message for language change
  ///
  /// In en, this message translates to:
  /// **'Language changed successfully!'**
  String get languageChangedSuccess;

  /// Error shown when profile/data fails to load
  ///
  /// In en, this message translates to:
  /// **'Error loading data'**
  String get errorLoadingData;

  /// Subtitle for edit profile menu item
  ///
  /// In en, this message translates to:
  /// **'Update your personal information'**
  String get profileUpdateSubtitle;

  /// Subtitle for change password menu item
  ///
  /// In en, this message translates to:
  /// **'Update your password'**
  String get changePasswordSubtitle;

  /// Subtitle for payment methods menu item
  ///
  /// In en, this message translates to:
  /// **'Manage your cards and payment methods'**
  String get managePaymentSubtitle;

  /// Subtitle for bookings menu item
  ///
  /// In en, this message translates to:
  /// **'View your past bookings'**
  String get viewBookingsSubtitle;

  /// Subtitle for notifications menu item
  ///
  /// In en, this message translates to:
  /// **'Manage your notification preferences'**
  String get notificationsSubtitle;

  /// Subtitle for help & support menu item
  ///
  /// In en, this message translates to:
  /// **'FAQs and contact us'**
  String get helpSupportSubtitle;

  /// Subtitle for about menu item
  ///
  /// In en, this message translates to:
  /// **'Information about Fix It'**
  String get aboutSubtitle;

  /// Subtitle for logout menu item
  ///
  /// In en, this message translates to:
  /// **'Sign out of your account'**
  String get logoutSubtitle;

  /// Title for the profile screen
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// Short label for profile
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Edit profile menu item
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// Change password menu item
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// Payment methods menu item
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get paymentMethods;

  /// Bookings menu item
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get bookings;

  /// Logout dialog title
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutTitle;

  /// Logout confirmation text
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirm;

  /// Language name English
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Language name Arabic
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// Services screen title
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// Search services dialog title
  ///
  /// In en, this message translates to:
  /// **'Search Services'**
  String get searchServices;

  /// Try again button text
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// Generic error text
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// Empty services list text
  ///
  /// In en, this message translates to:
  /// **'No services available'**
  String get noServicesAvailable;

  /// Search field placeholder
  ///
  /// In en, this message translates to:
  /// **'Search services...'**
  String get searchHint;

  /// Categories section title
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// Search results header
  ///
  /// In en, this message translates to:
  /// **'Search Results'**
  String get searchResults;

  /// All services header
  ///
  /// In en, this message translates to:
  /// **'All Services'**
  String get allServices;

  /// Search button text
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No services found text
  ///
  /// In en, this message translates to:
  /// **'No services found'**
  String get noServicesFound;

  /// Suggestion when no services found
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search or filters'**
  String get tryAdjustingSearch;

  /// Error header
  ///
  /// In en, this message translates to:
  /// **'Oops! Something went wrong'**
  String get oopsSomethingWrong;

  /// Retry button text
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Filter bottom sheet title
  ///
  /// In en, this message translates to:
  /// **'Filter Services'**
  String get filterServices;

  /// Placeholder for upcoming features
  ///
  /// In en, this message translates to:
  /// **'Coming Soon...'**
  String get comingSoon;

  /// Close button text
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Service details screen title
  ///
  /// In en, this message translates to:
  /// **'Service Details'**
  String get serviceDetails;

  /// Service details error header
  ///
  /// In en, this message translates to:
  /// **'Error loading service'**
  String get errorLoadingService;

  /// Availability label
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// Availability label
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get unavailable;

  /// Price label
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// Duration label
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// Description section title
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descriptionLabel;

  /// Category label with interpolation
  ///
  /// In en, this message translates to:
  /// **'Category: {category}'**
  String categoryLabel(Object category);

  /// Gallery section title
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// Book now button
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get bookNow;

  /// Contact provider button
  ///
  /// In en, this message translates to:
  /// **'Contact Provider'**
  String get contactProvider;

  /// Short minutes suffix
  ///
  /// In en, this message translates to:
  /// **'m'**
  String get minutesShort;

  /// Reviews label
  ///
  /// In en, this message translates to:
  /// **'reviews'**
  String get reviews;

  /// Placeholder text for terms of service
  ///
  /// In en, this message translates to:
  /// **'Terms of Service screen coming soon!'**
  String get termsComingSoon;

  /// Placeholder text for privacy policy
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy screen coming soon!'**
  String get privacyComingSoon;

  /// Language name Spanish
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanish;

  /// Language name French
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get french;

  /// Language name German
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get german;

  /// Providers screen title
  ///
  /// In en, this message translates to:
  /// **'Providers'**
  String get providers;

  /// Label for service providers listing
  ///
  /// In en, this message translates to:
  /// **'Service Providers'**
  String get serviceProviders;

  /// Empty providers list text
  ///
  /// In en, this message translates to:
  /// **'No providers found'**
  String get noProvidersFound;

  /// Suggestion when no providers found
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search or filters'**
  String get tryAdjustingFilters;

  /// Nearby toggle label
  ///
  /// In en, this message translates to:
  /// **'Nearby'**
  String get nearby;

  /// Sort control label
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sort;

  /// Filters label
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// Distance sort/label
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distance;

  /// Rating label
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// Min label
  ///
  /// In en, this message translates to:
  /// **'Min'**
  String get min;

  /// Max label
  ///
  /// In en, this message translates to:
  /// **'Max'**
  String get max;

  /// Verified only filter label
  ///
  /// In en, this message translates to:
  /// **'Verified Providers Only'**
  String get verifiedProvidersOnly;

  /// Reset button text
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// Apply button text
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// Available status label for providers
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get availableLabel;

  /// Busy status label for providers
  ///
  /// In en, this message translates to:
  /// **'Busy'**
  String get busyLabel;

  /// Reviews section title for providers
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviewsLabel;

  /// Title for available time slots section
  ///
  /// In en, this message translates to:
  /// **'Available Time Slots'**
  String get availableTimeSlotsTitle;

  /// Empty state when no time slots are available
  ///
  /// In en, this message translates to:
  /// **'No available time slots for this day'**
  String get noAvailableTimeSlots;

  /// Prompt to select a date to view time slots
  ///
  /// In en, this message translates to:
  /// **'Select a date to view available time slots'**
  String get selectDateToViewSlots;

  /// Title for the select date step
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// Subtitle for date selection step
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred date for the service'**
  String get choosePreferredDate;

  /// Title for time selection step
  ///
  /// In en, this message translates to:
  /// **'Select Time'**
  String get selectTime;

  /// Available times header with date
  ///
  /// In en, this message translates to:
  /// **'Available times for {date}'**
  String availableTimesForDate(Object date);

  /// Prompt to select a date before viewing times
  ///
  /// In en, this message translates to:
  /// **'Please select a date first'**
  String get pleaseSelectDateFirst;

  /// Error header when time slots fail to load
  ///
  /// In en, this message translates to:
  /// **'Failed to load time slots'**
  String get failedToLoadTimeSlots;

  /// Title for booking details step
  ///
  /// In en, this message translates to:
  /// **'Booking Details'**
  String get bookingDetails;

  /// Subtitle for booking details step
  ///
  /// In en, this message translates to:
  /// **'Add your location and any additional details'**
  String get addLocationAndDetails;

  /// Title for confirmation step
  ///
  /// In en, this message translates to:
  /// **'Confirm Booking'**
  String get confirmBooking;

  /// Subtitle for confirmation step
  ///
  /// In en, this message translates to:
  /// **'Review your booking details before confirming'**
  String get reviewBookingBeforeConfirming;

  /// Back button text
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Next button text
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Confirmation question shown when booking; placeholders: date,time
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to book this provider on {date} at {time}?'**
  String confirmBookingQuestion(Object date, Object time);

  /// Helper text shown on providers initial screen
  ///
  /// In en, this message translates to:
  /// **'Use the search bar above to find providers'**
  String get useSearchBarToFindProviders;

  /// Short kilometers unit
  ///
  /// In en, this message translates to:
  /// **'km'**
  String get kmShort;

  /// Plus sign used after minimum rating
  ///
  /// In en, this message translates to:
  /// **'+'**
  String get plusSign;

  /// Empty reviews text
  ///
  /// In en, this message translates to:
  /// **'No reviews yet'**
  String get noReviewsYet;

  /// Reviews load failure text
  ///
  /// In en, this message translates to:
  /// **'Failed to load reviews'**
  String get failedToLoadReviews;

  /// Provider contact information header
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get contactInformation;

  /// Phone label
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// Email label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Location label
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get locationLabel;

  /// Verified tag
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// Verified provider badge text
  ///
  /// In en, this message translates to:
  /// **'Verified Provider'**
  String get verifiedProvider;

  /// Call button label
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get callLabel;

  /// Email button label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// Snackbar when review submission fails
  ///
  /// In en, this message translates to:
  /// **'Could not submit review'**
  String get couldNotSubmitReview;

  /// Title for review screen
  ///
  /// In en, this message translates to:
  /// **'Leave a Review'**
  String get leaveAReview;

  /// Label for review rating prompt
  ///
  /// In en, this message translates to:
  /// **'Rate the provider'**
  String get rateProvider;

  /// Hint text for review input
  ///
  /// In en, this message translates to:
  /// **'Share your experience'**
  String get shareYourExperience;

  /// Snackbar when marking all chats as read
  ///
  /// In en, this message translates to:
  /// **'All chats marked as read'**
  String get allChatsMarkedRead;

  /// Snackbar when failing to mark chats as read
  ///
  /// In en, this message translates to:
  /// **'Failed to mark chats as read'**
  String get failedToMarkChatsRead;

  /// Snackbar when archiving a chat
  ///
  /// In en, this message translates to:
  /// **'Chat archived'**
  String get chatArchived;

  /// Snackbar when failing to archive a chat
  ///
  /// In en, this message translates to:
  /// **'Failed to archive chat'**
  String get failedToArchiveChat;

  /// Snackbar when muting a chat
  ///
  /// In en, this message translates to:
  /// **'Chat muted'**
  String get chatMuted;

  /// Snackbar when failing to mute a chat
  ///
  /// In en, this message translates to:
  /// **'Failed to mute chat'**
  String get failedToMuteChat;

  /// Snackbar when a user is unblocked
  ///
  /// In en, this message translates to:
  /// **'User unblocked'**
  String get userUnblocked;

  /// Snackbar when a user is blocked
  ///
  /// In en, this message translates to:
  /// **'User blocked'**
  String get userBlocked;

  /// Snackbar when a chat is deleted
  ///
  /// In en, this message translates to:
  /// **'Chat deleted'**
  String get chatDeleted;

  /// Snackbar when failing to delete a chat
  ///
  /// In en, this message translates to:
  /// **'Failed to delete chat'**
  String get failedToDeleteChat;

  /// Unblock button text
  ///
  /// In en, this message translates to:
  /// **'Unblock'**
  String get unblock;

  /// Title for starting a new conversation
  ///
  /// In en, this message translates to:
  /// **'Start New Conversation'**
  String get startNewConversation;

  /// Snackbar when a booking is updated
  ///
  /// In en, this message translates to:
  /// **'Booking updated'**
  String get bookingUpdated;

  /// Error when maps cannot be opened
  ///
  /// In en, this message translates to:
  /// **'Could not open maps'**
  String get couldNotOpenMaps;

  /// Error when location is not available
  ///
  /// In en, this message translates to:
  /// **'Location not available'**
  String get locationNotAvailable;

  /// Error when review screen cannot be opened
  ///
  /// In en, this message translates to:
  /// **'Could not open review screen'**
  String get couldNotOpenReviewScreen;

  /// Prompt asking user to provide a cancellation reason
  ///
  /// In en, this message translates to:
  /// **'Please provide a cancellation reason'**
  String get pleaseProvideCancellationReason;

  /// Snackbar when booking rescheduled
  ///
  /// In en, this message translates to:
  /// **'Booking rescheduled successfully!'**
  String get bookingRescheduledSuccess;

  /// Snackbar when reschedule undone
  ///
  /// In en, this message translates to:
  /// **'Reschedule undone'**
  String get rescheduleUndone;

  /// Snackbar when undo reschedule fails
  ///
  /// In en, this message translates to:
  /// **'Unable to undo reschedule'**
  String get unableToUndoReschedule;

  /// Error when failing to pick image
  ///
  /// In en, this message translates to:
  /// **'Failed to pick image: {error}'**
  String failedToPickImage(Object error);

  /// Snackbar when location services disabled
  ///
  /// In en, this message translates to:
  /// **'Location services are disabled.'**
  String get locationServicesDisabled;

  /// Snackbar when location permission denied
  ///
  /// In en, this message translates to:
  /// **'Location permission denied'**
  String get locationPermissionDenied;

  /// Snackbar when current location is detected
  ///
  /// In en, this message translates to:
  /// **'Current location detected'**
  String get currentLocationDetected;

  /// Label for service location section
  ///
  /// In en, this message translates to:
  /// **'Service Location'**
  String get serviceLocation;

  /// Address input label
  ///
  /// In en, this message translates to:
  /// **'Enter your address'**
  String get enterYourAddress;

  /// Address input hint
  ///
  /// In en, this message translates to:
  /// **'Street, City, State, ZIP'**
  String get addressHint;

  /// Button label to use current GPS location
  ///
  /// In en, this message translates to:
  /// **'Use Current Location'**
  String get useCurrentLocation;

  /// Button label to pick a location on the map
  ///
  /// In en, this message translates to:
  /// **'Select on Map'**
  String get selectOnMap;

  /// Notes section title
  ///
  /// In en, this message translates to:
  /// **'Additional Notes'**
  String get additionalNotes;

  /// Label asking user to describe the issue
  ///
  /// In en, this message translates to:
  /// **'Describe the issue or special instructions'**
  String get describeIssueLabel;

  /// Hint text for issue description
  ///
  /// In en, this message translates to:
  /// **'e.g., Leaky faucet in kitchen, bring specific tools...'**
  String get describeIssueHint;

  /// Priority/urgent section title
  ///
  /// In en, this message translates to:
  /// **'Service Priority'**
  String get servicePriority;

  /// Urgent service toggle title
  ///
  /// In en, this message translates to:
  /// **'Urgent Service'**
  String get urgentService;

  /// Description for urgent scheduling
  ///
  /// In en, this message translates to:
  /// **'Priority scheduling with additional fees'**
  String get priorityScheduling;

  /// Description for standard scheduling
  ///
  /// In en, this message translates to:
  /// **'Standard scheduling'**
  String get standardScheduling;

  /// Note about urgent services
  ///
  /// In en, this message translates to:
  /// **'Urgent services may have additional charges and faster response times.'**
  String get urgentServicesNote;

  /// Attachments section title
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get attachments;

  /// Hint telling user to add photos
  ///
  /// In en, this message translates to:
  /// **'Add photos to help describe the issue'**
  String get addPhotosToDescribe;

  /// Camera button label
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// Gallery pick button label
  ///
  /// In en, this message translates to:
  /// **'Choose Photo'**
  String get choosePhoto;

  /// Important information section title
  ///
  /// In en, this message translates to:
  /// **'Important Information'**
  String get importantInformation;

  /// Guarantee title
  ///
  /// In en, this message translates to:
  /// **'Service Guarantee'**
  String get serviceGuarantee;

  /// Guarantee description
  ///
  /// In en, this message translates to:
  /// **'All services come with quality guarantee'**
  String get serviceGuaranteeDesc;

  /// Payment title
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// Payment description
  ///
  /// In en, this message translates to:
  /// **'Pay securely after service completion'**
  String get paymentDesc;

  /// Communication title
  ///
  /// In en, this message translates to:
  /// **'Communication'**
  String get communication;

  /// Communication description
  ///
  /// In en, this message translates to:
  /// **'Track your service provider in real-time'**
  String get communicationDesc;

  /// Reviews description
  ///
  /// In en, this message translates to:
  /// **'Rate and review after service completion'**
  String get reviewsDesc;

  /// Prompt to tap on the map to pick a location
  ///
  /// In en, this message translates to:
  /// **'Tap on the map to pick a location'**
  String get tapOnMapToPickLocation;

  /// Snackbar when a location is picked from the map
  ///
  /// In en, this message translates to:
  /// **'Location selected from map'**
  String get locationSelectedFromMap;

  /// FAB label to book a service
  ///
  /// In en, this message translates to:
  /// **'Book Service'**
  String get bookService;

  /// Title for bookings screen
  ///
  /// In en, this message translates to:
  /// **'My Bookings'**
  String get myBookings;

  /// Upcoming bookings label
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// Booking history label
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// Cancelled bookings label
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// In progress bookings label
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgress;

  /// Completed bookings label
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// Error when bookings fail to load
  ///
  /// In en, this message translates to:
  /// **'Failed to load bookings'**
  String get failedToLoadBookings;

  /// Empty bookings list text
  ///
  /// In en, this message translates to:
  /// **'No bookings yet'**
  String get noBookingsYet;

  /// Label indicating the role of the provider
  ///
  /// In en, this message translates to:
  /// **'Service Provider'**
  String get serviceProvider;

  /// Urgent badge text
  ///
  /// In en, this message translates to:
  /// **'URGENT'**
  String get urgent;

  /// Modify button text
  ///
  /// In en, this message translates to:
  /// **'Modify'**
  String get modify;

  /// Call provider option text
  ///
  /// In en, this message translates to:
  /// **'Call Provider'**
  String get callProvider;

  /// Track provider option text
  ///
  /// In en, this message translates to:
  /// **'Track Provider'**
  String get trackProvider;

  /// Track button text
  ///
  /// In en, this message translates to:
  /// **'Track'**
  String get track;

  /// Review button text
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get review;

  /// Rescheduled status text
  ///
  /// In en, this message translates to:
  /// **'Rescheduled'**
  String get rescheduled;

  /// Prefix for no X bookings message
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get noXBookingsPrefix;

  /// Suffix for no X bookings message
  ///
  /// In en, this message translates to:
  /// **'bookings'**
  String get noXBookingsSuffix;

  /// Prompt to book first service
  ///
  /// In en, this message translates to:
  /// **'Book your first service to get started'**
  String get bookYourFirstService;

  /// Prompt when filtered results empty
  ///
  /// In en, this message translates to:
  /// **'Try selecting a different filter'**
  String get trySelectingDifferentFilter;

  /// Button label to browse services
  ///
  /// In en, this message translates to:
  /// **'Browse Services'**
  String get browseServices;

  /// Fallback unknown state text
  ///
  /// In en, this message translates to:
  /// **'Unknown state'**
  String get unknownState;

  /// Snackbar on booking cancelled
  ///
  /// In en, this message translates to:
  /// **'Booking cancelled successfully'**
  String get bookingCancelledSuccess;

  /// Chat tab title
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// Search hint for conversations
  ///
  /// In en, this message translates to:
  /// **'Search conversations...'**
  String get searchConversationsHint;

  /// Empty state when search yields no results
  ///
  /// In en, this message translates to:
  /// **'No matching conversations'**
  String get noMatchingConversations;

  /// Empty chats list text
  ///
  /// In en, this message translates to:
  /// **'No conversations yet'**
  String get noConversationsYet;

  /// Suggestion when search returns no results
  ///
  /// In en, this message translates to:
  /// **'Try searching with different keywords'**
  String get trySearchingDifferentKeywords;

  /// Prompt to start conversation
  ///
  /// In en, this message translates to:
  /// **'Start a conversation with a service provider'**
  String get startConversationWithProvider;

  /// Option to find provider
  ///
  /// In en, this message translates to:
  /// **'Find Service Provider'**
  String get findServiceProvider;

  /// Subtitle for finding providers
  ///
  /// In en, this message translates to:
  /// **'Search and message providers'**
  String get searchAndMessageProviders;

  /// Option to message from recent bookings
  ///
  /// In en, this message translates to:
  /// **'From Recent Bookings'**
  String get fromRecentBookings;

  /// Subtitle for recent bookings option
  ///
  /// In en, this message translates to:
  /// **'Message providers from your bookings'**
  String get messageProvidersFromBookings;

  /// Contact support option title
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// Subtitle for contact support
  ///
  /// In en, this message translates to:
  /// **'Get help from our support team'**
  String get getHelpFromSupport;

  /// Label for creating a new booking
  ///
  /// In en, this message translates to:
  /// **'New Booking'**
  String get newBooking;

  /// No description provided for @ourServices.
  ///
  /// In en, this message translates to:
  /// **'Our Services'**
  String get ourServices;

  /// No description provided for @plumbing.
  ///
  /// In en, this message translates to:
  /// **'Plumbing'**
  String get plumbing;

  /// No description provided for @electrical.
  ///
  /// In en, this message translates to:
  /// **'Electrical'**
  String get electrical;

  /// No description provided for @cleaning.
  ///
  /// In en, this message translates to:
  /// **'Cleaning'**
  String get cleaning;

  /// No description provided for @painting.
  ///
  /// In en, this message translates to:
  /// **'Painting'**
  String get painting;

  /// No description provided for @carpentry.
  ///
  /// In en, this message translates to:
  /// **'Carpentry'**
  String get carpentry;

  /// No description provided for @acRepair.
  ///
  /// In en, this message translates to:
  /// **'AC Repair'**
  String get acRepair;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @genericErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again.'**
  String get genericErrorMessage;

  /// No description provided for @networkErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please check your connection and try again.'**
  String get networkErrorMessage;

  /// No description provided for @serverErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Server error. Please try again later.'**
  String get serverErrorMessage;

  /// No description provided for @authErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Session expired. Please log in again.'**
  String get authErrorMessage;

  /// No description provided for @signInSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Signed in successfully'**
  String get signInSuccessMessage;

  /// No description provided for @signUpSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully'**
  String get signUpSuccessMessage;

  /// No description provided for @bookingCreatedMessage.
  ///
  /// In en, this message translates to:
  /// **'Booking created successfully'**
  String get bookingCreatedMessage;

  /// No description provided for @profileUpdatedMessage.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdatedMessage;

  /// No description provided for @emailValidationMessage.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get emailValidationMessage;

  /// No description provided for @passwordValidationMessage.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters long'**
  String get passwordValidationMessage;

  /// No description provided for @nameValidationMessage.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get nameValidationMessage;

  /// No description provided for @phoneValidationMessage.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get phoneValidationMessage;

  /// No description provided for @pleaseEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterEmail;

  /// No description provided for @pleaseEnterAValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get pleaseEnterAValidEmail;

  /// No description provided for @pleaseEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterPassword;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters long'**
  String get passwordTooShort;

  /// No description provided for @pleaseEnterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get pleaseEnterName;

  /// No description provided for @nameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 characters long'**
  String get nameTooShort;

  /// No description provided for @pleaseEnterPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get pleaseEnterPhone;

  /// No description provided for @pleaseEnterAValidPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get pleaseEnterAValidPhone;

  /// No description provided for @pleaseConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get pleaseConfirmPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @pleaseEnterValue.
  ///
  /// In en, this message translates to:
  /// **'Please enter {fieldName}'**
  String pleaseEnterValue(Object fieldName);

  /// No description provided for @pleaseEnterAddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter your address'**
  String get pleaseEnterAddress;

  /// No description provided for @addressTooShort.
  ///
  /// In en, this message translates to:
  /// **'Please enter a more detailed address'**
  String get addressTooShort;

  /// No description provided for @pleaseEnterPrice.
  ///
  /// In en, this message translates to:
  /// **'Please enter the price'**
  String get pleaseEnterPrice;

  /// No description provided for @pleaseEnterAValidPrice.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid price'**
  String get pleaseEnterAValidPrice;

  /// No description provided for @priceGreaterThanZero.
  ///
  /// In en, this message translates to:
  /// **'Price must be greater than zero'**
  String get priceGreaterThanZero;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
