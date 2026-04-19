// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Nexus';

  @override
  String get signIn => 'Sign In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get emailPlaceholder => 'you@example.com';

  @override
  String get password => 'Password';

  @override
  String get passwordPlaceholder => 'Enter your password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get confirmPasswordPlaceholder => 'Re-enter your password';

  @override
  String get fullName => 'Full Name';

  @override
  String get fullNamePlaceholder => 'Mohamed Ahmed';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get phonePlaceholder => '01xxxxxxxxx';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get noAccount => 'Don\'t have an account? ';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get dontHaveAnAccount => 'I don’t have an account ';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get createAccount => 'Create New Account';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get emailInvalid => 'Enter a valid email address';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get passwordTooShort => 'Must be at least 6 characters';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get nameRequired => 'Name is required';

  @override
  String get phoneRequired => 'Phone number is required';

  @override
  String get accountCreated => 'Account created! Welcome.';

  @override
  String get loggedIn => 'Logged in successfully';

  @override
  String welcomeUser(String name) {
    return 'Welcome, $name!';
  }

  @override
  String get orContinueWith => 'Or continue with';

  @override
  String get google => 'Google';

  @override
  String get apple => 'Apple';
}
