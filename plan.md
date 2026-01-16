# خطة استبدال text_preview في chat_message_ui

## نطاق العمل

- الاستبدال داخل الحزمة فقط كما طلبت، دون تعديل المثال أو بقية المستودع.

## خطوات التنفيذ المقترحة

1. تحديث الاعتمادات في [packages/chat_message_ui/pubspec.yaml](packages/chat_message_ui/pubspec.yaml)

- إزالة الاعتماد المحلي `text_preview`.
- إضافة `super_interactive_text: ^1.1.0` (آخر إصدار متاح حاليًا) من pub.dev.
- التحقق من عدم وجود تعارضات في `dependency_overrides` مع الاعتماد الجديد.

2. استبدال الاستيراد والواجهات العامة في طبقات العرض

- تحديث الاستيرادات في:
 - [packages/chat_message_ui/lib/src/widgets/message_content_builder.dart](packages/chat_message_ui/lib/src/widgets/message_content_builder.dart)
 - [packages/chat_message_ui/lib/src/widgets/message_bubble.dart](packages/chat_message_ui/lib/src/widgets/message_bubble.dart)
- استبدال `TextPreviewWidget` بـ `SuperInteractiveTextPreview` مع نفس تمرير الـ callbacks (روابط/بريد/هاتف/مسار) واستخدام الإعدادات الافتراضية للمكتبة الجديدة.

3. تحديث منطق معاينة البيانات داخل الإدخال

- تعديل تحليل النص في [packages/chat_message_ui/lib/src/widgets/input/chat_input.dart](packages/chat_message_ui/lib/src/widgets/input/chat_input.dart) لاستخدام واجهة التحليل الخاصة بالمكتبة الجديدة (مثل `SuperInteractiveTextDataParser` أو ما يقابلها بعد مراجعة API).
- تحديث نوع `TextData` والأنواع المشتقة المستخدمة في المعاينة.

4. تكييف بطاقة المعاينة مع نماذج البيانات الجديدة

- تحديث [packages/chat_message_ui/lib/src/widgets/input/text_data_preview_card.dart](packages/chat_message_ui/lib/src/widgets/input/text_data_preview_card.dart) لمطابقة الأنواع الجديدة بدل الاعتماد على `TextType` إذا تغيرت.
- الحفاظ على نفس سلوك المعاينات (روابط/بريد/هاتف/سوشيال/مسار) لكن باستخدام نماذج البيانات من `super_interactive_text`.

5. تحديث الثيم العام للنص التفاعلي في الحزمة

- استبدال `TextPreviewTheme` القديم في [packages/chat_message_ui/lib/src/theme/chat_theme.dart](packages/chat_message_ui/lib/src/theme/chat_theme.dart) بنوع الثيم الموافق في `super_interactive_text`.
- إبقاء الحقول وواجهات `ChatThemeData` متوافقة قدر الإمكان، لكن الاعتماد على القيم الافتراضية الجديدة بدل تخصيص إضافي.

6. تدقيق نهائي وتحقق بسيط

- التأكد أن جميع الاستيرادات القديمة لـ `text_preview` أزيلت ضمن `chat_message_ui`.
- تشغيل `flutter analyze` على الحزمة إذا رغبت، أو على الأقل بناء المثال يدويًا لاحقًا.

## ملاحظات تصميمية

- إعداد `SuperInteractiveTextDataParser.configure(...)` خاص بالمسارات الداخلية؛ لن يتم ضبطه داخل الحزمة تلقائيًا وسيبقى اختيارًا لتطبيق المستهلك.

## ملف الخطة

- بعد موافقتك على هذه الخطة، سأكتب نفس المحتوى في `packages/chat_message_ui/plan.md` كما طلبت.