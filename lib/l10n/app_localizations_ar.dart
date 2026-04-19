// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'نكسس';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get emailAddress => 'البريد الإلكتروني';

  @override
  String get emailPlaceholder => 'you@example.com';

  @override
  String get password => 'كلمة المرور';

  @override
  String get passwordPlaceholder => 'أدخل كلمة المرور';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get confirmPasswordPlaceholder => 'أعد إدخال كلمة المرور';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get fullNamePlaceholder => 'محمد أحمد';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get phonePlaceholder => '01xxxxxxxxx';

  @override
  String get forgotPassword => 'نسيت كلمة السر؟';

  @override
  String get noAccount => 'ليس لديك حساب؟ ';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟ ';

  @override
  String get dontHaveAnAccount => 'ليس لدي حساب ';

  @override
  String get welcomeBack => 'مرحباً بعودتك';

  @override
  String get createAccount => 'إنشاء حساب جديد';

  @override
  String get emailRequired => 'البريد الإلكتروني مطلوب';

  @override
  String get emailInvalid => 'أدخل بريداً إلكترونياً صحيحاً';

  @override
  String get passwordRequired => 'كلمة المرور مطلوبة';

  @override
  String get passwordTooShort => 'يجب أن تكون 6 أحرف على الأقل';

  @override
  String get passwordsDoNotMatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get nameRequired => 'الاسم مطلوب';

  @override
  String get phoneRequired => 'رقم الهاتف مطلوب';

  @override
  String get accountCreated => 'تم إنشاء الحساب! أهلاً بك.';

  @override
  String get loggedIn => 'تم تسجيل الدخول بنجاح';

  @override
  String welcomeUser(String name) {
    return 'أهلاً، $name!';
  }

  @override
  String get orContinueWith => 'أو تابع باستخدام';

  @override
  String get google => 'Google';

  @override
  String get apple => 'Apple';
}
