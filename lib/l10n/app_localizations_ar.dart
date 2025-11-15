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

  @override
  String get complaints => 'الشكاوى';

  @override
  String get noComplaintsYet => 'لا توجد شكاوى بعد';

  @override
  String get createFirstComplaint => 'أنشئ شكواك الأولى';

  @override
  String get errorLoadingComplaints => 'خطأ في تحميل الشكاوى';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get noComplaintsToDisplay => 'لا توجد شكاوى للعرض';

  @override
  String get newComplaint => 'شكوى جديدة';

  @override
  String complaintCreatedSuccessfully(int number) {
    return 'تم إنشاء الشكوى رقم $number بنجاح';
  }

  @override
  String get createNewComplaint => 'إنشاء شكوى جديدة';

  @override
  String get complaintType => 'نوع الشكوى';

  @override
  String get complaintTypeRequired => 'يرجى اختيار نوع الشكوى';

  @override
  String get assignedDepartment => 'القسم المكلف/الجزء';

  @override
  String get assignedDepartmentExample => 'مثال: دائرة الأشغال العامة';

  @override
  String get assignedDepartmentRequired => 'يرجى إدخال القسم المكلف';

  @override
  String get location => 'الموقع';

  @override
  String get locationExample => 'مثال: الشارع الرئيسي، المبنى 123';

  @override
  String get locationRequired => 'يرجى إدخال الموقع';

  @override
  String get description => 'الوصف';

  @override
  String get descriptionHint => 'اوصف شكواك بالتفصيل';

  @override
  String get descriptionRequired => 'يرجى إدخال الوصف';

  @override
  String get descriptionMinLength => 'يجب أن يكون الوصف 10 أحرف على الأقل';

  @override
  String get submit => 'إرسال';

  @override
  String complaintNumber(int number) {
    return 'الشكوى رقم $number';
  }

  @override
  String get statusNew => 'جديدة';

  @override
  String get statusInProgress => 'قيد المعالجة';

  @override
  String get statusDone => 'مكتملة';

  @override
  String get statusRejected => 'مرفوضة';

  @override
  String get type => 'النوع';

  @override
  String get assignedPart => 'القسم المكلف';

  @override
  String get createdAt => 'تاريخ الإنشاء';

  @override
  String get close => 'إغلاق';

  @override
  String get complaintTypeInfrastructure => 'البنية التحتية';

  @override
  String get complaintTypeHealth => 'الصحة';

  @override
  String get complaintTypeEducation => 'التعليم';

  @override
  String get complaintTypeTransportation => 'النقل';

  @override
  String get complaintTypeEnvironment => 'البيئة';

  @override
  String get complaintTypeSecurity => 'الأمن';

  @override
  String get complaintTypeOther => 'أخرى';

  @override
  String get all => 'الكل';

  @override
  String noFilteredComplaints(String status) {
    return 'لا توجد شكاوى $status';
  }

  @override
  String get tryDifferentFilter => 'جرب اختيار فلتر مختلف';
}
