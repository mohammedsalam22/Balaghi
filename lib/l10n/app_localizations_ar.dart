// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'تطبيق البلاغي';

  @override
  String get home => 'الرئيسية';

  @override
  String get reports => 'التقارير';

  @override
  String get status => 'الحالة';

  @override
  String get settings => 'الإعدادات';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get register => 'التسجيل';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get resetPassword => 'إعادة تعيين كلمة المرور';

  @override
  String get verifyOtp => 'التحقق من رمز التحقق';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get signUp => 'التسجيل';

  @override
  String get welcomeBack => 'مرحباً بك';

  @override
  String get signInToContinue => 'سجل الدخول للمتابعة';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get signUpToGetStarted => 'سجل للبدء';

  @override
  String get alreadyHaveAccount => 'هل لديك حساب بالفعل؟';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟';

  @override
  String get theme => 'المظهر';

  @override
  String get language => 'اللغة';

  @override
  String get arabic => 'العربية';

  @override
  String get english => 'الإنجليزية';

  @override
  String get light => 'فاتح';

  @override
  String get dark => 'داكن';

  @override
  String get auto => 'تلقائي';

  @override
  String get selectTheme => 'اختر المظهر';

  @override
  String get selectLanguage => 'اختر اللغة';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get manageNotifications => 'إدارة الإشعارات';

  @override
  String get security => 'الأمان';

  @override
  String get securityAndPrivacy => 'إعدادات الأمان والخصوصية';

  @override
  String get help => 'المساعدة';

  @override
  String get faqAndSupport => 'الأسئلة الشائعة والدعم';

  @override
  String get logoutConfirmation => 'تأكيد تسجيل الخروج';

  @override
  String get logoutMessage => 'هل أنت متأكد من تسجيل الخروج؟';

  @override
  String get cancel => 'إلغاء';

  @override
  String get confirm => 'تأكيد';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get user => 'المستخدم';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get verifyYourEmail => 'التحقق من بريدك الإلكتروني';

  @override
  String enter6DigitCode(String email) {
    return 'أدخل الرمز المكون من 6 أرقام المرسل إلى\n$email';
  }

  @override
  String get verify => 'التحقق';

  @override
  String get sendResetLink => 'إرسال رابط إعادة التعيين';

  @override
  String get enterEmailToReset =>
      'أدخل عنوان بريدك الإلكتروني وسنرسل لك رابطاً لإعادة تعيين كلمة المرور.';

  @override
  String get welcome => 'مرحباً بك';

  @override
  String get toBalaghiApp => 'في تطبيق البلاغي';

  @override
  String get quickServices => 'الخدمات السريعة';

  @override
  String get newReport => 'إبلاغ جديد';

  @override
  String get trackReports => 'متابعة البلاغات';

  @override
  String get downloadReports => 'تحميل التقارير';

  @override
  String get myReports => 'تقاريري';

  @override
  String get viewAllSentReports => 'عرض جميع التقارير المرسلة';

  @override
  String get history => 'السجل';

  @override
  String get viewPreviousReports => 'عرض سجل التقارير السابقة';

  @override
  String get downloadReportsPdf => 'تحميل التقارير بصيغة PDF';

  @override
  String get reportStatus => 'حالة البلاغات';

  @override
  String get inProgress => 'قيد المعالجة';

  @override
  String get underReview => 'قيد المراجعة';

  @override
  String get completed => 'مكتملة';

  @override
  String get cancelled => 'ملغاة';

  @override
  String minimumCharacters(int count) {
    return 'الحد الأدنى $count أحرف';
  }

  @override
  String get newPassword => 'كلمة المرور الجديدة';

  @override
  String get enterNewPassword => 'أدخل كلمة المرور الجديدة';

  @override
  String get rememberMe => 'تذكرني';

  @override
  String get emailRequired => 'البريد الإلكتروني مطلوب';

  @override
  String get emailInvalid => 'يرجى إدخال عنوان بريد إلكتروني صحيح';

  @override
  String get passwordRequired => 'كلمة المرور مطلوبة';
}
