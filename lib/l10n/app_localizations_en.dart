// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Balaghi App';

  @override
  String get home => 'Home';

  @override
  String get reports => 'Reports';

  @override
  String get status => 'Status';

  @override
  String get settings => 'Settings';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get logout => 'Logout';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get verifyOtp => 'Verify OTP';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get fullName => 'Full Name';

  @override
  String get signIn => 'Sign In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get signInToContinue => 'Sign in to continue';

  @override
  String get createAccount => 'Create Account';

  @override
  String get signUpToGetStarted => 'Sign up to get started';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get theme => 'Theme';

  @override
  String get language => 'Language';

  @override
  String get arabic => 'Arabic';

  @override
  String get english => 'English';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get auto => 'Auto';

  @override
  String get selectTheme => 'Select Theme';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get notifications => 'Notifications';

  @override
  String get manageNotifications => 'Manage notifications';

  @override
  String get security => 'Security';

  @override
  String get securityAndPrivacy => 'Security and privacy settings';

  @override
  String get help => 'Help';

  @override
  String get faqAndSupport => 'Frequently asked questions and support';

  @override
  String get logoutConfirmation => 'Logout Confirmation';

  @override
  String get logoutMessage => 'Are you sure you want to logout?';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get profile => 'Profile';

  @override
  String get user => 'User';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get verifyYourEmail => 'Verify Your Email';

  @override
  String enter6DigitCode(String email) {
    return 'Enter the 6-digit code sent to\n$email';
  }

  @override
  String get verify => 'Verify';

  @override
  String get sendResetLink => 'Send Reset Link';

  @override
  String get enterEmailToReset =>
      'Enter your email address and we\'ll send you a link to reset your password.';

  @override
  String get welcome => 'Welcome';

  @override
  String get toBalaghiApp => 'to Balaghi App';

  @override
  String get quickServices => 'Quick Services';

  @override
  String get newReport => 'New Report';

  @override
  String get trackReports => 'Track Reports';

  @override
  String get downloadReports => 'Download Reports';

  @override
  String get myReports => 'My Reports';

  @override
  String get viewAllSentReports => 'View all sent reports';

  @override
  String get history => 'History';

  @override
  String get viewPreviousReports => 'View previous reports';

  @override
  String get downloadReportsPdf => 'Download reports as PDF';

  @override
  String get reportStatus => 'Report Status';

  @override
  String get inProgress => 'In Progress';

  @override
  String get underReview => 'Under Review';

  @override
  String get completed => 'Completed';

  @override
  String get cancelled => 'Cancelled';

  @override
  String minimumCharacters(int count) {
    return 'Minimum $count characters';
  }

  @override
  String get newPassword => 'New Password';

  @override
  String get enterNewPassword => 'Enter your new password';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get emailInvalid => 'Please enter a valid email address';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get complaints => 'Complaints';

  @override
  String get noComplaintsYet => 'No complaints yet';

  @override
  String get createFirstComplaint => 'Create your first complaint';

  @override
  String get errorLoadingComplaints => 'Error loading complaints';

  @override
  String get retry => 'Retry';

  @override
  String get noComplaintsToDisplay => 'No complaints to display';

  @override
  String get newComplaint => 'New Complaint';

  @override
  String complaintCreatedSuccessfully(int number) {
    return 'Complaint #$number created successfully';
  }

  @override
  String get createNewComplaint => 'Create New Complaint';

  @override
  String get complaintType => 'Complaint Type';

  @override
  String get complaintTypeRequired => 'Please select a complaint type';

  @override
  String get assignedDepartment => 'Assigned Department/Part';

  @override
  String get assignedDepartmentExample => 'e.g., Public Works Department';

  @override
  String get assignedDepartmentRequired =>
      'Please enter the assigned department';

  @override
  String get location => 'Location';

  @override
  String get locationExample => 'e.g., Main Street, Building 123';

  @override
  String get locationRequired => 'Please enter the location';

  @override
  String get description => 'Description';

  @override
  String get descriptionHint => 'Describe your complaint in detail';

  @override
  String get descriptionRequired => 'Please enter a description';

  @override
  String get descriptionMinLength =>
      'Description must be at least 10 characters';

  @override
  String get submit => 'Submit';

  @override
  String complaintNumber(int number) {
    return 'Complaint #$number';
  }

  @override
  String get statusNew => 'New';

  @override
  String get statusInProgress => 'In Progress';

  @override
  String get statusDone => 'Done';

  @override
  String get statusRejected => 'Rejected';

  @override
  String get type => 'Type';

  @override
  String get assignedPart => 'Assigned Part';

  @override
  String get createdAt => 'Created At';

  @override
  String get close => 'Close';

  @override
  String get complaintTypeInfrastructure => 'Infrastructure';

  @override
  String get complaintTypeHealth => 'Health';

  @override
  String get complaintTypeEducation => 'Education';

  @override
  String get complaintTypeTransportation => 'Transportation';

  @override
  String get complaintTypeEnvironment => 'Environment';

  @override
  String get complaintTypeSecurity => 'Security';

  @override
  String get complaintTypeOther => 'Other';

  @override
  String get all => 'All';

  @override
  String noFilteredComplaints(String status) {
    return 'No $status complaints';
  }

  @override
  String get tryDifferentFilter => 'Try selecting a different filter';

  @override
  String get showingCachedData => 'Showing cached data. Pull to refresh.';
}
