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
  String get paymentMethods => 'Payment Methods';

  @override
  String get bookings => 'Bookings';

  @override
  String get logoutTitle => 'Logout';

  @override
  String get logoutConfirm => 'Are you sure you want to logout?';

  @override
  String get english => 'English';

  @override
  String get arabic => 'Arabic';

  @override
  String get services => 'Services';

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
  String get categories => 'Categories';

  @override
  String get searchResults => 'Search Results';

  @override
  String get allServices => 'All Services';

  @override
  String get search => 'Search';

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
  String get providers => 'Providers';

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
  String get bookingDetails => 'Booking Details';

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
  String get emailLabel => 'Email';

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
  String get bookingUpdated => 'Booking updated';

  @override
  String get couldNotOpenMaps => 'Could not open maps';

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
  String get additionalNotes => 'Additional Notes';

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
  String get attachments => 'Attachments';

  @override
  String get addPhotosToDescribe => 'Add photos to help describe the issue';

  @override
  String get takePhoto => 'Take Photo';

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
  String get urgent => 'URGENT';

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
  String get contactSupport => 'Contact Support';

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
  String get cleaning => 'Cleaning';

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
  String get passwordsDoNotMatch => 'Passwords do not match';

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
