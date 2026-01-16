## Plan: WhatsApp-Style In-Chat Message Search

تنفيذ ميزة بحث داخل المحادثة بنفس أسلوب واتساب - يعرض شريط بحث مع عدد النتائج وأسهم للتنقل بين الرسائل المطابقة مع تمييز النص المطابق.

### Steps

1. **إنشاء `SearchMatchesBar` widget** في [widgets/appbar/](lib/src/widgets/appbar/) - شريط يحتوي: حقل بحث | عداد "N of M" | سهم أعلى/أسفل | زر إغلاق (مشابه لتصميم `PinnedMessagesBar`)

2. **إضافة حالة البحث في `ChatScreen`** - متغيرات: `_isSearchMode`, `_searchQuery`, `_matchedMessages` (List), `_currentMatchIndex` - تحديث `build()` لعرض `SearchMatchesBar` عند تفعيل وضع البحث

3. **تنفيذ منطق التنقل** - استخدام `_scrollToMessage()` الموجود مع `animateFirstWhere()` للتنقل بين المطابقات - تحديث `_focusedMessageId` لتمييز الرسالة الحالية

4. **تمرير `searchQuery` عبر سلسلة الـ widgets** - `ChatScreen` → `ChatMessageList` → `MessageBubble` → `MessageContentBuilder` - إضافة parameter اختياري `String? searchQuery` في كل widget

5. **تنفيذ تمييز النص المطابق** في [message_content_builder.dart](lib/src/widgets/message_content_builder.dart) - إنشاء دالة `_buildHighlightedText()` تقسم النص إلى `TextSpan` مع خلفية صفراء للنص المطابق

### Further Considerations

1. **البحث في الرسائل غير المحملة؟** حالياً سيبحث في `currentItems` فقط - هل تريد دعم بحث خادم (backend search) للرسائل القديمة؟

2. **ترتيب التنقل:** واتساب يبدأ من آخر مطابقة (الأحدث) ويصعد للأقدم - هل هذا السلوك المطلوب؟

3. **تفعيل البحث:** يتم عبر `onSearch` callback الموجود في `ChatAppBar` - أم تريد طريقة أخرى؟
