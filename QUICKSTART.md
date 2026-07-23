# Amer.net - التعليمات السريعة

## البدء السريع

### التثبيت
```bash
# استنساخ المستودع
git clone https://github.com/aseelakkad77-ship-it/Amer.net.git
cd Amer.net

# تثبيت المكتبات
flutter pub get

# بناء ملفات قاعدة البيانات
flutter pub run build_runner build

# تشغيل التطبيق
flutter run
```

## الأوامر المهمة

### التطوير
```bash
# تشغيل في وضع Debug
flutter run

# تشغيل مع Hot Reload
flutter run -v

# بناء قاعدة البيانات
flutter pub run build_runner build --delete-conflicting-outputs

# تنسيق الكود
flutter format lib/

# تحليل الكود
flutter analyze
```

### البناء
```bash
# بناء Android APK
flutter build apk

# بناء iOS
flutter build ios

# بناء Web
flutter build web
```

## البنية الأساسية

```
lib/
├── config/              # الإعدادات والمواضيع
├── models/              # نماذج البيانات
├── providers/           # State Management
├── screens/             # الشاشات والصفحات
├── services/            # الخدمات والواجهات
├── widgets/             # المكونات المشتركة
└── main.dart            # نقطة البداية
```

## الميزات الرئيسية

✅ **تطبيق محلي 100%** - بدون إنترنت مطلوباً  
✅ **بحث فوري** - ابحث أثناء الكتابة  
✅ **إدارة الديون** - تسجيل وتتبع الديون بسهولة  
✅ **إحصائيات شاملة** - عرض إجمالي الديون والمسددات  
✅ **وضع ليلي** - دعم الوضع الفاتح والداكن  
✅ **نسخ احتياطي** - تصدير واستيراد البيانات  
✅ **عربي كامل** - واجهة عربية 100% مع RTL  

## المساهمة

نرحب بمساهماتك! اقرأ [CONTRIBUTING.md](CONTRIBUTING.md)

## الترخيص

MIT License - اقرأ [LICENSE](LICENSE)

---

**Powered by aseel.kh** © 2026
