// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Fix It';

  @override
  String get settings => 'Settings';

  @override
  String get notifications => 'Notifications';

  @override
  String get pushNotifications => 'Push Notifications';

  @override
  String get pushNotificationsDesc => 'Receive notifications on your device';

  @override
  String get emailNotifications => 'Email Notifications';

  @override
  String get emailNotificationsDesc => 'Receive notifications via email';

  @override
  String get bookingReminders => 'Booking Reminders';

  @override
  String get bookingRemindersDesc => 'Get reminded about upcoming bookings';

  @override
  String get privacy => 'Privacy';

  @override
  String get locationServices => 'Location Services';

  @override
  String get locationServicesDesc => 'Allow app to access your location';

  @override
  String get dataSharing => 'Data Sharing';

  @override
  String get dataSharingDesc => 'Share anonymous usage data to improve the app';

  @override
  String get preferences => 'Preferences';

  @override
  String get language => 'Language';

  @override
  String get currency => 'Currency';

  @override
  String get about => 'About';

  @override
  String get helpSupport => 'Help & Support';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get selectCurrency => 'Select Currency';

  @override
  String get cancel => 'Cancel';

  @override
  String get settingsUpdatedSuccess => 'Settings updated successfully!';

  @override
  String get languageChangedSuccess => 'Language changed successfully!';

  @override
  String get errorLoadingSettings => 'Error loading settings';

  @override
  String get theme => 'Theme';

  @override
  String get privacyAndSecurity => 'Privacy & Security';

  @override
  String get resetSettings => 'Reset Settings';

  @override
  String get resetSettingsDesc => 'Restore default settings';

  @override
  String get resetSettingsConfirm =>
      'Are you sure you want to reset all settings to their default values?';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get system => 'System';

  @override
  String get currencyUSD => 'US Dollar (USD)';

  @override
  String get currencyEUR => 'Euro (EUR)';

  @override
  String get currencySAR => 'Saudi Riyal (SAR)';

  @override
  String get welcomeBack => 'Welcome Back!';

  @override
  String signInToContinue(Object appName) {
    return 'Sign in to continue to $appName';
  }

  @override
  String get emailLabel => 'Email';

  @override
  String get emailHint => 'Enter your email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordHint => 'Enter your password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get signIn => 'Sign In';

  @override
  String get or => 'OR';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get signInWithPhone => 'Sign In with Phone (Egypt)';

  @override
  String get dontHaveAnAccount => 'Don\'t have an account? ';

  @override
  String get signUp => 'Sign Up';

  @override
  String get createTechnicianAccount => 'Create Technician Account';

  @override
  String get welcomeTechnician => 'Welcome, Specialist!';

  @override
  String get fillYourProfessionalInfo =>
      'Fill in the following data to create your professional account';

  @override
  String get fullName => 'Full Name';

  @override
  String get enterYourFullName => 'Enter your full name';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get enterYourPhoneNumber => 'Enter your phone number';

  @override
  String get profession => 'Profession';

  @override
  String get selectYourProfession => 'Select your profession';

  @override
  String get pleaseSelectProfession => 'Please select a profession';

  @override
  String get other => 'Other';

  @override
  String get specifyYourProfession => 'Specify your profession';

  @override
  String get enterYourProfession => 'Enter your profession';

  @override
  String get pleaseSpecifyProfession => 'Please specify your profession';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get reEnterYourPassword => 'Re-enter your password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get iAgreeTo => 'I agree to the ';

  @override
  String get termsAndConditions => 'Terms and Conditions';

  @override
  String get and => ' and ';

  @override
  String get createAccount => 'Create Account';

  @override
  String get alreadyHaveAnAccount => 'Already have an account? ';

  @override
  String get profession_electrician => 'Electrician';

  @override
  String get profession_plumber => 'Plumber';

  @override
  String get profession_carpenter => 'Carpenter';

  @override
  String get profession_painter => 'Painter';

  @override
  String get profession_ac => 'AC & Refrigeration';

  @override
  String get profession_appliance => 'Appliance Technician';

  @override
  String get profession_electronics => 'Electronics Technician';

  @override
  String get profession_cleaning => 'Cleaning Worker';

  @override
  String get profession_gardener => 'Gardener';

  @override
  String get profession_decorator => 'Decorator';

  @override
  String get profession_tiler => 'Tiler';

  @override
  String get profession_blacksmith => 'Blacksmith';

  @override
  String get profession_glazier => 'Glazier';

  @override
  String get profession_roofer => 'Roofer';

  @override
  String get profession_mechanic => 'Car Mechanic';

  @override
  String get profession_phone_technician => 'Phone Maintenance Technician';

  @override
  String get profession_furniture => 'Furniture Assembly';

  @override
  String get createClientAccount => 'Create Client Account';

  @override
  String get welcomeClient => 'Welcome, Client!';

  @override
  String get fillYourInfo =>
      'Fill in the following data to create your account';

  @override
  String get welcomeSlogan =>
      'Your trusted partner for home\nmaintenance and repair services';

  @override
  String get createNewAccount => 'Create New Account';

  @override
  String get byContinuingYouAgree => 'By continuing, you agree to our ';

  @override
  String get bookingConfirmedSuccess => 'Booking confirmed successfully';

  @override
  String get bookingDetails => 'Booking Details';

  @override
  String bookingId(Object id) {
    return 'Booking ID: $id';
  }

  @override
  String service(Object serviceName) {
    return 'Service: $serviceName';
  }

  @override
  String provider(Object providerName) {
    return 'Provider: $providerName';
  }

  @override
  String when(Object date, Object time) {
    return 'When: $date $time';
  }

  @override
  String address(Object address) {
    return 'Address: $address';
  }

  @override
  String total(Object amount) {
    return 'Total: $amount';
  }

  @override
  String attachment(Object url) {
    return 'Attachment: $url';
  }

  @override
  String get couldNotFetchProviderDetails => 'Could not fetch provider details';

  @override
  String get couldNotOpenDialer => 'Could not open dialer';

  @override
  String get providerPhoneNotAvailable => 'Provider phone not available';

  @override
  String get couldNotStartChat => 'Could not start chat';

  @override
  String get serviceInformation => 'Service Information';

  @override
  String get urgent => 'URGENT';

  @override
  String estimatedDuration(Object duration) {
    return 'Estimated Duration: $duration minutes';
  }

  @override
  String get schedule => 'Schedule';

  @override
  String get location => 'Location';

  @override
  String get viewOnMap => 'View on Map';

  @override
  String get couldNotOpenMaps => 'Could not open maps';

  @override
  String get priceBreakdown => 'Price Breakdown';

  @override
  String get servicePrice => 'Service Price';

  @override
  String get taxes => 'Taxes';

  @override
  String get platformFee => 'Platform Fee';

  @override
  String get totalAmount => 'Total Amount';

  @override
  String get additionalNotes => 'Additional Notes';

  @override
  String get attachments => 'Attachments';

  @override
  String attachmentLabel(Object index) {
    return 'Attachment $index';
  }

  @override
  String get reschedule => 'Reschedule';

  @override
  String get bookingUpdated => 'Booking updated';

  @override
  String get cancelBooking => 'Cancel Booking';

  @override
  String get confirmCompletionCash => 'Confirm Completion (Cash Payment)';

  @override
  String get contactSupport => 'Contact Support';

  @override
  String get areYouSureCancelBooking =>
      'Are you sure you want to cancel this booking?';

  @override
  String get reasonForCancellation => 'Reason for cancellation';

  @override
  String get keepBooking => 'Keep Booking';

  @override
  String get error => 'Error';

  @override
  String get failedToLoadBookingDetails => 'Failed to load booking details';

  @override
  String get markAllAsRead => 'Mark All as Read';

  @override
  String get deleteAllNotifications => 'Delete All Notifications';

  @override
  String get errorLoadingNotifications => 'Error loading notifications';

  @override
  String get deleteNotification => 'Delete Notification';

  @override
  String get areYouSureDeleteNotification =>
      'Are you sure you want to delete this notification?';

  @override
  String get delete => 'Delete';

  @override
  String get areYouSureDeleteAllNotifications =>
      'Are you sure you want to delete all notifications? This action cannot be undone.';

  @override
  String get deleteAll => 'Delete All';

  @override
  String get all => 'All';

  @override
  String get noMatchingNotifications => 'No matching notifications';

  @override
  String get noNotifications => 'No notifications';

  @override
  String get noNotificationsFoundForFilter =>
      'We couldn\'t find any notifications matching the selected filter';

  @override
  String get allYourNotificationsWillAppearHere =>
      'All your notifications will appear here when they arrive';

  @override
  String get removeFilter => 'Remove Filter';

  @override
  String get notificationsHint =>
      'You will receive notifications about your bookings and our special offers';

  @override
  String get now => 'Now';

  @override
  String minutesAgo(Object minutes) {
    return '${minutes}m ago';
  }

  @override
  String hoursAgo(Object hours) {
    return '${hours}h ago';
  }

  @override
  String daysAgo(Object days) {
    return '${days}d ago';
  }

  @override
  String get notificationType_bookingConfirmation => 'Booking Confirmation';

  @override
  String get notificationType_bookingCancelled => 'Booking Cancelled';

  @override
  String get notificationType_bookingCompleted => 'Booking Completed';

  @override
  String get notificationType_paymentSuccess => 'Payment Success';

  @override
  String get notificationType_paymentFailed => 'Payment Failed';

  @override
  String get notificationType_specialOffer => 'Special Offer';

  @override
  String get notificationType_appUpdate => 'App Update';

  @override
  String get notificationType_reviewRequest => 'Review Request';

  @override
  String get notificationType_bookingReminder => 'Booking Reminder';

  @override
  String get notificationType_providerAssigned => 'Provider Assigned';

  @override
  String get notificationType_general => 'General';

  @override
  String get takePhoto => 'Take Photo';

  @override
  String get chooseFromGallery => 'Choose from Gallery';

  @override
  String get paymentMethods => 'Payment Methods';

  @override
  String get memberSince => 'Member Since';

  @override
  String get status => 'Status';

  @override
  String get active => 'Active';

  @override
  String years(Object count) {
    return '$count years';
  }

  @override
  String months(Object count) {
    return '$count months';
  }

  @override
  String days(Object count) {
    return '$count days';
  }

  @override
  String get invalidUserType => 'Invalid user type';

  @override
  String errorSelectingUserType(Object error) {
    return 'Error selecting user type: $error';
  }

  @override
  String get failedToLoadSettings => 'Failed to load settings';

  @override
  String unexpectedError(Object error) {
    return 'An unexpected error occurred: $error';
  }

  @override
  String get failedToUpdateSettings => 'Failed to update settings';

  @override
  String errorUpdatingSettings(Object error) {
    return 'Error updating settings: $error';
  }

  @override
  String get failedToResetSettings => 'Failed to reset settings';

  @override
  String errorResettingSettings(Object error) {
    return 'Error resetting settings: $error';
  }

  @override
  String get failedToLoadProfile => 'Failed to load profile data';

  @override
  String get failedToUpdateProfile => 'Failed to update profile data';

  @override
  String get galleryPermissionDenied =>
      'Permission to access gallery was denied';

  @override
  String get cameraAccessDenied => 'Camera access was denied or cancelled';

  @override
  String get failedToUploadProfilePicture => 'Failed to upload profile picture';

  @override
  String get failedToUpdateProfileAfterUpload =>
      'Failed to update profile after upload';

  @override
  String get failedToDeleteProfilePicture => 'Failed to delete profile picture';

  @override
  String get contactType_email => 'Email';

  @override
  String get contactType_phone => 'Phone';

  @override
  String get contactType_whatsapp => 'WhatsApp';

  @override
  String get contactType_website => 'Website';

  @override
  String get contactType_social => 'Social Media';

  @override
  String get search => 'Search';

  @override
  String get searchForServiceOrProvider =>
      'Search for a service or provider...';

  @override
  String get services => 'Services';

  @override
  String get providers => 'Providers';

  @override
  String get noSearchResults => 'No search results';

  @override
  String errorOcurred(Object message) {
    return 'An error occurred: $message';
  }

  @override
  String get recentSearches => 'Recent Searches';

  @override
  String get plumber => 'Plumber';

  @override
  String get electrician => 'Electrician';

  @override
  String get cleaning => 'Cleaning';

  @override
  String get ac => 'AC';

  @override
  String get noServicesMatchYourSearch => 'No services match your search';

  @override
  String get noProvidersMatchYourSearch => 'No providers match your search';

  @override
  String get helpAndSupport => 'Help & Support';

  @override
  String get faq => 'FAQ';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get aboutApp => 'About App';

  @override
  String get categories => 'Categories';

  @override
  String get bookings => 'Bookings';

  @override
  String get payments => 'Payments';

  @override
  String get account => 'Account';

  @override
  String get weAreHereToHelp => 'We are here to help';

  @override
  String get customerSupportHint =>
      'Our customer support team is available 24/7 to answer your questions';

  @override
  String get sendDirectMessage => 'Send Direct Message';

  @override
  String get appVersion => 'Version 1.0.0';

  @override
  String get appDescription =>
      'A comprehensive platform for home maintenance and repair services. We connect you with the best certified technicians in your area to provide high-quality and reliable services.';

  @override
  String get appFeatures => 'App Features';

  @override
  String get feature_certifiedTechnicians =>
      'Certified and qualified technicians';

  @override
  String get feature_247Support => '24/7 customer service';

  @override
  String get feature_transparentPricing => 'Transparent and fair prices';

  @override
  String get feature_serviceWarranty => 'Warranty on all services';

  @override
  String get feature_liveTracking => 'Live tracking of orders';

  @override
  String get feature_realReviews => 'Real customer reviews';

  @override
  String get legalInformation => 'Legal Information';

  @override
  String get refundPolicy => 'Refund Policy';

  @override
  String get termsOfUse => 'Terms of Use';

  @override
  String get copyright => '© 2024 Fix It. All rights reserved.';

  @override
  String get contact_callUs => 'Call us directly';

  @override
  String get contact_whatsapp => 'Message us on WhatsApp';

  @override
  String get contact_email => 'Send us an email';

  @override
  String get faq_q1 => 'How can I book a maintenance service?';

  @override
  String get faq_a1 =>
      'You can easily book a maintenance service through the app. Choose the required service type, select the location and suitable time, then choose the appropriate technician from the available list.';

  @override
  String get faq_q2 => 'What are the available payment methods?';

  @override
  String get faq_a2 =>
      'We accept all major payment methods including credit cards, Apple Pay, as well as cash payment upon service completion.';

  @override
  String get faq_q3 => 'Can I cancel or modify a booking appointment?';

  @override
  String get faq_a3 =>
      'Yes, you can cancel or modify a booking appointment at least 4 hours before the scheduled time without any additional fees.';

  @override
  String get faq_q4 => 'How can I rate the service?';

  @override
  String get faq_a4 =>
      'After the service is completed, you will receive a notification to rate the service and the technician. You can give a rating from 1 to 5 stars and write a comment about your experience.';

  @override
  String get emailSubject_inquiry => 'Inquiry from Fix It App';

  @override
  String get noResultsFound => 'No results found';

  @override
  String get tryDifferentKeywords => 'Try searching with different keywords';

  @override
  String searchResultsCount(Object count) {
    return 'Search Results ($count)';
  }

  @override
  String get searchFaqHint => 'Search in FAQ...';

  @override
  String get contactMethods => 'Contact Methods';

  @override
  String cannotOpen(Object description) {
    return 'Cannot open $description';
  }

  @override
  String errorOpening(Object description) {
    return 'Error opening $description';
  }

  @override
  String get errorLoadingData => 'Error loading data';

  @override
  String get profileUpdateSubtitle => 'Update your personal information';

  @override
  String get changePasswordSubtitle => 'Update your password';

  @override
  String get managePaymentSubtitle => 'Manage your cards and payment methods';

  @override
  String get viewBookingsSubtitle => 'View your past bookings';

  @override
  String get notificationsSubtitle => 'Manage your notification preferences';

  @override
  String get helpSupportSubtitle => 'FAQs and contact us';

  @override
  String get aboutSubtitle => 'Information about Fix It';

  @override
  String get logoutSubtitle => 'Sign out of your account';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profile => 'Profile';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get changePassword => 'Change Password';

  @override
  String get logoutTitle => 'Logout';

  @override
  String get logoutConfirm => 'Are you sure you want to logout?';

  @override
  String get english => 'English';

  @override
  String get arabic => 'Arabic';

  @override
  String get searchServices => 'Search Services';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get noServicesAvailable => 'No services available';

  @override
  String get searchHint => 'Search services...';

  @override
  String get searchResults => 'Search Results';

  @override
  String get allServices => 'All Services';

  @override
  String get noServicesFound => 'No services found';

  @override
  String get tryAdjustingSearch => 'Try adjusting your search or filters';

  @override
  String get oopsSomethingWrong => 'Oops! Something went wrong';

  @override
  String get retry => 'Retry';

  @override
  String get filterServices => 'Filter Services';

  @override
  String get comingSoon => 'Coming Soon...';

  @override
  String get close => 'Close';

  @override
  String get serviceDetails => 'Service Details';

  @override
  String get errorLoadingService => 'Error loading service';

  @override
  String get available => 'Available';

  @override
  String get unavailable => 'Unavailable';

  @override
  String get price => 'Price';

  @override
  String get duration => 'Duration';

  @override
  String get descriptionLabel => 'Description';

  @override
  String categoryLabel(Object category) {
    return 'Category: $category';
  }

  @override
  String get gallery => 'Gallery';

  @override
  String get bookNow => 'Book Now';

  @override
  String get contactProvider => 'Contact Provider';

  @override
  String get minutesShort => 'm';

  @override
  String get reviews => 'reviews';

  @override
  String get termsComingSoon => 'Terms of Service screen coming soon!';

  @override
  String get privacyComingSoon => 'Privacy Policy screen coming soon!';

  @override
  String get spanish => 'Spanish';

  @override
  String get french => 'French';

  @override
  String get german => 'German';

  @override
  String get serviceProviders => 'Service Providers';

  @override
  String get noProvidersFound => 'No providers found';

  @override
  String get tryAdjustingFilters => 'Try adjusting your search or filters';

  @override
  String get nearby => 'Nearby';

  @override
  String get sort => 'Sort';

  @override
  String get filters => 'Filters';

  @override
  String get distance => 'Distance';

  @override
  String get rating => 'Rating';

  @override
  String get min => 'Min';

  @override
  String get max => 'Max';

  @override
  String get verifiedProvidersOnly => 'Verified Providers Only';

  @override
  String get reset => 'Reset';

  @override
  String get apply => 'Apply';

  @override
  String get availableLabel => 'Available';

  @override
  String get busyLabel => 'Busy';

  @override
  String get reviewsLabel => 'Reviews';

  @override
  String get availableTimeSlotsTitle => 'Available Time Slots';

  @override
  String get noAvailableTimeSlots => 'No available time slots for this day';

  @override
  String get selectDateToViewSlots =>
      'Select a date to view available time slots';

  @override
  String get selectDate => 'Select Date';

  @override
  String get choosePreferredDate =>
      'Choose your preferred date for the service';

  @override
  String get selectTime => 'Select Time';

  @override
  String availableTimesForDate(Object date) {
    return 'Available times for $date';
  }

  @override
  String get pleaseSelectDateFirst => 'Please select a date first';

  @override
  String get failedToLoadTimeSlots => 'Failed to load time slots';

  @override
  String get addLocationAndDetails =>
      'Add your location and any additional details';

  @override
  String get confirmBooking => 'Confirm Booking';

  @override
  String get reviewBookingBeforeConfirming =>
      'Review your booking details before confirming';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String confirmBookingQuestion(Object date, Object time) {
    return 'Are you sure you want to book this provider on $date at $time?';
  }

  @override
  String get useSearchBarToFindProviders =>
      'Use the search bar above to find providers';

  @override
  String get kmShort => 'km';

  @override
  String get plusSign => '+';

  @override
  String get noReviewsYet => 'No reviews yet';

  @override
  String get failedToLoadReviews => 'Failed to load reviews';

  @override
  String get contactInformation => 'Contact Information';

  @override
  String get phone => 'Phone';

  @override
  String get email => 'Email';

  @override
  String get locationLabel => 'Location';

  @override
  String get verified => 'Verified';

  @override
  String get verifiedProvider => 'Verified Provider';

  @override
  String get callLabel => 'Call';

  @override
  String get couldNotSubmitReview => 'Could not submit review';

  @override
  String get leaveAReview => 'Leave a Review';

  @override
  String get rateProvider => 'Rate the provider';

  @override
  String get shareYourExperience => 'Share your experience';

  @override
  String get allChatsMarkedRead => 'All chats marked as read';

  @override
  String get failedToMarkChatsRead => 'Failed to mark chats as read';

  @override
  String get chatArchived => 'Chat archived';

  @override
  String get failedToArchiveChat => 'Failed to archive chat';

  @override
  String get chatMuted => 'Chat muted';

  @override
  String get failedToMuteChat => 'Failed to mute chat';

  @override
  String get userUnblocked => 'User unblocked';

  @override
  String get userBlocked => 'User blocked';

  @override
  String get chatDeleted => 'Chat deleted';

  @override
  String get failedToDeleteChat => 'Failed to delete chat';

  @override
  String get unblock => 'Unblock';

  @override
  String get startNewConversation => 'Start New Conversation';

  @override
  String get locationNotAvailable => 'Location not available';

  @override
  String get couldNotOpenReviewScreen => 'Could not open review screen';

  @override
  String get pleaseProvideCancellationReason =>
      'Please provide a cancellation reason';

  @override
  String get bookingRescheduledSuccess => 'Booking rescheduled successfully!';

  @override
  String get rescheduleUndone => 'Reschedule undone';

  @override
  String get unableToUndoReschedule => 'Unable to undo reschedule';

  @override
  String failedToPickImage(Object error) {
    return 'Failed to pick image: $error';
  }

  @override
  String get locationServicesDisabled => 'Location services are disabled.';

  @override
  String get locationPermissionDenied => 'Location permission denied';

  @override
  String get currentLocationDetected => 'Current location detected';

  @override
  String get serviceLocation => 'Service Location';

  @override
  String get enterYourAddress => 'Enter your address';

  @override
  String get addressHint => 'Street, City, State, ZIP';

  @override
  String get useCurrentLocation => 'Use Current Location';

  @override
  String get selectOnMap => 'Select on Map';

  @override
  String get describeIssueLabel => 'Describe the issue or special instructions';

  @override
  String get describeIssueHint =>
      'e.g., Leaky faucet in kitchen, bring specific tools...';

  @override
  String get servicePriority => 'Service Priority';

  @override
  String get urgentService => 'Urgent Service';

  @override
  String get priorityScheduling => 'Priority scheduling with additional fees';

  @override
  String get standardScheduling => 'Standard scheduling';

  @override
  String get urgentServicesNote =>
      'Urgent services may have additional charges and faster response times.';

  @override
  String get addPhotosToDescribe => 'Add photos to help describe the issue';

  @override
  String get choosePhoto => 'Choose Photo';

  @override
  String get importantInformation => 'Important Information';

  @override
  String get serviceGuarantee => 'Service Guarantee';

  @override
  String get serviceGuaranteeDesc => 'All services come with quality guarantee';

  @override
  String get payment => 'Payment';

  @override
  String get paymentDesc => 'Pay securely after service completion';

  @override
  String get communication => 'Communication';

  @override
  String get communicationDesc => 'Track your service provider in real-time';

  @override
  String get reviewsDesc => 'Rate and review after service completion';

  @override
  String get tapOnMapToPickLocation => 'Tap on the map to pick a location';

  @override
  String get locationSelectedFromMap => 'Location selected from map';

  @override
  String get bookService => 'Book Service';

  @override
  String get myBookings => 'My Bookings';

  @override
  String get upcoming => 'Upcoming';

  @override
  String get history => 'History';

  @override
  String get cancelled => 'Cancelled';

  @override
  String get inProgress => 'In Progress';

  @override
  String get completed => 'Completed';

  @override
  String get failedToLoadBookings => 'Failed to load bookings';

  @override
  String get noBookingsYet => 'No bookings yet';

  @override
  String get serviceProvider => 'Service Provider';

  @override
  String get modify => 'Modify';

  @override
  String get callProvider => 'Call Provider';

  @override
  String get trackProvider => 'Track Provider';

  @override
  String get track => 'Track';

  @override
  String get review => 'Review';

  @override
  String get rescheduled => 'Rescheduled';

  @override
  String get noXBookingsPrefix => 'No';

  @override
  String get noXBookingsSuffix => 'bookings';

  @override
  String get bookYourFirstService => 'Book your first service to get started';

  @override
  String get trySelectingDifferentFilter => 'Try selecting a different filter';

  @override
  String get browseServices => 'Browse Services';

  @override
  String get unknownState => 'Unknown state';

  @override
  String get bookingCancelledSuccess => 'Booking cancelled successfully';

  @override
  String get messages => 'Messages';

  @override
  String get searchConversationsHint => 'Search conversations...';

  @override
  String get noMatchingConversations => 'No matching conversations';

  @override
  String get noConversationsYet => 'No conversations yet';

  @override
  String get trySearchingDifferentKeywords =>
      'Try searching with different keywords';

  @override
  String get startConversationWithProvider =>
      'Start a conversation with a service provider';

  @override
  String get findServiceProvider => 'Find Service Provider';

  @override
  String get searchAndMessageProviders => 'Search and message providers';

  @override
  String get fromRecentBookings => 'From Recent Bookings';

  @override
  String get messageProvidersFromBookings =>
      'Message providers from your bookings';

  @override
  String get getHelpFromSupport => 'Get help from our support team';

  @override
  String get newBooking => 'New Booking';

  @override
  String get ourServices => 'Our Services';

  @override
  String get plumbing => 'Plumbing';

  @override
  String get electrical => 'Electrical';

  @override
  String get painting => 'Painting';

  @override
  String get carpentry => 'Carpentry';

  @override
  String get acRepair => 'AC Repair';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get genericErrorMessage =>
      'An unexpected error occurred. Please try again.';

  @override
  String get networkErrorMessage =>
      'No internet connection. Please check your connection and try again.';

  @override
  String get serverErrorMessage => 'Server error. Please try again later.';

  @override
  String get authErrorMessage => 'Session expired. Please log in again.';

  @override
  String get signInSuccessMessage => 'Signed in successfully';

  @override
  String get signUpSuccessMessage => 'Account created successfully';

  @override
  String get bookingCreatedMessage => 'Booking created successfully';

  @override
  String get profileUpdatedMessage => 'Profile updated successfully';

  @override
  String get emailValidationMessage => 'Please enter a valid email address';

  @override
  String get passwordValidationMessage =>
      'Password must be at least 8 characters long';

  @override
  String get nameValidationMessage => 'Please enter your name';

  @override
  String get phoneValidationMessage => 'Please enter a valid phone number';

  @override
  String get pleaseEnterEmail => 'Please enter your email';

  @override
  String get pleaseEnterAValidEmail => 'Please enter a valid email';

  @override
  String get pleaseEnterPassword => 'Please enter your password';

  @override
  String get passwordTooShort => 'Password must be at least 8 characters long';

  @override
  String get pleaseEnterName => 'Please enter your name';

  @override
  String get nameTooShort => 'Name must be at least 2 characters long';

  @override
  String get pleaseEnterPhone => 'Please enter your phone number';

  @override
  String get pleaseEnterAValidPhone => 'Please enter a valid phone number';

  @override
  String get pleaseConfirmPassword => 'Please confirm your password';

  @override
  String pleaseEnterValue(Object fieldName) {
    return 'Please enter $fieldName';
  }

  @override
  String get pleaseEnterAddress => 'Please enter your address';

  @override
  String get addressTooShort => 'Please enter a more detailed address';

  @override
  String get pleaseEnterPrice => 'Please enter the price';

  @override
  String get pleaseEnterAValidPrice => 'Please enter a valid price';

  @override
  String get priceGreaterThanZero => 'Price must be greater than zero';
}
