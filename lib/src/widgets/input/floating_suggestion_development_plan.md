# خطة تطوير نظام الاقتراحات العائمة (Floating Suggestions)

## 📋 نظرة عامة

### الوضع الحالي
نظام الاقتراحات الحالي (`FloatingSuggestionCard`) يدعم:
- `@` للإشارة للمستخدمين (Mentions)
- `#` للهاشتاقات (Hashtags)
- `/` للردود السريعة (Quick Replies)
- `$` للمهام (Tasks)

### المشاكل الحالية
1. **عدم قابلية التخصيص الكافية**: الأيقونات والعناوين ثابتة في الكود
2. **تصميم محدود**: البطاقة بسيطة وتفتقر للمظهر الاحترافي
3. **عدم دعم الثيم**: لا يستخدم `ChatThemeData` للتنسيق
4. **صعوبة إضافة أنواع جديدة**: يتطلب تعديل الـ enum والكود الداخلي
5. **عدم دعم الكيبورد**: لا يمكن التنقل بين العناصر بالأسهم

---

## 🎯 الأهداف

### 1. قابلية التخصيص الكاملة
- [ ] إنشاء `SuggestionTypeConfig` لتخصيص كل نوع
- [ ] دعم أيقونات وألوان وعناوين مخصصة لكل نوع
- [ ] إمكانية إضافة أنواع جديدة بدون تعديل الكود الأساسي

### 2. تحسين التصميم والمظهر
- [ ] تصميم بطاقة حديثة مع ظلال وحواف ناعمة
- [ ] دعم الرسوم المتحركة للظهور والاختفاء
- [ ] تحسين عرض العناصر مع صور وأيقونات أفضل
- [ ] دعم حالة التحميل (Loading State)
- [ ] دعم حالة الفراغ (Empty State) مع رسالة مخصصة

### 3. دمج نظام الثيم
- [ ] إنشاء `FloatingSuggestionTheme` ضمن `ChatThemeData`
- [ ] دعم الوضع الفاتح والداكن
- [ ] تخصيص الألوان والخطوط والأحجام

### 4. تحسين تجربة المستخدم
- [ ] دعم التنقل بالكيبورد (أسهم + Enter)
- [ ] تحسين التصفية والبحث
- [ ] دعم التمرير السلس
- [ ] إضافة Highlight للنص المطابق

---

## 📁 هيكل الملفات الجديد

```
lib/src/widgets/input/
├── floating_suggestion/
│   ├── floating_suggestion.dart              # Export file
│   ├── floating_suggestion_card.dart         # البطاقة الرئيسية (محسّنة)
│   ├── floating_suggestion_config.dart       # إعدادات الأنواع
│   ├── floating_suggestion_item_widget.dart  # عنصر الاقتراح
│   ├── floating_suggestion_header.dart       # ترويسة البطاقة
│   ├── floating_suggestion_empty.dart        # حالة الفراغ
│   ├── floating_suggestion_loading.dart      # حالة التحميل
│   └── floating_suggestion_controller.dart   # التحكم والكيبورد
├── input_models.dart                         # (تحديث)
└── chat_input.dart                           # (تحديث)

lib/src/theme/
└── chat_theme.dart                           # إضافة FloatingSuggestionTheme
```

---

## 🔧 التفاصيل التقنية

### المرحلة 1: إنشاء نظام التخصيص

#### 1.1 إنشاء `SuggestionTypeConfig`

```dart
/// تكوين نوع الاقتراح
class SuggestionTypeConfig {
  /// الرمز المحفز (مثل @ أو #)
  final String symbol;

  /// اسم النوع للعرض
  final String displayName;

  /// أيقونة النوع
  final IconData icon;

  /// لون النوع
  final Color? color;

  /// عنوان البطاقة
  final String? title;

  /// وصف اختياري
  final String? description;

  /// أيقونة افتراضية للعنصر
  final Widget Function(BuildContext context)? defaultItemIconBuilder;

  /// ارتفاع العنصر
  final double itemHeight;

  /// أقصى ارتفاع للبطاقة
  final double maxHeight;

  const SuggestionTypeConfig({
    required this.symbol,
    required this.displayName,
    required this.icon,
    this.color,
    this.title,
    this.description,
    this.defaultItemIconBuilder,
    this.itemHeight = 56.0,
    this.maxHeight = 250.0,
  });
}
```

#### 1.2 تحديث `FloatingSuggestionType` ليكون قابل للتوسيع

```dart
/// أنواع الاقتراحات المدمجة
class FloatingSuggestionTypes {
  static const username = SuggestionTypeConfig(
    symbol: '@',
    displayName: 'Mentions',
    icon: Icons.alternate_email,
    title: 'Mention someone',
  );

  static const hashtag = SuggestionTypeConfig(
    symbol: '#',
    displayName: 'Hashtags',
    icon: Icons.tag,
    title: 'Add hashtag',
  );

  static const quickReply = SuggestionTypeConfig(
    symbol: '/',
    displayName: 'Commands',
    icon: Icons.flash_on,
    title: 'Quick commands',
  );

  /// إنشاء نوع مخصص
  static SuggestionTypeConfig custom({
    required String symbol,
    required String displayName,
    required IconData icon,
    Color? color,
    String? title,
  }) => SuggestionTypeConfig(
    symbol: symbol,
    displayName: displayName,
    icon: icon,
    color: color,
    title: title,
  );
}
```

---

### المرحلة 2: إنشاء ثيم الاقتراحات

#### 2.1 إنشاء `FloatingSuggestionTheme`

```dart
/// ثيم بطاقة الاقتراحات العائمة
class FloatingSuggestionTheme {
  // === ألوان البطاقة ===
  final Color backgroundColor;
  final Color borderColor;
  final Color shadowColor;

  // === ألوان الترويسة ===
  final Color headerBackgroundColor;
  final Color headerIconColor;
  final Color headerTitleColor;

  // === ألوان العنصر ===
  final Color itemBackgroundColor;
  final Color itemHoverColor;
  final Color itemSelectedColor;
  final Color itemIconBackgroundColor;
  final Color itemTitleColor;
  final Color itemSubtitleColor;
  final Color highlightColor;

  // === الأبعاد ===
  final double borderRadius;
  final double borderWidth;
  final double elevation;
  final double itemHeight;
  final double maxHeight;
  final double iconSize;
  final double itemIconSize;
  final double itemIconRadius;

  // === الخطوط ===
  final TextStyle? headerTitleStyle;
  final TextStyle? itemTitleStyle;
  final TextStyle? itemSubtitleStyle;
  final TextStyle? emptyStateStyle;

  // === الحشوات ===
  final EdgeInsets cardPadding;
  final EdgeInsets headerPadding;
  final EdgeInsets itemPadding;

  // === الرسوم المتحركة ===
  final Duration animationDuration;
  final Curve animationCurve;

  const FloatingSuggestionTheme({
    this.backgroundColor = Colors.white,
    this.borderColor = const Color(0xFFE0E0E0),
    this.shadowColor = const Color(0x1A000000),
    this.headerBackgroundColor = const Color(0xFFF5F5F5),
    this.headerIconColor = const Color(0xFF1976D2),
    this.headerTitleColor = const Color(0xFF424242),
    this.itemBackgroundColor = Colors.transparent,
    this.itemHoverColor = const Color(0xFFF5F5F5),
    this.itemSelectedColor = const Color(0xFFE3F2FD),
    this.itemIconBackgroundColor = const Color(0xFFE3F2FD),
    this.itemTitleColor = const Color(0xFF212121),
    this.itemSubtitleColor = const Color(0xFF757575),
    this.highlightColor = const Color(0xFFFFEB3B),
    this.borderRadius = 16.0,
    this.borderWidth = 1.0,
    this.elevation = 8.0,
    this.itemHeight = 56.0,
    this.maxHeight = 280.0,
    this.iconSize = 20.0,
    this.itemIconSize = 18.0,
    this.itemIconRadius = 20.0,
    this.headerTitleStyle,
    this.itemTitleStyle,
    this.itemSubtitleStyle,
    this.emptyStateStyle,
    this.cardPadding = EdgeInsets.zero,
    this.headerPadding = const EdgeInsets.all(12),
    this.itemPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeOutCubic,
  });

  const FloatingSuggestionTheme.light() : this();

  const FloatingSuggestionTheme.dark() : this(
    backgroundColor: const Color(0xFF2D2D2D),
    borderColor: const Color(0xFF424242),
    shadowColor: const Color(0x40000000),
    headerBackgroundColor: const Color(0xFF383838),
    headerIconColor: const Color(0xFF64B5F6),
    headerTitleColor: const Color(0xFFE0E0E0),
    itemHoverColor: const Color(0xFF383838),
    itemSelectedColor: const Color(0xFF1E3A5F),
    itemIconBackgroundColor: const Color(0xFF1E3A5F),
    itemTitleColor: const Color(0xFFFFFFFF),
    itemSubtitleColor: const Color(0xFFBDBDBD),
  );

  FloatingSuggestionTheme copyWith({...});

  static FloatingSuggestionTheme lerp(
    FloatingSuggestionTheme? a,
    FloatingSuggestionTheme? b,
    double t,
  );
}
```

---

### المرحلة 3: تحسين البطاقة الرئيسية

#### 3.1 تحديث `FloatingSuggestionCard`

```dart
class FloatingSuggestionCard<T> extends StatefulWidget {
  /// استعلام البحث الحالي
  final String query;

  /// تكوين نوع الاقتراح
  final SuggestionTypeConfig typeConfig;

  /// قائمة الاقتراحات
  final List<FloatingSuggestionItem<T>> suggestions;

  /// عند اختيار اقتراح
  final OnSuggestionSelected<T>? onSelected;

  /// عند إغلاق البطاقة
  final VoidCallback? onClose;

  /// دالة الفلترة
  final bool Function(FloatingSuggestionItem<T> item, String query)? onFilter;

  /// بناء عنصر مخصص
  final Widget Function(
    BuildContext context,
    FloatingSuggestionItem<T> item,
    bool isSelected,
    String highlightQuery,
  )? itemBuilder;

  /// بناء حالة الفراغ
  final Widget Function(BuildContext context)? emptyBuilder;

  /// بناء حالة التحميل
  final Widget Function(BuildContext context)? loadingBuilder;

  /// هل في حالة تحميل
  final bool isLoading;

  /// ثيم مخصص (اختياري)
  final FloatingSuggestionTheme? theme;

  /// تفعيل التنقل بالكيبورد
  final bool enableKeyboardNavigation;

  /// تفعيل تمييز النص المطابق
  final bool enableHighlighting;

  /// عرض البطاقة
  final double? width;
}
```

---

### المرحلة 4: تحسين عرض العنصر

#### 4.1 إنشاء `FloatingSuggestionItemWidget`

```dart
class FloatingSuggestionItemWidget<T> extends StatelessWidget {
  final FloatingSuggestionItem<T> item;
  final SuggestionTypeConfig typeConfig;
  final bool isSelected;
  final String highlightQuery;
  final VoidCallback? onTap;
  final FloatingSuggestionTheme theme;

  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? theme.itemSelectedColor : theme.itemBackgroundColor,
      child: InkWell(
        onTap: onTap,
        hoverColor: theme.itemHoverColor,
        child: Container(
          height: theme.itemHeight,
          padding: theme.itemPadding,
          child: Row(
            children: [
              // أيقونة العنصر
              _buildItemIcon(),
              const SizedBox(width: 12),
              // محتوى العنصر
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // العنوان مع التمييز
                    _buildHighlightedTitle(),
                    if (item.subtitle != null) ...[
                      const SizedBox(height: 2),
                      // العنوان الفرعي
                      _buildSubtitle(),
                    ],
                  ],
                ),
              ),
              // أيقونة إضافية (اختياري)
              if (item.trailing != null) item.trailing!,
            ],
          ),
        ),
      ),
    );
  }

  /// بناء العنوان مع تمييز النص المطابق
  Widget _buildHighlightedTitle() {
    if (highlightQuery.isEmpty) {
      return Text(item.label, style: theme.itemTitleStyle);
    }

    return RichText(
      text: TextSpan(
        children: _buildHighlightedSpans(
          item.label,
          highlightQuery,
          theme.itemTitleStyle,
          theme.highlightColor,
        ),
      ),
    );
  }
}
```

---

### المرحلة 5: إضافة التحكم بالكيبورد

#### 5.1 إنشاء `FloatingSuggestionController`

```dart
class FloatingSuggestionController extends ChangeNotifier {
  int _selectedIndex = 0;
  List<FloatingSuggestionItem> _items = [];

  int get selectedIndex => _selectedIndex;

  void setItems(List<FloatingSuggestionItem> items) {
    _items = items;
    _selectedIndex = 0;
    notifyListeners();
  }

  void moveUp() {
    if (_selectedIndex > 0) {
      _selectedIndex--;
      notifyListeners();
    }
  }

  void moveDown() {
    if (_selectedIndex < _items.length - 1) {
      _selectedIndex++;
      notifyListeners();
    }
  }

  FloatingSuggestionItem? get selectedItem {
    if (_items.isEmpty) return null;
    return _items[_selectedIndex];
  }

  void reset() {
    _selectedIndex = 0;
    _items = [];
    notifyListeners();
  }
}
```

---

### المرحلة 6: تحديث `input_models.dart`

#### 6.1 تحسين `FloatingSuggestionItem`

```dart
class FloatingSuggestionItem<T> {
  final T value;
  final String label;
  final String? subtitle;
  final Widget? icon;
  final String? imageUrl;
  final Widget? trailing;
  final SuggestionTypeConfig typeConfig;
  final Map<String, dynamic>? metadata;

  const FloatingSuggestionItem({
    required this.value,
    required this.label,
    required this.typeConfig,
    this.subtitle,
    this.icon,
    this.imageUrl,
    this.trailing,
    this.metadata,
  });

  /// إنشاء من ChatUserSuggestion
  factory FloatingSuggestionItem.fromUser(ChatUserSuggestion user) {
    return FloatingSuggestionItem<ChatUserSuggestion>(
      value: user,
      label: user.name,
      subtitle: user.username != null ? '@${user.username}' : null,
      imageUrl: user.imageUrl,
      typeConfig: FloatingSuggestionTypes.username,
    );
  }

  /// إنشاء من Hashtag
  factory FloatingSuggestionItem.fromHashtag(Hashtag hashtag) {
    return FloatingSuggestionItem<Hashtag>(
      value: hashtag,
      label: '#${hashtag.hashtag}',
      typeConfig: FloatingSuggestionTypes.hashtag,
    );
  }
}
```

---

## 📊 ملخص المهام

### المرحلة 1: البنية التحتية (الأولوية: عالية)
| # | المهمة | الوصف |
|---|--------|-------|
| 1.1 | إنشاء `SuggestionTypeConfig` | كلاس تكوين نوع الاقتراح |
| 1.2 | تحديث `FloatingSuggestionType` | تحويله لنظام قابل للتوسيع |
| 1.3 | إنشاء `FloatingSuggestionTypes` | الأنواع المدمجة الافتراضية |

### المرحلة 2: نظام الثيم (الأولوية: عالية)
| # | المهمة | الوصف |
|---|--------|-------|
| 2.1 | إنشاء `FloatingSuggestionTheme` | ثيم كامل للاقتراحات |
| 2.2 | دمج مع `ChatThemeData` | إضافة خاصية floatingSuggestion |
| 2.3 | إضافة light/dark constructors | دعم الوضعين |

### المرحلة 3: تحسين البطاقة (الأولوية: عالية)
| # | المهمة | الوصف |
|---|--------|-------|
| 3.1 | تحديث `FloatingSuggestionCard` | إضافة الخصائص الجديدة |
| 3.2 | إضافة الرسوم المتحركة | ظهور/اختفاء سلس |
| 3.3 | تحسين التصميم | ظلال، حواف، ألوان |

### المرحلة 4: تحسين العناصر (الأولوية: متوسطة)
| # | المهمة | الوصف |
|---|--------|-------|
| 4.1 | إنشاء `FloatingSuggestionItemWidget` | عنصر منفصل محسّن |
| 4.2 | إضافة تمييز النص | highlight للنص المطابق |
| 4.3 | دعم الصور | عرض صور المستخدمين |

### المرحلة 5: تحسين UX (الأولوية: متوسطة)
| # | المهمة | الوصف |
|---|--------|-------|
| 5.1 | إنشاء `FloatingSuggestionController` | التحكم بالكيبورد |
| 5.2 | حالة الفراغ | رسالة عند عدم وجود نتائج |
| 5.3 | حالة التحميل | مؤشر تحميل |

### المرحلة 6: التكامل (الأولوية: عالية)
| # | المهمة | الوصف |
|---|--------|-------|
| 6.1 | تحديث `input_models.dart` | تحسين الموديلات |
| 6.2 | تحديث `chat_input.dart` | دمج التحسينات |
| 6.3 | تحديث الـ exports | تصدير الملفات الجديدة |

### المرحلة 7: التوثيق والأمثلة (الأولوية: منخفضة)
| # | المهمة | الوصف |
|---|--------|-------|
| 7.1 | تحديث شاشة المثال | `ChatInputExample` |
| 7.2 | إضافة توثيق | dartdoc comments |

---

## 🎨 معاينة التصميم المقترح

```
┌──────────────────────────────────────────┐
│ ┌────┐                              ╳ │  ← Header
│ │ @  │  Mention someone                  │
│ └────┘                                   │
├──────────────────────────────────────────┤
│ ┌──────┐                                 │
│ │ 👤   │  Ahmed Mohamed                  │  ← Item with avatar
│ │      │  @ahmed • Admin                 │
│ └──────┘                                 │
├ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┤
│ ┌──────┐                                 │
│ │ 👤   │  Sara Ali                       │  ← Selected item
│ │      │  @sara • Member            ✓   │     (highlighted)
│ └──────┘                                 │
├ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┤
│ ┌──────┐                                 │
│ │ 👤   │  Omar Hassan                    │
│ │      │  @omar • Member                 │
│ └──────┘                                 │
└──────────────────────────────────────────┘
         ↑↓ Navigate  ↵ Select  Esc Close
```

---

## 📝 ملاحظات إضافية

### التوافق العكسي
- الحفاظ على `FloatingSuggestionType` enum للتوافق
- إضافة extension methods للتحويل
- دعم الـ API القديم مع تحذير deprecated

### الأداء
- استخدام `const` constructors حيثما أمكن
- تجنب إعادة البناء غير الضرورية
- استخدام `RepaintBoundary` للرسوم المتحركة

### إمكانية الوصول (Accessibility)
- دعم قارئ الشاشة
- التباين الكافي للألوان
- أحجام خطوط مناسبة

---

## ✅ معايير القبول

1. [ ] جميع الأنواع الحالية تعمل بدون تغيير
2. [ ] يمكن إضافة أنواع جديدة بسهولة
3. [ ] الثيم يدعم الوضع الفاتح والداكن
4. [ ] التنقل بالكيبورد يعمل بشكل سلس
5. [ ] الرسوم المتحركة سلسة (60fps)
6. [ ] التصميم متسق مع باقي المكتبة
7. [ ] الوثائق كاملة ومحدثة
8. [ ] شاشة المثال تعرض جميع الميزات

---

## 📅 الجدول الزمني المقترح

| المرحلة | المهام | الأولوية |
|---------|--------|----------|
| 1 | البنية التحتية + الثيم | عالية |
| 2 | تحسين البطاقة + العناصر | عالية |
| 3 | التحكم بالكيبورد + UX | متوسطة |
| 4 | التكامل + الأمثلة | عالية |

---

**ملاحظة**: هذه الخطة قابلة للتعديل بناءً على ملاحظاتك. عند الموافقة، سأبدأ بتنفيذ المرحلة الأولى.
