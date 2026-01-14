import 'package:flutter/material.dart';
import 'package:text_preview/text_preview.dart';

/// Comprehensive chat theme data containing all styling components for chat UI
class ChatThemeData extends ThemeExtension<ChatThemeData> {
  /// Returns the [ChatThemeData] from the [BuildContext].
  ///
  /// If the [ChatThemeData] is not found, it will return null.
  static ChatThemeData? of(BuildContext context) =>
      Theme.of(context).extension<ChatThemeData>();

  /// Returns the [ChatThemeData] from the [BuildContext].
  ///
  /// If the [ChatThemeData] is not found, it will return the default light theme or dark theme based on the brightness of the theme.
  static ChatThemeData get(BuildContext context) {
    var theme = Theme.of(context);
    var chatTheme = theme.extension<ChatThemeData>();
    if (chatTheme != null) return chatTheme;

    if (theme.brightness == Brightness.dark) return ChatThemeData.dark();

    return ChatThemeData.light();
  }

  /// The colors of the chat theme.
  final ChatColors colors;

  /// The typography of the chat theme.
  final ChatTypography typography;

  /// The shape of the chat theme.
  final BorderRadiusGeometry shape;

  /// Message bubble specific styling
  final MessageBubbleTheme messageBubble;

  /// Avatar styling configuration
  final AvatarTheme avatar;

  /// Reactions styling configuration
  final ReactionsTheme reactions;

  /// Status indicators styling
  final StatusTheme status;

  /// Spacing and layout configuration
  final SpacingTheme spacing;

  /// Poll bubble specific styling
  final PollTheme poll;

  /// Location bubble specific styling
  final LocationTheme location;

  /// Input fields styling configuration
  final InputTheme input;

  /// Text preview styling configuration
  final TextPreviewTheme textPreview;

  /// Image bubble specific styling
  final ImageBubbleTheme imageBubble;

  /// Audio bubble specific styling
  final AudioBubbleTheme audioBubble;

  /// Video bubble specific styling
  final VideoBubbleTheme videoBubble;

  /// Document bubble specific styling
  final DocumentBubbleTheme documentBubble;

  ChatThemeData({
    Brightness brightness = Brightness.light,
    ChatColors? colors,
    ChatTypography? typography,
    BorderRadiusGeometry? shape,
    MessageBubbleTheme? messageBubble,
    AvatarTheme? avatar,
    ReactionsTheme? reactions,
    StatusTheme? status,
    SpacingTheme? spacing,
    PollTheme? poll,
    LocationTheme? location,
    InputTheme? input,
    TextPreviewTheme? textPreview,
    ImageBubbleTheme? imageBubble,
    AudioBubbleTheme? audioBubble,
    VideoBubbleTheme? videoBubble,
    DocumentBubbleTheme? documentBubble,
  })  : colors = colors ??
            (brightness == Brightness.light
                ? const ChatColors.light()
                : const ChatColors.dark()),
        typography = typography ??
            (brightness == Brightness.light
                ? ChatTypography.standard()
                : ChatTypography.standard()),
        shape = shape ?? const BorderRadius.all(Radius.circular(12)),
        messageBubble = messageBubble ??
            (brightness == Brightness.light
                ? const MessageBubbleTheme.light()
                : const MessageBubbleTheme.dark()),
        avatar = avatar ??
            (brightness == Brightness.light
                ? const AvatarTheme.light()
                : const AvatarTheme.dark()),
        reactions = reactions ??
            (brightness == Brightness.light
                ? const ReactionsTheme.light()
                : const ReactionsTheme.dark()),
        status = status ??
            (brightness == Brightness.light
                ? const StatusTheme.light()
                : const StatusTheme.dark()),
        spacing = spacing ??
            (brightness == Brightness.light
                ? const SpacingTheme.standard()
                : const SpacingTheme.standard()),
        poll = poll ??
            (brightness == Brightness.light
                ? const PollTheme.light()
                : const PollTheme.dark()),
        location = location ??
            (brightness == Brightness.light
                ? const LocationTheme.standard()
                : const LocationTheme.standard()),
        input = input ??
            (brightness == Brightness.light
                ? const InputTheme.light()
                : const InputTheme.dark()),
        textPreview = textPreview ??
            (brightness == Brightness.light
                ? TextPreviewTheme.light()
                : TextPreviewTheme.dark()),
        imageBubble = imageBubble ??
            (brightness == Brightness.light
                ? const ImageBubbleTheme.light()
                : const ImageBubbleTheme.dark()),
        audioBubble = audioBubble ??
            (brightness == Brightness.light
                ? const AudioBubbleTheme.light()
                : const AudioBubbleTheme.dark()),
        videoBubble = videoBubble ??
            (brightness == Brightness.light
                ? const VideoBubbleTheme.light()
                : const VideoBubbleTheme.dark()),
        documentBubble = documentBubble ??
            (brightness == Brightness.light
                ? const DocumentBubbleTheme.light()
                : const DocumentBubbleTheme.dark());

  /// Creates a default light theme.
  /// Optionally specify a [textTheme].
  ChatThemeData.light({TextTheme? textTheme})
      : this(
          colors: const ChatColors.light(),
          typography: ChatTypography.standard(textTheme),
          shape: const BorderRadius.all(Radius.circular(12)),
          messageBubble: const MessageBubbleTheme.light(),
          avatar: const AvatarTheme.light(),
          reactions: const ReactionsTheme.light(),
          status: const StatusTheme.light(),
          spacing: const SpacingTheme.standard(),
          poll: const PollTheme.light(),
          location: const LocationTheme.standard(),
          input: const InputTheme.light(),
          textPreview: TextPreviewTheme.light(textTheme),
          imageBubble: const ImageBubbleTheme.light(),
          audioBubble: const AudioBubbleTheme.light(),
          videoBubble: const VideoBubbleTheme.light(),
          documentBubble: const DocumentBubbleTheme.light(),
        );

  /// Creates a default dark theme.
  /// Optionally specify a [textTheme].
  ChatThemeData.dark({TextTheme? textTheme})
      : this(
          colors: const ChatColors.dark(),
          typography: ChatTypography.standard(textTheme),
          shape: const BorderRadius.all(Radius.circular(12)),
          messageBubble: const MessageBubbleTheme.dark(),
          avatar: const AvatarTheme.dark(),
          reactions: const ReactionsTheme.dark(),
          status: const StatusTheme.dark(),
          spacing: const SpacingTheme.standard(),
          poll: const PollTheme.dark(),
          location: const LocationTheme.standard(),
          input: const InputTheme.dark(),
          textPreview: TextPreviewTheme.dark(textTheme),
          imageBubble: const ImageBubbleTheme.dark(),
          audioBubble: const AudioBubbleTheme.dark(),
          videoBubble: const VideoBubbleTheme.dark(),
          documentBubble: const DocumentBubbleTheme.dark(),
        );

  /// Creates a [ChatThemeData] based on a Material [ThemeData].
  /// Extracts relevant colors and text styles.
  factory ChatThemeData.fromThemeData(ThemeData themeData) => ChatThemeData(
        colors: ChatColors.fromThemeData(themeData),
        typography: ChatTypography.fromThemeData(themeData),
        shape: const BorderRadius.all(Radius.circular(12)),
        messageBubble: const MessageBubbleTheme.light(),
        avatar: const AvatarTheme.light(),
        reactions: const ReactionsTheme.light(),
        status: const StatusTheme.light(),
        spacing: const SpacingTheme.standard(),
        poll: const PollTheme.light(),
        location: const LocationTheme.standard(),
        input: const InputTheme.light(),
        textPreview: TextPreviewTheme.light(),
        imageBubble: const ImageBubbleTheme.light(),
        audioBubble: const AudioBubbleTheme.light(),
        videoBubble: const VideoBubbleTheme.light(),
        documentBubble: const DocumentBubbleTheme.light(),
      );

  /// Creates a copy of [ChatThemeData] with updated properties.
  @override
  ChatThemeData copyWith({
    ChatColors? colors,
    ChatTypography? typography,
    BorderRadiusGeometry? shape,
    MessageBubbleTheme? messageBubble,
    AvatarTheme? avatar,
    ReactionsTheme? reactions,
    StatusTheme? status,
    SpacingTheme? spacing,
    PollTheme? poll,
    LocationTheme? location,
    InputTheme? input,
    TextPreviewTheme? textPreview,
    ImageBubbleTheme? imageBubble,
    AudioBubbleTheme? audioBubble,
    VideoBubbleTheme? videoBubble,
    DocumentBubbleTheme? documentBubble,
  }) {
    return ChatThemeData(
      colors: colors ?? this.colors,
      typography: typography ?? this.typography,
      shape: shape ?? this.shape,
      messageBubble: messageBubble ?? this.messageBubble,
      avatar: avatar ?? this.avatar,
      reactions: reactions ?? this.reactions,
      status: status ?? this.status,
      spacing: spacing ?? this.spacing,
      poll: poll ?? this.poll,
      location: location ?? this.location,
      input: input ?? this.input,
      textPreview: textPreview ?? this.textPreview,
      imageBubble: imageBubble ?? this.imageBubble,
      audioBubble: audioBubble ?? this.audioBubble,
      videoBubble: videoBubble ?? this.videoBubble,
      documentBubble: documentBubble ?? this.documentBubble,
    );
  }

  /// Linearly interpolates between two [ChatThemeData] instances.
  ///
  /// [other] is the other [ChatThemeData] instance to interpolate with.
  /// [t] is the interpolation factor, typically between 0 and 1.
  ///
  /// Returns a new [ChatThemeData] instance with interpolated values.
  @override
  ChatThemeData lerp(covariant ChatThemeData? other, double t) {
    if (other == null) return this;
    return ChatThemeData(
      colors: colors.lerp(other.colors, t),
      typography: typography.lerp(other.typography, t),
      shape: BorderRadiusGeometry.lerp(shape, other.shape, t) ?? shape,
      messageBubble: messageBubble,
      avatar: avatar,
      reactions: reactions,
      status: status,
      spacing: spacing,
      poll: poll,
      location: location,
      input: input,
      textPreview: textPreview,
      imageBubble: imageBubble,
      audioBubble: audioBubble,
      videoBubble: videoBubble,
      documentBubble: documentBubble,
    );
  }

  /// Merges this theme with another [ChatThemeData].
  ///
  /// Properties from [other] take precedence.
  ChatThemeData merge(ChatThemeData? other) {
    if (other == null) return this;
    return copyWith(
      colors: colors.merge(other.colors),
      typography: typography.merge(other.typography),
      shape: other.shape,
      messageBubble: other.messageBubble,
      avatar: other.avatar,
      reactions: other.reactions,
      status: other.status,
      spacing: other.spacing,
      poll: other.poll,
      location: other.location,
      input: other.input,
      textPreview: other.textPreview,
      imageBubble: other.imageBubble,
      audioBubble: other.audioBubble,
      videoBubble: other.videoBubble,
      documentBubble: other.documentBubble,
    );
  }

  /// Checks if this [ChatThemeData] is equal to another object.
  ///
  /// Returns true if the objects are the same instance or if all properties are equal.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatThemeData &&
        other.colors == colors &&
        other.typography == typography &&
        other.shape == shape &&
        other.messageBubble == messageBubble &&
        other.avatar == avatar &&
        other.reactions == reactions &&
        other.status == status &&
        other.spacing == spacing &&
        other.poll == poll &&
        other.location == location &&
        other.input == input &&
        other.textPreview == textPreview &&
        other.imageBubble == imageBubble &&
        other.audioBubble == audioBubble &&
        other.videoBubble == videoBubble &&
        other.documentBubble == documentBubble;
  }

  /// Returns a hash code for this [ChatThemeData].
  ///
  /// The hash code is based on the properties of the [ChatThemeData] instance.
  @override
  int get hashCode => Object.hash(
        colors,
        typography,
        shape,
        messageBubble,
        avatar,
        reactions,
        status,
        spacing,
        poll,
        location,
        input,
        textPreview,
        imageBubble,
        audioBubble,
        videoBubble,
        documentBubble,
      );
}

class ChatColors {
  /// The primary color of the theme.
  final Color primary;

  /// The color of the text on the primary color.
  final Color onPrimary;

  /// The surface color of the theme.
  final Color surface;

  /// The color of the text on the surface color.
  final Color onSurface;

  /// The surface color of the theme.
  final Color surfaceContainer;

  /// The lowest surface color of the theme.
  final Color surfaceContainerLow;

  /// The highest surface color of the theme.
  final Color surfaceContainerHigh;

  /// Creates a [ChatColors] instance.
  ///
  /// * [primary] is the primary color of the theme.
  /// * [onPrimary] is the color of the text on the primary color.
  /// * [surface] is the surface color of the theme.
  /// * [onSurface] is the color of the text on the surface color.
  /// * [surfaceContainerLow] is the lowest surface color of the theme.
  /// * [surfaceContainer] is the surface color of the theme.
  /// * [surfaceContainerHigh] is the highest surface color of the theme.
  const ChatColors({
    required this.primary,
    required this.onPrimary,
    required this.surface,
    required this.onSurface,
    required this.surfaceContainer,
    required this.surfaceContainerLow,
    required this.surfaceContainerHigh,
  });

  /// Default light color palette.
  ///
  /// * [primary] is the primary color of the theme.
  /// * [onPrimary] is the color of the text on the primary color.
  /// * [surface] is the surface color of the theme.
  /// * [onSurface] is the color of the text on the surface color.
  /// * [surfaceContainerLow] is the lowest surface color of the theme.
  /// * [surfaceContainer] is the surface color of the theme.
  /// * [surfaceContainerHigh] is the highest surface color of the theme.
  const ChatColors.light()
      : primary = const Color.fromRGBO(151, 78, 233, 1),
        onPrimary = Colors.white,
        surface = const Color.fromRGBO(255, 255, 255, 1),
        onSurface = const Color.fromRGBO(0, 0, 0, 0.867),
        surfaceContainerLow = const Color.fromRGBO(251, 245, 255, 1),
        surfaceContainer = const Color.fromRGBO(251, 245, 255, 1),
        surfaceContainerHigh = const Color.fromRGBO(244, 244, 250, 1);

  /// Default dark color palette.
  ///
  /// * [primary] is the primary color of the theme.
  /// * [onPrimary] is the color of the text on the primary color.
  /// * [surface] is the surface color of the theme.
  /// * [onSurface] is the color of the text on the surface color.
  /// * [surfaceContainerLow] is the lowest surface color of the theme.
  /// * [surfaceContainer] is the surface color of the theme.
  /// * [surfaceContainerHigh] is the highest surface color of the theme.
  const ChatColors.dark()
      : primary = const Color.fromARGB(255, 66, 10, 164),
        onPrimary = Colors.white,
        surface = const Color.fromRGBO(18, 18, 18, 1),
        onSurface = const Color.fromRGBO(255, 255, 255, 1),
        surfaceContainerLow = const Color.fromRGBO(18, 18, 18, 1),
        surfaceContainer = const Color.fromRGBO(28, 28, 30, 1),
        surfaceContainerHigh = const Color.fromRGBO(36, 36, 36, 1);

  /// Creates [ChatColors] from a Material [ThemeData].
  ChatColors.fromThemeData(ThemeData themeData)
      : primary = themeData.colorScheme.primary,
        onPrimary = themeData.colorScheme.onPrimary,
        surface = themeData.colorScheme.surface,
        onSurface = themeData.colorScheme.onSurface,
        surfaceContainerLow = themeData.colorScheme.surfaceContainerLow,
        surfaceContainer = themeData.colorScheme.surfaceContainer,
        surfaceContainerHigh = themeData.colorScheme.surfaceContainerHigh;

  /// Creates a copy of [ChatColors] with updated colors.
  ///
  /// * [primary] is the primary color of the theme.
  /// * [onPrimary] is the color of the text on the primary color.
  /// * [surface] is the surface color of the theme.
  /// * [onSurface] is the color of the text on the surface color.
  /// * [surfaceContainerLow] is the lowest surface color of the theme.
  /// * [surfaceContainer] is the surface color of the theme.
  /// * [surfaceContainerHigh] is the highest surface color of the theme.
  ChatColors copyWith({
    Color? primary,
    Color? onPrimary,
    Color? surface,
    Color? onSurface,
    Color? surfaceContainer,
    Color? surfaceContainerLow,
    Color? surfaceContainerHigh,
  }) {
    return ChatColors(
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      surface: surface ?? this.surface,
      onSurface: onSurface ?? this.onSurface,
      surfaceContainer: surfaceContainer ?? this.surfaceContainer,
      surfaceContainerLow: surfaceContainerLow ?? this.surfaceContainerLow,
      surfaceContainerHigh: surfaceContainerHigh ?? this.surfaceContainerHigh,
    );
  }

  /// Linearly interpolates between two [ChatColors].
  ///
  /// * [other] is the other [ChatColors] instance to interpolate with.
  /// * [t] is the interpolation factor, typically between 0 and 1.
  ///
  /// Returns a new [ChatColors] instance with interpolated values.
  ChatColors lerp(ChatColors other, double t) {
    return ChatColors(
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      surfaceContainer: Color.lerp(
        surfaceContainer,
        other.surfaceContainer,
        t,
      )!,
      surfaceContainerLow: Color.lerp(
        surfaceContainerLow,
        other.surfaceContainerLow,
        t,
      )!,
      surfaceContainerHigh: Color.lerp(
        surfaceContainerHigh,
        other.surfaceContainerHigh,
        t,
      )!,
    );
  }

  /// Merges this color scheme with another [ChatColors].
  ///
  /// Colors from [other] take precedence.
  ChatColors merge(ChatColors? other) {
    if (other == null) return this;
    return copyWith(
      primary: other.primary,
      onPrimary: other.onPrimary,
      surface: other.surface,
      onSurface: other.onSurface,
      surfaceContainerLow: other.surfaceContainerLow,
      surfaceContainer: other.surfaceContainer,
      surfaceContainerHigh: other.surfaceContainerHigh,
    );
  }

  /// Checks if this [ChatColors] is equal to another object.
  ///
  /// Returns true if the objects are the same instance or if all properties are equal.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatColors &&
        other.primary == primary &&
        other.onPrimary == onPrimary &&
        other.surface == surface &&
        other.onSurface == onSurface &&
        other.surfaceContainer == surfaceContainer &&
        other.surfaceContainerLow == surfaceContainerLow &&
        other.surfaceContainerHigh == surfaceContainerHigh;
  }

  /// Returns a hash code for this [ChatColors].
  ///
  /// The hash code is based on the properties of the [ChatColors] instance.
  @override
  int get hashCode => Object.hash(
        primary,
        onPrimary,
        surface,
        onSurface,
        surfaceContainer,
        surfaceContainerLow,
        surfaceContainerHigh,
      );
}

class ChatTypography {
  /// The text style for the body large text.
  final TextStyle bodyLarge;

  /// The text style for the body medium text.
  final TextStyle bodyMedium;

  /// The text style for the body small text.
  final TextStyle bodySmall;

  /// The text style for the label large text.
  final TextStyle labelLarge;

  /// The text style for the label medium text.
  final TextStyle labelMedium;

  /// The text style for the label small text.
  final TextStyle labelSmall;

  /// Creates a [ChatTypography] instance.
  ///
  /// * [bodyLarge] is the text style for the body large text.
  /// * [bodyMedium] is the text style for the body medium text.
  /// * [bodySmall] is the text style for the body small text.
  /// * [labelLarge] is the text style for the label large text.
  /// * [labelMedium] is the text style for the label medium text.
  /// * [labelSmall] is the text style for the label small text.
  const ChatTypography({
    required this.bodyLarge,
    required this.bodyMedium,
    required this.bodySmall,
    required this.labelLarge,
    required this.labelMedium,
    required this.labelSmall,
  });

  /// Creates a standard set of text styles.
  ///
  /// Optionally specify a custom [textTheme].
  ChatTypography.standard([TextTheme? textTheme])
      : this(
          bodyLarge: textTheme?.bodyLarge?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ) ??
              const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          bodyMedium: textTheme?.bodyMedium?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ) ??
              const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          bodySmall: textTheme?.bodySmall?.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ) ??
              const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
          labelLarge: textTheme?.labelLarge?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ) ??
              const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          labelMedium: textTheme?.labelMedium?.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ) ??
              const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          labelSmall: textTheme?.labelSmall?.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ) ??
              const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
        );

  /// Creates [ChatTypography] from a Material [ThemeData].
  ChatTypography.fromThemeData(ThemeData themeData)
      : this(
          bodyLarge: themeData.textTheme.bodyLarge!,
          bodyMedium: themeData.textTheme.bodyMedium!,
          bodySmall: themeData.textTheme.bodySmall!,
          labelLarge: themeData.textTheme.labelLarge!,
          labelMedium: themeData.textTheme.labelMedium!,
          labelSmall: themeData.textTheme.labelSmall!,
        );

  /// Creates a copy of the typography scheme with updated styles.
  ///
  /// * [bodyLarge] is the text style for the body large text.
  /// * [bodyMedium] is the text style for the body medium text.
  /// * [bodySmall] is the text style for the body small text.
  /// * [labelLarge] is the text style for the label large text.
  /// * [labelMedium] is the text style for the label medium text.
  /// * [labelSmall] is the text style for the label small text.
  ChatTypography copyWith({
    TextStyle? bodyLarge,
    TextStyle? bodyMedium,
    TextStyle? bodySmall,
    TextStyle? labelLarge,
    TextStyle? labelMedium,
    TextStyle? labelSmall,
  }) {
    return ChatTypography(
      bodyLarge: bodyLarge ?? this.bodyLarge,
      bodyMedium: bodyMedium ?? this.bodyMedium,
      bodySmall: bodySmall ?? this.bodySmall,
      labelLarge: labelLarge ?? this.labelLarge,
      labelMedium: labelMedium ?? this.labelMedium,
      labelSmall: labelSmall ?? this.labelSmall,
    );
  }

  /// Linearly interpolates between two [ChatTypography] instances.
  ///
  /// * [other] is the other [ChatTypography] instance to interpolate with.
  /// * [t] is the interpolation factor, typically between 0 and 1.
  ///
  /// Returns a new [ChatTypography] instance with interpolated values.
  ChatTypography lerp(ChatTypography other, double t) {
    return ChatTypography(
      bodyLarge: TextStyle.lerp(bodyLarge, other.bodyLarge, t)!,
      bodyMedium: TextStyle.lerp(bodyMedium, other.bodyMedium, t)!,
      bodySmall: TextStyle.lerp(bodySmall, other.bodySmall, t)!,
      labelLarge: TextStyle.lerp(labelLarge, other.labelLarge, t)!,
      labelMedium: TextStyle.lerp(labelMedium, other.labelMedium, t)!,
      labelSmall: TextStyle.lerp(labelSmall, other.labelSmall, t)!,
    );
  }

  /// Merges this typography scheme with another [ChatTypography].
  ///
  /// Styles from [other] take precedence.
  ///
  /// * [other] is the other [ChatTypography] instance to merge with.
  ///
  /// Returns a new [ChatTypography] instance with merged values.
  ChatTypography merge(ChatTypography? other) {
    if (other == null) return this;
    return copyWith(
      bodyLarge: other.bodyLarge,
      bodyMedium: other.bodyMedium,
      bodySmall: other.bodySmall,
      labelLarge: other.labelLarge,
      labelMedium: other.labelMedium,
      labelSmall: other.labelSmall,
    );
  }

  /// Checks if this [ChatTypography] is equal to another object.
  ///
  /// Returns true if the objects are the same instance or if all properties are equal.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatTypography &&
        other.bodyLarge == bodyLarge &&
        other.bodyMedium == bodyMedium &&
        other.bodySmall == bodySmall &&
        other.labelLarge == labelLarge &&
        other.labelMedium == labelMedium &&
        other.labelSmall == labelSmall;
  }

  /// Returns a hash code for this [ChatTypography].
  ///
  /// The hash code is based on the properties of the [ChatTypography] instance.
  @override
  int get hashCode => Object.hash(
        bodyLarge,
        bodyMedium,
        bodySmall,
        labelLarge,
        labelMedium,
        labelSmall,
      );
}

/// Extension methods for [ChatThemeData] to simplify modifications.
extension ChatThemeDataExtensions on ChatThemeData {
  /// Creates a copy of the theme with updated light colors.
  ///
  /// Uses [ChatColors.light] as the base and overrides specified colors.
  ChatThemeData withLightColors({
    Color? primary,
    Color? onPrimary,
    Color? surface,
    Color? onSurface,
    Color? surfaceContainer,
    Color? surfaceContainerLow,
    Color? surfaceContainerHigh,
  }) {
    const light = ChatColors.light();
    return copyWith(
      colors: light.copyWith(
        primary: primary ?? light.primary,
        onPrimary: onPrimary ?? light.onPrimary,
        surface: surface ?? light.surface,
        onSurface: onSurface ?? light.onSurface,
        surfaceContainer: surfaceContainer ?? light.surfaceContainer,
        surfaceContainerLow: surfaceContainerLow ?? light.surfaceContainerLow,
        surfaceContainerHigh:
            surfaceContainerHigh ?? light.surfaceContainerHigh,
      ),
    );
  }

  /// Creates a copy of the theme with updated dark colors.
  ///
  /// Uses [ChatColors.dark] as the base and overrides specified colors.
  ChatThemeData withDarkColors({
    Color? primary,
    Color? onPrimary,
    Color? surface,
    Color? onSurface,
    Color? surfaceContainer,
    Color? surfaceContainerLow,
    Color? surfaceContainerHigh,
  }) {
    const dark = ChatColors.dark();
    return copyWith(
      colors: dark.copyWith(
        primary: primary ?? dark.primary,
        onPrimary: onPrimary ?? dark.onPrimary,
        surface: surface ?? dark.surface,
        onSurface: onSurface ?? dark.onSurface,
        surfaceContainer: surfaceContainer ?? dark.surfaceContainer,
        surfaceContainerLow: surfaceContainerLow ?? dark.surfaceContainerLow,
        surfaceContainerHigh: surfaceContainerHigh ?? dark.surfaceContainerHigh,
      ),
    );
  }
}

/// Single bubble configuration for either sender or receiver
class BubbleConfig {
  /// Background color
  final Color? backgroundColor;

  /// Text color
  final Color? textColor;

  /// Border color
  final Color? borderColor;

  /// Border width
  final double borderWidth;

  /// Shadow color
  final Color? shadowColor;

  /// Shadow elevation
  final double shadowElevation;

  /// Whether to show shadow
  final bool showShadow;

  const BubbleConfig({
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.borderWidth = 0.0,
    this.shadowColor,
    this.shadowElevation = 1.0,
    this.showShadow = true,
  });

  BubbleConfig copyWith({
    Color? backgroundColor,
    Color? textColor,
    Color? borderColor,
    double? borderWidth,
    Color? shadowColor,
    double? shadowElevation,
    bool? showShadow,
  }) {
    return BubbleConfig(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      shadowColor: shadowColor ?? this.shadowColor,
      shadowElevation: shadowElevation ?? this.shadowElevation,
      showShadow: showShadow ?? this.showShadow,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BubbleConfig &&
        other.backgroundColor == backgroundColor &&
        other.textColor == textColor &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.shadowColor == shadowColor &&
        other.shadowElevation == shadowElevation &&
        other.showShadow == showShadow;
  }

  @override
  int get hashCode => Object.hash(
        backgroundColor,
        textColor,
        borderColor,
        borderWidth,
        shadowColor,
        shadowElevation,
        showShadow,
      );
}

/// Message bubble specific theme configuration
class MessageBubbleTheme {
  static const Color chatOutgoingBubbleColor = Color(
    0xFFEEDDF8,
  ); // Light purple for outgoing messages
  static const Color chatIncomingBubbleColor = Color(0xFFF5F5F5);
  static const Color chatOutgoingBubbleBorderColor = Color(
    0xFFDEC6ED,
  ); // Border for outgoing messages
  static const Color chatIncomingBubbleBorderColor = Color(
    0xFFE0E0E0,
  ); // Border for incoming messages
  static const Color chatOutgoingTextColor = Color(
    0xFF3A3A3A,
  ); // Text color for outgoing messages
  static const Color chatIncomingTextColor = Color(
    0xFF3A3A3A,
  ); // Text color for incoming messages

  // chat colors
  static const Color colorPrimaryChatMassage = Color(0xFFE9EAED);
  static const Color colorSecondaryChatMassage =
      Colors.white24; // تم الحساب يدوياً للـ color-mix
  static const Color colorChatPrimary = Color(0xFFA80AA0); // #a80aa0
  static const Color colorChatSecondary = Color(
    0xFFB853B8,
  ); // تم الحساب يدوياً للـ color-mix
  static const Color colorChatTertiary = Color(0xFFE9EAED); // #e9eaed
  static const Color colorChatText = Color(0xFF080707); // #080707
  static const Color colorChatTextMuted = Color(0xFF53565C); // #53565c
  static const Color colorChatError = Color(0xFFFF0000); // #f00
  static const Color colorChatInfo = Color(0xFF0066FF); // #0066ff

  // Enhanced chat colors
  static const Color chatTimestampColor = Color(
    0xFF9E9E9E,
  ); // Color for message timestamps
  static const Color chatReplyBackgroundColor = Color(
    0xFFE8E8E8,
  ); // Background for replies
  static const Color chatSystemMessageColor = Color(
    0xFFECF3FD,
  ); // System messages background
  static const Color chatReactionBackgroundColor = Color(
    0xFFF0F0F0,
  ); // Background for reactions
  static const Color chatLinkColor = Color(
    0xFF2D68F8,
  ); // Color for links in chat
  static const Color chatSentIndicatorColor = Color(
    0xFF9E9E9E,
  ); // Sent indicator color
  static const Color chatReadIndicatorColor = Color(
    0xFF4FC3F7,
  ); // Read indicator color
  static const Color chatInputBackgroundColor = Color(
    0xFFF8F0FD,
  ); // Input area background
  static const Color chatMediaOverlayColor = Color(
    0x80000000,
  ); // Media overlay color

  // Dark theme chat colors
  static const Color darkChatOutgoingBubbleColor = Color(
    0xFF3D2B52,
  ); // Dark purple for outgoing messages
  static const Color darkChatIncomingBubbleColor = Color(
    0xFF2A2A2A,
  ); // Dark gray for incoming messages
  static const Color darkChatOutgoingBubbleBorderColor = Color(
    0xFF4E3A63,
  ); // Border for outgoing messages
  static const Color darkChatIncomingBubbleBorderColor = Color(
    0xFF3A3A3A,
  ); // Border for incoming messages
  static const Color darkChatOutgoingTextColor = Color(
    0xFFE0E0E0,
  ); // Text color for outgoing messages
  static const Color darkChatIncomingTextColor = Color(
    0xFFE0E0E0,
  ); // Text color for incoming messages
  static const Color darkChatTimestampColor = Color(
    0xFF8E8E8E,
  ); // Color for message timestamps
  static const Color darkChatReplyBackgroundColor = Color(
    0xFF2C2C2C,
  ); // Background for replies
  static const Color darkChatReplyIndicatorColor = Color(
    0xFF7833D2,
  ); // Indicator for reply
  static const Color darkChatSystemMessageColor = Color(
    0xFF1F2A3C,
  ); // System messages background
  static const Color darkChatReactionBackgroundColor = Color(
    0xFF333333,
  ); // Background for reactions
  static const Color darkChatLinkColor = Color(
    0xFF5C91F8,
  ); // Color for links in chat
  static const Color darkChatReadIndicatorColor = Color(
    0xFF4FC3F7,
  ); // Read indicator color
  static const Color darkChatSentIndicatorColor = Color(
    0xFF8E8E8E,
  ); // Sent indicator color
  static const Color darkChatSenderNameColor = Color(
    0xFF7833D2,
  ); // Sender name color
  static const Color darkChatAttachmentButtonColor = Color(
    0xFF7833D2,
  ); // Attachment button color
  static const Color darkChatSendButtonColor = Color(
    0xFF7833D2,
  ); // Send button color

  /// Configuration for sent messages
  final BubbleConfig sender;

  /// Configuration for received messages
  final BubbleConfig receiver;

  /// Border radius for message bubbles
  final double bubbleRadius;

  /// Maximum width factor for message bubbles (relative to screen width)
  final double maxWidthFactor;

  /// Minimum bubble width
  final double minBubbleWidth;

  /// Bubble margin
  final double bubbleMargin;

  /// Bubble padding
  final double bubblePadding;

  /// Content padding
  final double contentPadding;

  /// Content vertical padding
  final double contentVerticalPadding;

  // Backwards compatibility getters
  Color? get senderBubbleColor => sender.backgroundColor;
  Color? get receiverBubbleColor => receiver.backgroundColor;
  Color? get senderTextColor => sender.textColor;
  Color? get receiverTextColor => receiver.textColor;
  bool get showShadow => sender.showShadow || receiver.showShadow;
  Color? get shadowColor => sender.shadowColor ?? receiver.shadowColor;
  double get shadowElevation => sender.shadowElevation;

  /// Creates a new [MessageBubbleTheme] instance.
  ///
  /// * [sender] is the configuration for sent messages.
  /// * [receiver] is the configuration for received messages.
  /// * [bubbleRadius] is the new border radius for message bubbles.
  /// * [maxWidthFactor] is the new max width factor for message bubbles.
  /// * [minBubbleWidth] is the new minimum bubble width.
  /// * [bubbleMargin] is the new bubble margin.
  /// * [bubblePadding] is the new bubble padding.
  /// * [contentPadding] is the new content padding.
  /// * [contentVerticalPadding] is the new content vertical padding.

  const MessageBubbleTheme({
    required this.sender,
    required this.receiver,
    this.bubbleRadius = 8.0,
    this.maxWidthFactor = 0.7,
    this.minBubbleWidth = 50.0,
    this.bubbleMargin = 4.0,
    this.bubblePadding = 2.0,
    this.contentPadding = 8.0,
    this.contentVerticalPadding = 4.0,
  });

  const MessageBubbleTheme.light([TextTheme? textTheme])
      : this(
          sender: const BubbleConfig(
            backgroundColor:
                chatOutgoingBubbleColor, // Purple like the app's primary color
            textColor: chatOutgoingTextColor, // White text on purple
            shadowColor: Color(0x1A000000), // Subtle shadow
            showShadow: true,
            shadowElevation: 1.5,
          ),
          receiver: const BubbleConfig(
            backgroundColor:
                chatIncomingBubbleColor, // Light gray for received messages
            textColor: chatIncomingTextColor, // Dark text on light gray
            shadowColor: Color(0x1A000000), // Subtle shadow
            showShadow: true,
            shadowElevation: 1.5,
          ),
          bubbleRadius: 12.0, // More rounded like modern chat apps
        );

  const MessageBubbleTheme.dark()
      : this(
          sender: const BubbleConfig(
            backgroundColor:
                darkChatOutgoingBubbleColor, // Same purple for consistency
            textColor: darkChatOutgoingTextColor, // White text on purple
            shadowColor: Color(0x40000000), // Stronger shadow for dark mode
            showShadow: true,
            shadowElevation: 2.0,
          ),
          receiver: const BubbleConfig(
            backgroundColor:
                darkChatIncomingBubbleColor, // Dark gray for received messages in dark mode
            textColor: darkChatIncomingTextColor, // White text on dark gray
            shadowColor: Color(0x40000000), // Stronger shadow for dark mode
            showShadow: true,
            shadowElevation: 2.0,
          ),
          bubbleRadius: 12.0, // Same rounded style
        );

  /// Creates a copy of [MessageBubbleTheme] with updated values.
  ///
  /// * [sender] is the new configuration for sent messages.
  /// * [receiver] is the new configuration for received messages.
  /// * [bubbleRadius] is the new border radius for message bubbles.
  /// * [maxWidthFactor] is the new max width factor for message bubbles.
  /// * [minBubbleWidth] is the new minimum bubble width.
  /// * [bubbleMargin] is the new bubble margin.
  /// * [bubblePadding] is the new bubble padding.
  /// * [contentPadding] is the new content padding.
  /// * [contentVerticalPadding] is the new content vertical padding.
  MessageBubbleTheme copyWith({
    BubbleConfig? sender,
    BubbleConfig? receiver,
    double? bubbleRadius,
    double? maxWidthFactor,
    double? minBubbleWidth,
    double? bubbleMargin,
    double? bubblePadding,
    double? contentPadding,
    double? contentVerticalPadding,
  }) {
    return MessageBubbleTheme(
      sender: sender ?? this.sender,
      receiver: receiver ?? this.receiver,
      bubbleRadius: bubbleRadius ?? this.bubbleRadius,
      maxWidthFactor: maxWidthFactor ?? this.maxWidthFactor,
      minBubbleWidth: minBubbleWidth ?? this.minBubbleWidth,
      bubbleMargin: bubbleMargin ?? this.bubbleMargin,
      bubblePadding: bubblePadding ?? this.bubblePadding,
      contentPadding: contentPadding ?? this.contentPadding,
      contentVerticalPadding:
          contentVerticalPadding ?? this.contentVerticalPadding,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MessageBubbleTheme &&
        other.sender == sender &&
        other.receiver == receiver &&
        other.bubbleRadius == bubbleRadius &&
        other.maxWidthFactor == maxWidthFactor &&
        other.minBubbleWidth == minBubbleWidth &&
        other.bubbleMargin == bubbleMargin &&
        other.bubblePadding == bubblePadding &&
        other.contentPadding == contentPadding &&
        other.contentVerticalPadding == contentVerticalPadding;
  }

  @override
  int get hashCode => Object.hash(
        sender,
        receiver,
        bubbleRadius,
        maxWidthFactor,
        minBubbleWidth,
        bubbleMargin,
        bubblePadding,
        contentPadding,
        contentVerticalPadding,
      );
}

/// Avatar theme configuration
class AvatarTheme {
  /// Default avatar size
  final double defaultSize;

  /// Avatar background color
  final Color? backgroundColor;

  /// Avatar text color
  final Color? textColor;

  /// Avatar border radius
  final double borderRadius;

  const AvatarTheme({
    this.defaultSize = 15.0,
    this.backgroundColor,
    this.textColor,
    this.borderRadius = 50.0,
  });

  const AvatarTheme.light() : this();

  const AvatarTheme.dark() : this();

  /// Creates a copy of [AvatarTheme] with updated values.
  ///
  /// * [defaultSize] is the new default size.
  /// * [backgroundColor] is the new background color.
  /// * [textColor] is the new text color.
  /// * [borderRadius] is the new border radius.
  AvatarTheme copyWith({
    double? defaultSize,
    Color? backgroundColor,
    Color? textColor,
    double? borderRadius,
  }) {
    return AvatarTheme(
      defaultSize: defaultSize ?? this.defaultSize,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AvatarTheme &&
        other.defaultSize == defaultSize &&
        other.backgroundColor == backgroundColor &&
        other.textColor == textColor &&
        other.borderRadius == borderRadius;
  }

  @override
  int get hashCode =>
      Object.hash(defaultSize, backgroundColor, textColor, borderRadius);
}

/// Reactions theme configuration
class ReactionsTheme {
  /// Spacing between reactions
  final double spacing;

  /// Reaction padding
  final double padding;

  /// Reaction vertical padding
  final double verticalPadding;

  /// Reaction border radius
  final double borderRadius;

  /// Reaction emoji size
  final double emojiSize;

  /// Reaction count text size
  final double countSize;

  /// Top offset for reactions
  final double topOffset;

  /// End offset for reactions
  final double endOffset;

  /// Opacity for light reactions
  final double opacityLight;

  /// Background color for active reactions
  final Color? activeBackgroundColor;

  /// Background color for inactive reactions
  final Color? inactiveBackgroundColor;

  /// Text color for active reactions
  final Color? activeTextColor;

  /// Text color for inactive reactions
  final Color? inactiveTextColor;

  /// Creates a new [ReactionsTheme] instance.
  ///
  /// * [spacing] is the new spacing.
  /// * [padding] is the new padding.
  /// * [verticalPadding] is the new vertical padding.
  /// * [borderRadius] is the new border radius.
  /// * [emojiSize] is the new emoji size.
  /// * [countSize] is the new count size.
  /// * [topOffset] is the new top offset.
  /// * [endOffset] is the new end offset.
  /// * [opacityLight] is the new opacity for light reactions.
  /// * [activeBackgroundColor] is the new background color for active reactions.
  /// * [inactiveBackgroundColor] is the new background color for inactive reactions.
  /// * [activeTextColor] is the new text color for active reactions.
  /// * [inactiveTextColor] is the new text color for inactive reactions.
  const ReactionsTheme({
    this.spacing = 4.0,
    this.padding = 6.0,
    this.verticalPadding = 4.0,
    this.borderRadius = 12.0,
    this.emojiSize = 14.0,
    this.countSize = 12.0,
    this.topOffset = 12.0,
    this.endOffset = 10.0,
    this.opacityLight = 0.4,
    this.activeBackgroundColor,
    this.inactiveBackgroundColor,
    this.activeTextColor,
    this.inactiveTextColor,
  });

  const ReactionsTheme.light()
      : this(
          activeBackgroundColor: Colors.blue,
          inactiveBackgroundColor: Colors.grey,
          activeTextColor: Colors.white,
          inactiveTextColor: Colors.black,
        );

  const ReactionsTheme.dark()
      : this(
          activeBackgroundColor: Colors.blue,
          inactiveBackgroundColor: Colors.grey,
          activeTextColor: Colors.white,
          inactiveTextColor: Colors.black,
        );

  /// Creates a copy of [ReactionsTheme] with updated values.
  ///
  /// * [spacing] is the new spacing.
  /// * [padding] is the new padding.
  /// * [verticalPadding] is the new vertical padding.
  /// * [borderRadius] is the new border radius.
  /// * [emojiSize] is the new emoji size.
  /// * [countSize] is the new count size.
  /// * [topOffset] is the new top offset.
  /// * [endOffset] is the new end offset.
  /// * [opacityLight] is the new opacity for light reactions.
  /// * [activeBackgroundColor] is the new background color for active reactions.
  /// * [inactiveBackgroundColor] is the new background color for inactive reactions.
  /// * [activeTextColor] is the new text color for active reactions.
  /// * [inactiveTextColor] is the new text color for inactive reactions.
  ReactionsTheme copyWith({
    double? spacing,
    double? padding,
    double? verticalPadding,
    double? borderRadius,
    double? emojiSize,
    double? countSize,
    double? topOffset,
    double? endOffset,
    double? opacityLight,
    Color? activeBackgroundColor,
    Color? inactiveBackgroundColor,
    Color? activeTextColor,
    Color? inactiveTextColor,
  }) {
    return ReactionsTheme(
      spacing: spacing ?? this.spacing,
      padding: padding ?? this.padding,
      verticalPadding: verticalPadding ?? this.verticalPadding,
      borderRadius: borderRadius ?? this.borderRadius,
      emojiSize: emojiSize ?? this.emojiSize,
      countSize: countSize ?? this.countSize,
      topOffset: topOffset ?? this.topOffset,
      endOffset: endOffset ?? this.endOffset,
      opacityLight: opacityLight ?? this.opacityLight,
      activeBackgroundColor:
          activeBackgroundColor ?? this.activeBackgroundColor,
      inactiveBackgroundColor:
          inactiveBackgroundColor ?? this.inactiveBackgroundColor,
      activeTextColor: activeTextColor ?? this.activeTextColor,
      inactiveTextColor: inactiveTextColor ?? this.inactiveTextColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ReactionsTheme &&
        other.spacing == spacing &&
        other.padding == padding &&
        other.verticalPadding == verticalPadding &&
        other.borderRadius == borderRadius &&
        other.emojiSize == emojiSize &&
        other.countSize == countSize &&
        other.topOffset == topOffset &&
        other.endOffset == endOffset &&
        other.opacityLight == opacityLight &&
        other.activeBackgroundColor == activeBackgroundColor &&
        other.inactiveBackgroundColor == inactiveBackgroundColor &&
        other.activeTextColor == activeTextColor &&
        other.inactiveTextColor == inactiveTextColor;
  }

  @override
  int get hashCode => Object.hash(
        spacing,
        padding,
        verticalPadding,
        borderRadius,
        emojiSize,
        countSize,
        topOffset,
        endOffset,
        opacityLight,
        activeBackgroundColor,
        inactiveBackgroundColor,
        activeTextColor,
        inactiveTextColor,
      );
}

/// Status theme configuration
class StatusTheme {
  /// Status icon size
  final double iconSize;

  /// Status spacing
  final double spacing;

  /// Timestamp text size
  final double timestampSize;

  /// Opacity for dimmed elements
  final double opacityDimmed;

  /// Color for sent status
  final Color? sentColor;

  /// Color for delivered status
  final Color? deliveredColor;

  /// Color for read status
  final Color? readColor;

  /// Color for error status
  final Color? errorColor;

  /// Color for sending status
  final Color? sendingColor;

  /// Creates a new [StatusTheme] instance.
  ///
  /// * [iconSize] is the new icon size.
  /// * [spacing] is the new spacing.
  /// * [timestampSize] is the new timestamp size.
  /// * [opacityDimmed] is the new opacity for dimmed elements.
  /// * [sentColor] is the new color for sent status.
  /// * [deliveredColor] is the new color for delivered status.
  /// * [readColor] is the new color for read status.
  /// * [errorColor] is the new color for error status.
  /// * [sendingColor] is the new color for sending status.
  const StatusTheme({
    this.iconSize = 12.0,
    this.spacing = 4.0,
    this.timestampSize = 10.0,
    this.opacityDimmed = 0.7,
    this.sentColor,
    this.deliveredColor,
    this.readColor,
    this.errorColor,
    this.sendingColor,
  });

  const StatusTheme.light()
      : this(
          readColor: Colors.blue,
          errorColor: Colors.red,
          sendingColor: Colors.grey,
        );

  const StatusTheme.dark()
      : this(
          readColor: Colors.blue,
          errorColor: Colors.red,
          sendingColor: Colors.grey,
        );

  /// Creates a copy of [StatusTheme] with updated values.
  ///
  /// * [iconSize] is the new icon size.
  /// * [spacing] is the new spacing.
  /// * [timestampSize] is the new timestamp size.
  /// * [opacityDimmed] is the new opacity for dimmed elements.
  /// * [sentColor] is the new color for sent status.
  /// * [deliveredColor] is the new color for delivered status.
  /// * [readColor] is the new color for read status.
  /// * [errorColor] is the new color for error status.
  /// * [sendingColor] is the new color for sending status.
  StatusTheme copyWith({
    double? iconSize,
    double? spacing,
    double? timestampSize,
    double? opacityDimmed,
    Color? sentColor,
    Color? deliveredColor,
    Color? readColor,
    Color? errorColor,
    Color? sendingColor,
  }) {
    return StatusTheme(
      iconSize: iconSize ?? this.iconSize,
      spacing: spacing ?? this.spacing,
      timestampSize: timestampSize ?? this.timestampSize,
      opacityDimmed: opacityDimmed ?? this.opacityDimmed,
      sentColor: sentColor ?? this.sentColor,
      deliveredColor: deliveredColor ?? this.deliveredColor,
      readColor: readColor ?? this.readColor,
      errorColor: errorColor ?? this.errorColor,
      sendingColor: sendingColor ?? this.sendingColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StatusTheme &&
        other.iconSize == iconSize &&
        other.spacing == spacing &&
        other.timestampSize == timestampSize &&
        other.opacityDimmed == opacityDimmed &&
        other.sentColor == sentColor &&
        other.deliveredColor == deliveredColor &&
        other.readColor == readColor &&
        other.errorColor == errorColor &&
        other.sendingColor == sendingColor;
  }

  @override
  int get hashCode => Object.hash(
        iconSize,
        spacing,
        timestampSize,
        opacityDimmed,
        sentColor,
        deliveredColor,
        readColor,
        errorColor,
        sendingColor,
      );
}

/// Spacing theme configuration
class SpacingTheme {
  /// Empty space width
  final double emptySpaceWidth;

  /// Empty space height
  final double emptySpaceHeight;

  /// Aspect ratio for square elements
  final double aspectRatioSquare;

  const SpacingTheme({
    this.emptySpaceWidth = 20.0,
    this.emptySpaceHeight = 15.0,
    this.aspectRatioSquare = 1.0,
  });

  const SpacingTheme.standard() : this();

  /// Creates a copy of [SpacingTheme] with updated values.
  ///
  /// * [emptySpaceWidth] is the new empty space width.
  /// * [emptySpaceHeight] is the new empty space height.
  /// * [aspectRatioSquare] is the new aspect ratio for square elements.
  SpacingTheme copyWith({
    double? emptySpaceWidth,
    double? emptySpaceHeight,
    double? aspectRatioSquare,
  }) {
    return SpacingTheme(
      emptySpaceWidth: emptySpaceWidth ?? this.emptySpaceWidth,
      emptySpaceHeight: emptySpaceHeight ?? this.emptySpaceHeight,
      aspectRatioSquare: aspectRatioSquare ?? this.aspectRatioSquare,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SpacingTheme &&
        other.emptySpaceWidth == emptySpaceWidth &&
        other.emptySpaceHeight == emptySpaceHeight &&
        other.aspectRatioSquare == aspectRatioSquare;
  }

  @override
  int get hashCode =>
      Object.hash(emptySpaceWidth, emptySpaceHeight, aspectRatioSquare);
}

/// Poll bubble configuration for either sender or receiver
class PollBubbleConfig {
  /// Background color
  final Color? backgroundColor;

  /// Border color
  final Color? borderColor;

  /// Title text color
  final Color? titleTextColor;

  /// Subtitle text color
  final Color? subtitleTextColor;

  /// Option text color
  final Color? optionTextColor;

  /// Vote count text color
  final Color? voteCountTextColor;

  /// Footer text color
  final Color? footerTextColor;

  /// Progress bar color
  final Color? progressBarColor;

  /// Progress bar background color
  final Color? progressBarBackgroundColor;

  /// Selected option color
  final Color? selectedOptionColor;

  /// Option background color
  final Color? optionBackgroundColor;

  /// Shadow color
  final Color? shadowColor;

  /// Shadow elevation
  final double shadowElevation;

  /// Whether to show shadow
  final bool showShadow;

  /// Border width
  final double borderWidth;

  const PollBubbleConfig({
    this.backgroundColor,
    this.borderColor,
    this.titleTextColor,
    this.subtitleTextColor,
    this.optionTextColor,
    this.voteCountTextColor,
    this.footerTextColor,
    this.progressBarColor,
    this.progressBarBackgroundColor,
    this.selectedOptionColor,
    this.optionBackgroundColor,
    this.shadowColor,
    this.shadowElevation = 1.0,
    this.showShadow = true,
    this.borderWidth = 0.0,
  });

  PollBubbleConfig copyWith({
    Color? backgroundColor,
    Color? borderColor,
    Color? titleTextColor,
    Color? subtitleTextColor,
    Color? optionTextColor,
    Color? voteCountTextColor,
    Color? footerTextColor,
    Color? progressBarColor,
    Color? progressBarBackgroundColor,
    Color? selectedOptionColor,
    Color? optionBackgroundColor,
    Color? shadowColor,
    double? shadowElevation,
    bool? showShadow,
    double? borderWidth,
  }) {
    return PollBubbleConfig(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      titleTextColor: titleTextColor ?? this.titleTextColor,
      subtitleTextColor: subtitleTextColor ?? this.subtitleTextColor,
      optionTextColor: optionTextColor ?? this.optionTextColor,
      voteCountTextColor: voteCountTextColor ?? this.voteCountTextColor,
      footerTextColor: footerTextColor ?? this.footerTextColor,
      progressBarColor: progressBarColor ?? this.progressBarColor,
      progressBarBackgroundColor:
          progressBarBackgroundColor ?? this.progressBarBackgroundColor,
      selectedOptionColor: selectedOptionColor ?? this.selectedOptionColor,
      optionBackgroundColor:
          optionBackgroundColor ?? this.optionBackgroundColor,
      shadowColor: shadowColor ?? this.shadowColor,
      shadowElevation: shadowElevation ?? this.shadowElevation,
      showShadow: showShadow ?? this.showShadow,
      borderWidth: borderWidth ?? this.borderWidth,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PollBubbleConfig &&
        other.backgroundColor == backgroundColor &&
        other.borderColor == borderColor &&
        other.titleTextColor == titleTextColor &&
        other.subtitleTextColor == subtitleTextColor &&
        other.optionTextColor == optionTextColor &&
        other.voteCountTextColor == voteCountTextColor &&
        other.footerTextColor == footerTextColor &&
        other.progressBarColor == progressBarColor &&
        other.progressBarBackgroundColor == progressBarBackgroundColor &&
        other.selectedOptionColor == selectedOptionColor &&
        other.optionBackgroundColor == optionBackgroundColor &&
        other.shadowColor == shadowColor &&
        other.shadowElevation == shadowElevation &&
        other.showShadow == showShadow &&
        other.borderWidth == borderWidth;
  }

  @override
  int get hashCode => Object.hash(
        backgroundColor,
        borderColor,
        titleTextColor,
        subtitleTextColor,
        optionTextColor,
        voteCountTextColor,
        footerTextColor,
        progressBarColor,
        progressBarBackgroundColor,
        selectedOptionColor,
        optionBackgroundColor,
        shadowColor,
        shadowElevation,
        showShadow,
        borderWidth,
      );
}

/// Poll theme configuration
class PollTheme {
  /// Configuration for sent poll messages
  final PollBubbleConfig sender;

  /// Configuration for received poll messages
  final PollBubbleConfig receiver;

  /// Border radius for poll container
  final double borderRadius;

  /// Maximum width factor for poll
  final double maxWidthFactor;

  /// Container padding
  final double containerPadding;

  /// Option padding
  final double optionPadding;

  /// Option spacing
  final double optionSpacing;

  /// Progress bar height
  final double progressBarHeight;

  /// Progress bar radius
  final double progressBarRadius;

  /// Icon size
  final double iconSize;

  /// Avatar size in poll
  final double avatarSize;

  /// Title font size
  final double titleFontSize;

  /// Subtitle font size
  final double subtitleFontSize;

  /// Option font size
  final double optionFontSize;

  /// Vote font size
  final double voteFontSize;

  /// Footer font size
  final double footerFontSize;

  /// Vote count spacing
  final double voteCountSpacing;

  /// Footer spacing
  final double footerSpacing;

  /// Alpha for overlay
  final double alphaOverlay;

  /// Alpha for border
  final double borderAlpha;

  /// Alpha for progress
  final double progressAlpha;

  /// Alpha for selected option
  final double selectedAlpha;

  /// Creates a new [PollTheme] instance.
  ///
  /// * [borderRadius] is the new border radius.
  /// * [maxWidthFactor] is the new max width factor.
  /// * [containerPadding] is the new container padding.
  /// * [optionPadding] is the new option padding.
  /// * [optionSpacing] is the new option spacing.
  /// * [progressBarHeight] is the new progress bar height.
  /// * [progressBarRadius] is the new progress bar radius.
  /// * [iconSize] is the new icon size.
  /// * [avatarSize] is the new avatar size.
  /// * [titleFontSize] is the new title font size.
  /// * [subtitleFontSize] is the new subtitle font size.
  /// * [optionFontSize] is the new option font size.
  /// * [voteFontSize] is the new vote font size.
  /// * [footerFontSize] is the new footer font size.
  /// * [voteCountSpacing] is the new vote count spacing.
  /// * [footerSpacing] is the new footer spacing.
  /// * [alphaOverlay] is the new alpha for the overlay.
  /// * [borderAlpha] is the new alpha for the border.
  /// * [progressAlpha] is the new alpha for the progress.
  /// * [selectedAlpha] is the new alpha for the selected option.
  const PollTheme({
    required this.sender,
    required this.receiver,
    this.borderRadius = 16.0,
    this.maxWidthFactor = 0.9,
    this.containerPadding = 12.0,
    this.optionPadding = 8.0,
    this.optionSpacing = 4.0,
    this.progressBarHeight = 6.0,
    this.progressBarRadius = 3.0,
    this.iconSize = 18.0,
    this.avatarSize = 24.0,
    this.titleFontSize = 16.0,
    this.subtitleFontSize = 13.0,
    this.optionFontSize = 15.0,
    this.voteFontSize = 13.0,
    this.footerFontSize = 12.0,
    this.voteCountSpacing = 8.0,
    this.footerSpacing = 12.0,
    this.alphaOverlay = 1.0,
    this.borderAlpha = 0.0,
    this.progressAlpha = 1.0,
    this.selectedAlpha = 1.0,
  });

  const PollTheme.light()
      : this(
          sender: const PollBubbleConfig(
            backgroundColor: Color(0xFFF8F8F8),
            borderColor: Color(0xFFE0E0E0),
            titleTextColor: Color(0xFF121212),
            subtitleTextColor: Color(0xFF757575),
            optionTextColor: Color(0xFF121212),
            voteCountTextColor: Color(0xFF757575),
            footerTextColor: Color(0xFF757575),
            progressBarColor: Color(0xFF974EE9),
            progressBarBackgroundColor: Color(0xFFE0E0E0),
            selectedOptionColor: Color(0xFF974EE9),
            optionBackgroundColor: Color(0xFFF5F5F5),
            shadowColor: Color(0x1A000000),
            shadowElevation: 1.0,
            showShadow: true,
          ),
          receiver: const PollBubbleConfig(
            backgroundColor: Color(0xFFFFFFFF),
            borderColor: Color(0xFFE0E0E0),
            titleTextColor: Color(0xFF121212),
            subtitleTextColor: Color(0xFF757575),
            optionTextColor: Color(0xFF121212),
            voteCountTextColor: Color(0xFF757575),
            footerTextColor: Color(0xFF757575),
            progressBarColor: Color(0xFF974EE9),
            progressBarBackgroundColor: Color(0xFFE0E0E0),
            selectedOptionColor: Color(0xFF974EE9),
            optionBackgroundColor: Color(0xFFF5F5F5),
            shadowColor: Color(0x1A000000),
            shadowElevation: 1.0,
            showShadow: true,
          ),
        );

  const PollTheme.dark()
      : this(
          sender: const PollBubbleConfig(
            backgroundColor: Color(0xFF1C1C1E),
            borderColor: Color(0xFF444444),
            titleTextColor: Color(0xFFFFFFFF),
            subtitleTextColor: Color(0xFFB0B0B0),
            optionTextColor: Color(0xFFFFFFFF),
            voteCountTextColor: Color(0xFFB0B0B0),
            footerTextColor: Color(0xFFB0B0B0),
            progressBarColor: Color(0xFF974EE9),
            progressBarBackgroundColor: Color(0xFF444444),
            selectedOptionColor: Color(0xFF974EE9),
            optionBackgroundColor: Color(0xFF2C2C2E),
            shadowColor: Color(0x40000000),
            shadowElevation: 2.0,
            showShadow: true,
          ),
          receiver: const PollBubbleConfig(
            backgroundColor: Color(0xFF2C2C2E),
            borderColor: Color(0xFF444444),
            titleTextColor: Color(0xFFFFFFFF),
            subtitleTextColor: Color(0xFFB0B0B0),
            optionTextColor: Color(0xFFFFFFFF),
            voteCountTextColor: Color(0xFFB0B0B0),
            footerTextColor: Color(0xFFB0B0B0),
            progressBarColor: Color(0xFF974EE9),
            progressBarBackgroundColor: Color(0xFF444444),
            selectedOptionColor: Color(0xFF974EE9),
            optionBackgroundColor: Color(0xFF2C2C2E),
            shadowColor: Color(0x40000000),
            shadowElevation: 2.0,
            showShadow: true,
          ),
        );

  /// Creates a copy of [PollTheme] with updated values.
  ///
  /// * [borderRadius] is the new border radius.
  /// * [maxWidthFactor] is the new max width factor.
  /// * [containerPadding] is the new container padding.
  /// * [optionPadding] is the new option padding.
  /// * [optionSpacing] is the new option spacing.
  /// * [progressBarHeight] is the new progress bar height.
  /// * [progressBarRadius] is the new progress bar radius.
  /// * [iconSize] is the new icon size.
  /// * [avatarSize] is the new avatar size.
  /// * [titleFontSize] is the new title font size.
  /// * [subtitleFontSize] is the new subtitle font size.
  /// * [optionFontSize] is the new option font size.
  /// * [voteFontSize] is the new vote font size.
  /// * [footerFontSize] is the new footer font size.
  /// * [voteCountSpacing] is the new vote count spacing.
  /// * [footerSpacing] is the new footer spacing.
  /// * [alphaOverlay] is the new alpha for the overlay.
  /// * [borderAlpha] is the new alpha for the border.
  /// * [progressAlpha] is the new alpha for the progress.
  /// * [selectedAlpha] is the new alpha for the selected option.
  PollTheme copyWith({
    PollBubbleConfig? sender,
    PollBubbleConfig? receiver,
    double? borderRadius,
    double? maxWidthFactor,
    double? containerPadding,
    double? optionPadding,
    double? optionSpacing,
    double? progressBarHeight,
    double? progressBarRadius,
    double? iconSize,
    double? avatarSize,
    double? titleFontSize,
    double? subtitleFontSize,
    double? optionFontSize,
    double? voteFontSize,
    double? footerFontSize,
    double? voteCountSpacing,
    double? footerSpacing,
    double? alphaOverlay,
    double? borderAlpha,
    double? progressAlpha,
    double? selectedAlpha,
  }) {
    return PollTheme(
      sender: sender ?? this.sender,
      receiver: receiver ?? this.receiver,
      borderRadius: borderRadius ?? this.borderRadius,
      maxWidthFactor: maxWidthFactor ?? this.maxWidthFactor,
      containerPadding: containerPadding ?? this.containerPadding,
      optionPadding: optionPadding ?? this.optionPadding,
      optionSpacing: optionSpacing ?? this.optionSpacing,
      progressBarHeight: progressBarHeight ?? this.progressBarHeight,
      progressBarRadius: progressBarRadius ?? this.progressBarRadius,
      iconSize: iconSize ?? this.iconSize,
      avatarSize: avatarSize ?? this.avatarSize,
      titleFontSize: titleFontSize ?? this.titleFontSize,
      subtitleFontSize: subtitleFontSize ?? this.subtitleFontSize,
      optionFontSize: optionFontSize ?? this.optionFontSize,
      voteFontSize: voteFontSize ?? this.voteFontSize,
      footerFontSize: footerFontSize ?? this.footerFontSize,
      voteCountSpacing: voteCountSpacing ?? this.voteCountSpacing,
      footerSpacing: footerSpacing ?? this.footerSpacing,
      alphaOverlay: alphaOverlay ?? this.alphaOverlay,
      borderAlpha: borderAlpha ?? this.borderAlpha,
      progressAlpha: progressAlpha ?? this.progressAlpha,
      selectedAlpha: selectedAlpha ?? this.selectedAlpha,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PollTheme &&
        other.borderRadius == borderRadius &&
        other.maxWidthFactor == maxWidthFactor &&
        other.containerPadding == containerPadding;
  }

  @override
  int get hashCode =>
      Object.hash(borderRadius, maxWidthFactor, containerPadding);
}

/// Location bubble configuration for either sender or receiver
class LocationBubbleConfig {
  /// Background color
  final Color? backgroundColor;

  /// Border color
  final Color? borderColor;

  /// Pin color
  final Color? pinColor;

  /// Name text color
  final Color? nameTextColor;

  /// Coordinates text color
  final Color? coordsTextColor;

  /// Map overlay color
  final Color? mapOverlayColor;

  /// Action button color
  final Color? actionButtonColor;

  /// Action icon color
  final Color? actionIconColor;

  /// Shadow color
  final Color? shadowColor;

  /// Shadow elevation
  final double shadowElevation;

  /// Whether to show shadow
  final bool showShadow;

  /// Border width
  final double borderWidth;

  const LocationBubbleConfig({
    this.backgroundColor,
    this.borderColor,
    this.pinColor,
    this.nameTextColor,
    this.coordsTextColor,
    this.mapOverlayColor,
    this.actionButtonColor,
    this.actionIconColor,
    this.shadowColor,
    this.shadowElevation = 1.0,
    this.showShadow = true,
    this.borderWidth = 0.0,
  });

  LocationBubbleConfig copyWith({
    Color? backgroundColor,
    Color? borderColor,
    Color? pinColor,
    Color? nameTextColor,
    Color? coordsTextColor,
    Color? mapOverlayColor,
    Color? actionButtonColor,
    Color? actionIconColor,
    Color? shadowColor,
    double? shadowElevation,
    bool? showShadow,
    double? borderWidth,
  }) {
    return LocationBubbleConfig(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      pinColor: pinColor ?? this.pinColor,
      nameTextColor: nameTextColor ?? this.nameTextColor,
      coordsTextColor: coordsTextColor ?? this.coordsTextColor,
      mapOverlayColor: mapOverlayColor ?? this.mapOverlayColor,
      actionButtonColor: actionButtonColor ?? this.actionButtonColor,
      actionIconColor: actionIconColor ?? this.actionIconColor,
      shadowColor: shadowColor ?? this.shadowColor,
      shadowElevation: shadowElevation ?? this.shadowElevation,
      showShadow: showShadow ?? this.showShadow,
      borderWidth: borderWidth ?? this.borderWidth,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocationBubbleConfig &&
        other.backgroundColor == backgroundColor &&
        other.borderColor == borderColor &&
        other.pinColor == pinColor &&
        other.nameTextColor == nameTextColor &&
        other.coordsTextColor == coordsTextColor &&
        other.mapOverlayColor == mapOverlayColor &&
        other.actionButtonColor == actionButtonColor &&
        other.actionIconColor == actionIconColor &&
        other.shadowColor == shadowColor &&
        other.shadowElevation == shadowElevation &&
        other.showShadow == showShadow &&
        other.borderWidth == borderWidth;
  }

  @override
  int get hashCode => Object.hash(
        backgroundColor,
        borderColor,
        pinColor,
        nameTextColor,
        coordsTextColor,
        mapOverlayColor,
        actionButtonColor,
        actionIconColor,
        shadowColor,
        shadowElevation,
        showShadow,
        borderWidth,
      );
}

/// Location theme configuration
class LocationTheme {
  /// Configuration for sent location messages
  final LocationBubbleConfig sender;

  /// Configuration for received location messages
  final LocationBubbleConfig receiver;

  /// Border radius for location container
  final double borderRadius;

  /// Container height
  final double containerHeight;

  /// Width factor
  final double widthFactor;

  /// Map icon size
  final double mapIconSize;

  /// Pin size
  final double pinSize;

  /// Pin padding
  final double pinPadding;

  /// Details padding
  final double detailsPadding;

  /// Details spacing
  final double detailsSpacing;

  /// Name text size
  final double nameTextSize;

  /// Coordinates text size
  final double coordsTextSize;

  /// Icon alpha
  final double iconAlpha;

  /// Shadow blur radius
  final double shadowBlurRadius;

  /// Shadow spread radius
  final double shadowSpreadRadius;

  /// Map zoom level
  final double mapZoom;

  /// Mini map height
  final double miniMapHeight;

  /// Action button size
  final double actionButtonSize;

  /// Action icon size
  final double actionIconSize;

  /// Creates a new [LocationTheme] instance.
  ///
  /// [borderRadius] is the border radius for the location container.
  /// [containerHeight] is the height of the location container.
  /// [widthFactor] is the width factor for the location container.
  /// [mapIconSize] is the size of the map icon.
  /// [pinSize] is the size of the pin.
  /// [pinPadding] is the padding for the pin.
  /// [detailsPadding] is the padding for the details.
  /// [detailsSpacing] is the spacing for the details.
  /// [nameTextSize] is the size of the name text.
  /// [coordsTextSize] is the size of the coordinates text.
  /// [iconAlpha] is the alpha for the icon.
  /// [shadowBlurRadius] is the blur radius for the shadow.
  /// [shadowSpreadRadius] is the spread radius for the shadow.
  /// [mapZoom] is the zoom level for the map.
  /// [miniMapHeight] is the height of the mini map.
  /// [actionButtonSize] is the size of the action button.
  /// [actionIconSize] is the size of the action icon.

  const LocationTheme({
    required this.sender,
    required this.receiver,
    this.borderRadius = 12.0,
    this.containerHeight = 180.0,
    this.widthFactor = 0.75,
    this.mapIconSize = 24.0,
    this.pinSize = 32.0,
    this.pinPadding = 8.0,
    this.detailsPadding = 12.0,
    this.detailsSpacing = 6.0,
    this.nameTextSize = 15.0,
    this.coordsTextSize = 11.0,
    this.iconAlpha = 0.7,
    this.shadowBlurRadius = 8.0,
    this.shadowSpreadRadius = 2.0,
    this.mapZoom = 15.0,
    this.miniMapHeight = 120.0,
    this.actionButtonSize = 36.0,
    this.actionIconSize = 18.0,
  });

  const LocationTheme.standard()
      : this(
          sender: const LocationBubbleConfig(
            backgroundColor: Color(0xFFF8F8F8),
            borderColor: Color(0xFFE0E0E0),
            pinColor: Color(0xFF974EE9),
            nameTextColor: Color(0xFF121212),
            coordsTextColor: Color(0xFF757575),
            mapOverlayColor: Color(0x40000000),
            actionButtonColor: Color(0xFF974EE9),
            actionIconColor: Color(0xFFFFFFFF),
            shadowColor: Color(0x1A000000),
            shadowElevation: 1.0,
            showShadow: true,
          ),
          receiver: const LocationBubbleConfig(
            backgroundColor: Color(0xFFFFFFFF),
            borderColor: Color(0xFFE0E0E0),
            pinColor: Color(0xFF974EE9),
            nameTextColor: Color(0xFF121212),
            coordsTextColor: Color(0xFF757575),
            mapOverlayColor: Color(0x40000000),
            actionButtonColor: Color(0xFF974EE9),
            actionIconColor: Color(0xFFFFFFFF),
            shadowColor: Color(0x1A000000),
            shadowElevation: 1.0,
            showShadow: true,
          ),
        );

  /// Creates a copy of [LocationTheme] with updated values.
  ///
  /// * [borderRadius] is the new border radius.
  /// * [containerHeight] is the new container height.
  /// * [widthFactor] is the new width factor.
  /// * [mapIconSize] is the new map icon size.
  /// * [pinSize] is the new pin size.
  /// * [pinPadding] is the new pin padding.
  /// * [detailsPadding] is the new details padding.
  /// * [detailsSpacing] is the new details spacing.
  /// * [nameTextSize] is the new name text size.
  /// * [coordsTextSize] is the new coordinates text size.
  /// * [iconAlpha] is the new icon alpha.
  /// * [shadowBlurRadius] is the new shadow blur radius.
  /// * [shadowSpreadRadius] is the new shadow spread radius.
  /// * [animationDuration] is the new animation duration.
  /// * [mapZoom] is the new map zoom level.
  /// * [miniMapHeight] is the new mini map height.
  /// * [actionButtonSize] is the new action button size.
  /// * [actionIconSize] is the new action icon size.
  ///
  LocationTheme copyWith({
    LocationBubbleConfig? sender,
    LocationBubbleConfig? receiver,
    double? borderRadius,
    double? containerHeight,
    double? widthFactor,
    double? mapIconSize,
    double? pinSize,
    double? pinPadding,
    double? detailsPadding,
    double? detailsSpacing,
    double? nameTextSize,
    double? coordsTextSize,
    double? iconAlpha,
    double? shadowBlurRadius,
    double? shadowSpreadRadius,
    double? mapZoom,
    double? miniMapHeight,
    double? actionButtonSize,
    double? actionIconSize,
  }) {
    return LocationTheme(
      sender: sender ?? this.sender,
      receiver: receiver ?? this.receiver,
      borderRadius: borderRadius ?? this.borderRadius,
      containerHeight: containerHeight ?? this.containerHeight,
      widthFactor: widthFactor ?? this.widthFactor,
      mapIconSize: mapIconSize ?? this.mapIconSize,
      pinSize: pinSize ?? this.pinSize,
      pinPadding: pinPadding ?? this.pinPadding,
      detailsPadding: detailsPadding ?? this.detailsPadding,
      detailsSpacing: detailsSpacing ?? this.detailsSpacing,
      nameTextSize: nameTextSize ?? this.nameTextSize,
      coordsTextSize: coordsTextSize ?? this.coordsTextSize,
      iconAlpha: iconAlpha ?? this.iconAlpha,
      shadowBlurRadius: shadowBlurRadius ?? this.shadowBlurRadius,
      shadowSpreadRadius: shadowSpreadRadius ?? this.shadowSpreadRadius,
      mapZoom: mapZoom ?? this.mapZoom,
      miniMapHeight: miniMapHeight ?? this.miniMapHeight,
      actionButtonSize: actionButtonSize ?? this.actionButtonSize,
      actionIconSize: actionIconSize ?? this.actionIconSize,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocationTheme &&
        other.borderRadius == borderRadius &&
        other.containerHeight == containerHeight &&
        other.widthFactor == widthFactor;
  }

  @override
  int get hashCode => Object.hash(borderRadius, containerHeight, widthFactor);
}

/// Input theme configuration for chat input widgets
class InputTheme {
  /// Border radius for input fields
  final double borderRadius;

  /// Input field height
  final double inputHeight;

  /// Padding inside input field
  final EdgeInsetsGeometry inputPadding;

  /// Margin around input field
  final EdgeInsetsGeometry inputMargin;

  /// Background color for input field
  final Color? backgroundColor;

  /// Border color for input field
  final Color? borderColor;

  /// Text color for input field
  final Color? textColor;

  /// Hint text color
  final Color? hintColor;

  /// Icon color for input actions
  final Color? iconColor;

  /// Send button color
  final Color? sendButtonColor;

  /// Recording indicator color
  final Color? recordingColor;

  /// Attachment button size
  final double attachmentButtonSize;

  /// Send button size
  final double sendButtonSize;

  /// Icon size for action buttons
  final double iconSize;

  /// Font size for input text
  final double fontSize;

  /// Max lines for input
  final int maxLines;

  /// Min lines for input
  final int minLines;

  /// Elevation for input container
  final double elevation;

  const InputTheme({
    this.borderRadius = 25.0,
    this.inputHeight = 50.0,
    this.inputPadding = const EdgeInsets.symmetric(
      horizontal: 16.0,
      vertical: 8.0,
    ),
    this.inputMargin = const EdgeInsets.all(8.0),
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.hintColor,
    this.iconColor,
    this.sendButtonColor,
    this.recordingColor,
    this.attachmentButtonSize = 40.0,
    this.sendButtonSize = 40.0,
    this.iconSize = 24.0,
    this.fontSize = 16.0,
    this.maxLines = 5,
    this.minLines = 1,
    this.elevation = 2.0,
  });

  /// Light theme for input
  const InputTheme.light()
      : this(
          backgroundColor: const Color(0xFFFBF5FF),
          borderColor: const Color(0xFFE0E0E0),
          textColor: const Color(0xFF121212),
          hintColor: const Color(0xFF757575),
          iconColor: const Color(0xFF974EE9),
          sendButtonColor: const Color(0xFF974EE9),
          recordingColor: const Color(0xFFFF5722),
        );

  /// Dark theme for input
  const InputTheme.dark()
      : this(
          backgroundColor: const Color(0xFF1C1C1E),
          borderColor: const Color(0xFF333333),
          textColor: const Color(0xFFFFFFFF),
          hintColor: const Color(0xFFB0B0B0),
          iconColor: const Color(0xFF974EE9),
          sendButtonColor: const Color(0xFF974EE9),
          recordingColor: const Color(0xFFFF5722),
        );

  InputTheme copyWith({
    double? borderRadius,
    double? inputHeight,
    EdgeInsetsGeometry? inputPadding,
    EdgeInsetsGeometry? inputMargin,
    Color? backgroundColor,
    Color? borderColor,
    Color? textColor,
    Color? hintColor,
    Color? iconColor,
    Color? sendButtonColor,
    Color? recordingColor,
    double? attachmentButtonSize,
    double? sendButtonSize,
    double? iconSize,
    double? fontSize,
    int? maxLines,
    int? minLines,
    double? elevation,
  }) {
    return InputTheme(
      borderRadius: borderRadius ?? this.borderRadius,
      inputHeight: inputHeight ?? this.inputHeight,
      inputPadding: inputPadding ?? this.inputPadding,
      inputMargin: inputMargin ?? this.inputMargin,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      textColor: textColor ?? this.textColor,
      hintColor: hintColor ?? this.hintColor,
      iconColor: iconColor ?? this.iconColor,
      sendButtonColor: sendButtonColor ?? this.sendButtonColor,
      recordingColor: recordingColor ?? this.recordingColor,
      attachmentButtonSize: attachmentButtonSize ?? this.attachmentButtonSize,
      sendButtonSize: sendButtonSize ?? this.sendButtonSize,
      iconSize: iconSize ?? this.iconSize,
      fontSize: fontSize ?? this.fontSize,
      maxLines: maxLines ?? this.maxLines,
      minLines: minLines ?? this.minLines,
      elevation: elevation ?? this.elevation,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is InputTheme &&
        other.borderRadius == borderRadius &&
        other.inputHeight == inputHeight &&
        other.backgroundColor == backgroundColor;
  }

  @override
  int get hashCode => Object.hash(borderRadius, inputHeight, backgroundColor);
}

/// Video bubble configuration for either sender or receiver
class VideoBubbleConfig {
  /// Overlay color for video controls
  final Color? overlayColor;

  /// Play button color
  final Color? playButtonColor;

  /// Progress bar color
  final Color? progressColor;

  /// Progress background color
  final Color? progressBackgroundColor;

  /// Loading indicator color
  final Color? loadingColor;

  /// Error color
  final Color? errorColor;

  /// Caption text color
  final Color? captionColor;

  /// Caption background color
  final Color? captionBackgroundColor;

  /// Duration text color
  final Color? durationTextColor;

  /// Duration background color
  final Color? durationBackgroundColor;

  /// Background color for video container
  final Color? backgroundColor;

  /// Border color
  final Color? borderColor;

  /// Border width
  final double borderWidth;

  /// Shadow color
  final Color? shadowColor;

  /// Shadow elevation
  final double shadowElevation;

  /// Whether to show shadow
  final bool showShadow;

  const VideoBubbleConfig({
    this.overlayColor,
    this.playButtonColor,
    this.progressColor,
    this.progressBackgroundColor,
    this.loadingColor,
    this.errorColor,
    this.captionColor,
    this.captionBackgroundColor,
    this.durationTextColor,
    this.durationBackgroundColor,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 0.0,
    this.shadowColor,
    this.shadowElevation = 1.0,
    this.showShadow = true,
  });

  VideoBubbleConfig copyWith({
    Color? overlayColor,
    Color? playButtonColor,
    Color? progressColor,
    Color? progressBackgroundColor,
    Color? loadingColor,
    Color? errorColor,
    Color? captionColor,
    Color? captionBackgroundColor,
    Color? durationTextColor,
    Color? durationBackgroundColor,
    Color? backgroundColor,
    Color? borderColor,
    double? borderWidth,
    Color? shadowColor,
    double? shadowElevation,
    bool? showShadow,
  }) {
    return VideoBubbleConfig(
      overlayColor: overlayColor ?? this.overlayColor,
      playButtonColor: playButtonColor ?? this.playButtonColor,
      progressColor: progressColor ?? this.progressColor,
      progressBackgroundColor:
          progressBackgroundColor ?? this.progressBackgroundColor,
      loadingColor: loadingColor ?? this.loadingColor,
      errorColor: errorColor ?? this.errorColor,
      captionColor: captionColor ?? this.captionColor,
      captionBackgroundColor:
          captionBackgroundColor ?? this.captionBackgroundColor,
      durationTextColor: durationTextColor ?? this.durationTextColor,
      durationBackgroundColor:
          durationBackgroundColor ?? this.durationBackgroundColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      shadowColor: shadowColor ?? this.shadowColor,
      shadowElevation: shadowElevation ?? this.shadowElevation,
      showShadow: showShadow ?? this.showShadow,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VideoBubbleConfig &&
        other.overlayColor == overlayColor &&
        other.playButtonColor == playButtonColor &&
        other.progressColor == progressColor &&
        other.progressBackgroundColor == progressBackgroundColor &&
        other.loadingColor == loadingColor &&
        other.errorColor == errorColor &&
        other.captionColor == captionColor &&
        other.captionBackgroundColor == captionBackgroundColor &&
        other.durationTextColor == durationTextColor &&
        other.durationBackgroundColor == durationBackgroundColor &&
        other.backgroundColor == backgroundColor &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.shadowColor == shadowColor &&
        other.shadowElevation == shadowElevation &&
        other.showShadow == showShadow;
  }

  @override
  int get hashCode => Object.hash(
        overlayColor,
        playButtonColor,
        progressColor,
        progressBackgroundColor,
        loadingColor,
        errorColor,
        captionColor,
        captionBackgroundColor,
        durationTextColor,
        durationBackgroundColor,
        backgroundColor,
        borderColor,
        borderWidth,
        shadowColor,
        shadowElevation,
        showShadow,
      );
}

/// Video bubble theme configuration
class VideoBubbleTheme {
  /// Configuration for sent video messages
  final VideoBubbleConfig sender;

  /// Configuration for received video messages
  final VideoBubbleConfig receiver;

  /// Border radius for video container
  final double borderRadius;

  /// Container margin
  final EdgeInsetsGeometry containerMargin;

  /// Maximum width factor
  final double maxWidthFactor;

  /// Minimum width
  final double minWidth;

  /// Minimum height
  final double minHeight;

  /// Play button size
  final double playButtonSize;

  /// Progress bar height
  final double progressHeight;

  /// Caption font size
  final double captionFontSize;

  /// Duration font size
  final double durationFontSize;

  /// Elevation
  final double elevation;

  // Backwards compatibility getters
  Color? get overlayColor => sender.overlayColor ?? receiver.overlayColor;
  Color? get playButtonColor =>
      sender.playButtonColor ?? receiver.playButtonColor;
  Color? get progressColor => sender.progressColor ?? receiver.progressColor;
  Color? get progressBackgroundColor =>
      sender.progressBackgroundColor ?? receiver.progressBackgroundColor;
  Color? get loadingColor => sender.loadingColor ?? receiver.loadingColor;
  Color? get errorColor => sender.errorColor ?? receiver.errorColor;
  Color? get captionColor => sender.captionColor ?? receiver.captionColor;
  Color? get captionBackgroundColor =>
      sender.captionBackgroundColor ?? receiver.captionBackgroundColor;
  Color? get durationTextColor =>
      sender.durationTextColor ?? receiver.durationTextColor;
  Color? get durationBackgroundColor =>
      sender.durationBackgroundColor ?? receiver.durationBackgroundColor;

  const VideoBubbleTheme({
    required this.sender,
    required this.receiver,
    this.borderRadius = 12.0,
    this.containerMargin = const EdgeInsets.symmetric(vertical: 2.0),
    this.maxWidthFactor = 0.7,
    this.minWidth = 200.0,
    this.minHeight = 150.0,
    this.playButtonSize = 50.0,
    this.progressHeight = 4.0,
    this.captionFontSize = 14.0,
    this.durationFontSize = 12.0,
    this.elevation = 1.0,
  });

  /// Light theme for video bubble
  const VideoBubbleTheme.light()
      : this(
          sender: const VideoBubbleConfig(
            overlayColor: Color(0x80000000),
            playButtonColor: Color(0xFFFFFFFF),
            progressColor: Color(0xFF974EE9),
            progressBackgroundColor: Color(0x80FFFFFF),
            loadingColor: Color(0xFF974EE9),
            errorColor: Color(0xFFFF5722),
            captionColor: Color(0xFFFFFFFF),
            captionBackgroundColor: Color(0x80000000),
            durationTextColor: Color(0xFFFFFFFF),
            durationBackgroundColor: Color(0x80000000),
            backgroundColor: Color(0xFFF8F8F8),
            shadowColor: Color(0x1A000000),
            shadowElevation: 2.0,
            showShadow: true,
          ),
          receiver: const VideoBubbleConfig(
            overlayColor: Color(0x80000000),
            playButtonColor: Color(0xFFFFFFFF),
            progressColor: Color(0xFF974EE9),
            progressBackgroundColor: Color(0x80FFFFFF),
            loadingColor: Color(0xFF974EE9),
            errorColor: Color(0xFFFF5722),
            captionColor: Color(0xFFFFFFFF),
            captionBackgroundColor: Color(0x80000000),
            durationTextColor: Color(0xFFFFFFFF),
            durationBackgroundColor: Color(0x80000000),
            backgroundColor: Color(0xFFFFFFFF),
            shadowColor: Color(0x1A000000),
            shadowElevation: 1.0,
            showShadow: true,
          ),
        );

  /// Dark theme for video bubble
  const VideoBubbleTheme.dark()
      : this(
          sender: const VideoBubbleConfig(
            overlayColor: Color(0x80000000),
            playButtonColor: Color(0xFFFFFFFF),
            progressColor: Color(0xFF974EE9),
            progressBackgroundColor: Color(0x80FFFFFF),
            loadingColor: Color(0xFF974EE9),
            errorColor: Color(0xFFFF5722),
            captionColor: Color(0xFFFFFFFF),
            captionBackgroundColor: Color(0x80000000),
            durationTextColor: Color(0xFFFFFFFF),
            durationBackgroundColor: Color(0x80000000),
            backgroundColor: Color(0xFF1C1C1E),
            shadowColor: Color(0x40000000),
            shadowElevation: 2.0,
            showShadow: true,
          ),
          receiver: const VideoBubbleConfig(
            overlayColor: Color(0x80000000),
            playButtonColor: Color(0xFFFFFFFF),
            progressColor: Color(0xFF974EE9),
            progressBackgroundColor: Color(0x80FFFFFF),
            loadingColor: Color(0xFF974EE9),
            errorColor: Color(0xFFFF5722),
            captionColor: Color(0xFFFFFFFF),
            captionBackgroundColor: Color(0x80000000),
            durationTextColor: Color(0xFFFFFFFF),
            durationBackgroundColor: Color(0x80000000),
            backgroundColor: Color(0xFF2C2C2E),
            shadowColor: Color(0x40000000),
            shadowElevation: 2.0,
            showShadow: true,
          ),
        );

  VideoBubbleTheme copyWith({
    VideoBubbleConfig? sender,
    VideoBubbleConfig? receiver,
    double? borderRadius,
    EdgeInsetsGeometry? containerMargin,
    double? maxWidthFactor,
    double? minWidth,
    double? minHeight,
    double? playButtonSize,
    double? progressHeight,
    double? captionFontSize,
    double? durationFontSize,
    double? elevation,
  }) {
    return VideoBubbleTheme(
      sender: sender ?? this.sender,
      receiver: receiver ?? this.receiver,
      borderRadius: borderRadius ?? this.borderRadius,
      containerMargin: containerMargin ?? this.containerMargin,
      maxWidthFactor: maxWidthFactor ?? this.maxWidthFactor,
      minWidth: minWidth ?? this.minWidth,
      minHeight: minHeight ?? this.minHeight,
      playButtonSize: playButtonSize ?? this.playButtonSize,
      progressHeight: progressHeight ?? this.progressHeight,
      captionFontSize: captionFontSize ?? this.captionFontSize,
      durationFontSize: durationFontSize ?? this.durationFontSize,
      elevation: elevation ?? this.elevation,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VideoBubbleTheme &&
        other.sender == sender &&
        other.receiver == receiver &&
        other.borderRadius == borderRadius &&
        other.maxWidthFactor == maxWidthFactor;
  }

  @override
  int get hashCode =>
      Object.hash(sender, receiver, borderRadius, maxWidthFactor);

  double? get maxHeight => null;

  double? get maxWidth => null;

  Color? get playButtonBackgroundColor => null;

  double? get playIconSize => null;

  Color? get playButtonIconColor => null;
}

/// Document bubble configuration for either sender or receiver
class DocumentBubbleConfig {
  /// Background color
  final Color? backgroundColor;

  /// Border color
  final Color? borderColor;

  /// Icon color
  final Color? iconColor;

  /// File name text color
  final Color? fileNameColor;

  /// File size text color
  final Color? fileSizeColor;

  /// Download progress color
  final Color? progressColor;

  /// Download progress background color
  final Color? progressBackgroundColor;

  /// Error color
  final Color? errorColor;

  /// Shadow color
  final Color? shadowColor;

  /// Shadow elevation
  final double shadowElevation;

  /// Whether to show shadow
  final bool showShadow;

  /// Border width
  final double borderWidth;

  const DocumentBubbleConfig({
    this.backgroundColor,
    this.borderColor,
    this.iconColor,
    this.fileNameColor,
    this.fileSizeColor,
    this.progressColor,
    this.progressBackgroundColor,
    this.errorColor,
    this.shadowColor,
    this.shadowElevation = 1.0,
    this.showShadow = true,
    this.borderWidth = 0.0,
  });

  DocumentBubbleConfig copyWith({
    Color? backgroundColor,
    Color? borderColor,
    Color? iconColor,
    Color? fileNameColor,
    Color? fileSizeColor,
    Color? progressColor,
    Color? progressBackgroundColor,
    Color? errorColor,
    Color? shadowColor,
    double? shadowElevation,
    bool? showShadow,
    double? borderWidth,
  }) {
    return DocumentBubbleConfig(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      iconColor: iconColor ?? this.iconColor,
      fileNameColor: fileNameColor ?? this.fileNameColor,
      fileSizeColor: fileSizeColor ?? this.fileSizeColor,
      progressColor: progressColor ?? this.progressColor,
      progressBackgroundColor:
          progressBackgroundColor ?? this.progressBackgroundColor,
      errorColor: errorColor ?? this.errorColor,
      shadowColor: shadowColor ?? this.shadowColor,
      shadowElevation: shadowElevation ?? this.shadowElevation,
      showShadow: showShadow ?? this.showShadow,
      borderWidth: borderWidth ?? this.borderWidth,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DocumentBubbleConfig &&
        other.backgroundColor == backgroundColor &&
        other.borderColor == borderColor &&
        other.iconColor == iconColor &&
        other.fileNameColor == fileNameColor &&
        other.fileSizeColor == fileSizeColor &&
        other.progressColor == progressColor &&
        other.progressBackgroundColor == progressBackgroundColor &&
        other.errorColor == errorColor &&
        other.shadowColor == shadowColor &&
        other.shadowElevation == shadowElevation &&
        other.showShadow == showShadow &&
        other.borderWidth == borderWidth;
  }

  @override
  int get hashCode => Object.hash(
        backgroundColor,
        borderColor,
        iconColor,
        fileNameColor,
        fileSizeColor,
        progressColor,
        progressBackgroundColor,
        errorColor,
        shadowColor,
        shadowElevation,
        showShadow,
        borderWidth,
      );
}

/// Document bubble theme configuration
class DocumentBubbleTheme {
  /// Configuration for sent document messages
  final DocumentBubbleConfig sender;

  /// Configuration for received document messages
  final DocumentBubbleConfig receiver;

  /// Border radius for document container
  final double borderRadius;

  /// Container padding
  final EdgeInsetsGeometry containerPadding;

  /// Container margin
  final EdgeInsetsGeometry containerMargin;

  /// Icon size
  final double iconSize;

  /// File name font size
  final double fileNameFontSize;

  /// File size font size
  final double fileSizeFontSize;

  /// Progress bar height
  final double progressHeight;

  /// Container width
  final double containerWidth;

  /// Elevation
  final double elevation;

  // Backwards compatibility getters
  Color? get backgroundColor =>
      sender.backgroundColor ?? receiver.backgroundColor;
  Color? get borderColor => sender.borderColor ?? receiver.borderColor;
  Color? get iconColor => sender.iconColor ?? receiver.iconColor;
  Color? get fileNameColor => sender.fileNameColor ?? receiver.fileNameColor;
  Color? get fileSizeColor => sender.fileSizeColor ?? receiver.fileSizeColor;
  Color? get progressColor => sender.progressColor ?? receiver.progressColor;
  Color? get progressBackgroundColor =>
      sender.progressBackgroundColor ?? receiver.progressBackgroundColor;
  Color? get errorColor => sender.errorColor ?? receiver.errorColor;

  const DocumentBubbleTheme({
    required this.sender,
    required this.receiver,
    this.borderRadius = 12.0,
    this.containerPadding = const EdgeInsets.symmetric(
      horizontal: 4.0,
      vertical: 2.0,
    ),
    this.containerMargin = const EdgeInsets.symmetric(vertical: 2.0),
    this.iconSize = 40.0,
    this.fileNameFontSize = 14.0,
    this.fileSizeFontSize = 12.0,
    this.progressHeight = 4.0,
    this.containerWidth = 280.0,
    this.elevation = 1.0,
  });

  /// Light theme for document bubble
  const DocumentBubbleTheme.light()
      : this(
          sender: const DocumentBubbleConfig(
            backgroundColor: Color(0x7DFFFFFF),
            borderColor: Color(0xFFE0E0E0),
            iconColor: Color(0xFF974EE9),
            fileNameColor: Color(0xFF121212),
            fileSizeColor: Color(0xFF757575),
            progressColor: Color(0xFF974EE9),
            progressBackgroundColor: Color(0xFFE0E0E0),
            errorColor: Color(0xFFFF5722),
            shadowColor: Color(0x1A000000),
            shadowElevation: 1.0,
            showShadow: true,
          ),
          receiver: const DocumentBubbleConfig(
            backgroundColor: Color(0x7DFFFFFF),
            borderColor: Color(0xFFE0E0E0),
            iconColor: Color(0xFF974EE9),
            fileNameColor: Color(0xFF121212),
            fileSizeColor: Color(0xFF757575),
            progressColor: Color(0xFF974EE9),
            progressBackgroundColor: Color(0xFFE0E0E0),
            errorColor: Color(0xFFFF5722),
            shadowColor: Color(0x1A000000),
            shadowElevation: 1.0,
            showShadow: true,
          ),
        );

  /// Dark theme for document bubble
  const DocumentBubbleTheme.dark()
      : this(
          sender: const DocumentBubbleConfig(
            backgroundColor: Color(0x24FFFFFF),
            borderColor: Color(0xFF444444),
            iconColor: Color(0xFF974EE9),
            fileNameColor: Color(0xFFFFFFFF),
            fileSizeColor: Color(0xFFB0B0B0),
            progressColor: Color(0xFF974EE9),
            progressBackgroundColor: Color(0xFF444444),
            errorColor: Color(0xFFFF5722),
            shadowColor: Color(0x40000000),
            shadowElevation: 2.0,
            showShadow: true,
          ),
          receiver: const DocumentBubbleConfig(
            backgroundColor: Color(0x24FFFFFF),
            borderColor: Color(0xFF444444),
            iconColor: Color(0xFF974EE9),
            fileNameColor: Color(0xFFFFFFFF),
            fileSizeColor: Color(0xFFB0B0B0),
            progressColor: Color(0xFF974EE9),
            progressBackgroundColor: Color(0xFF444444),
            errorColor: Color(0xFFFF5722),
            shadowColor: Color(0x40000000),
            shadowElevation: 2.0,
            showShadow: true,
          ),
        );

  DocumentBubbleTheme copyWith({
    DocumentBubbleConfig? sender,
    DocumentBubbleConfig? receiver,
    double? borderRadius,
    EdgeInsetsGeometry? containerPadding,
    EdgeInsetsGeometry? containerMargin,
    double? iconSize,
    double? fileNameFontSize,
    double? fileSizeFontSize,
    double? progressHeight,
    double? containerWidth,
    double? elevation,
  }) {
    return DocumentBubbleTheme(
      sender: sender ?? this.sender,
      receiver: receiver ?? this.receiver,
      borderRadius: borderRadius ?? this.borderRadius,
      containerPadding: containerPadding ?? this.containerPadding,
      containerMargin: containerMargin ?? this.containerMargin,
      iconSize: iconSize ?? this.iconSize,
      fileNameFontSize: fileNameFontSize ?? this.fileNameFontSize,
      fileSizeFontSize: fileSizeFontSize ?? this.fileSizeFontSize,
      progressHeight: progressHeight ?? this.progressHeight,
      containerWidth: containerWidth ?? this.containerWidth,
      elevation: elevation ?? this.elevation,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DocumentBubbleTheme &&
        other.sender == sender &&
        other.receiver == receiver &&
        other.borderRadius == borderRadius;
  }

  @override
  int get hashCode => Object.hash(sender, receiver, borderRadius);

  double? get padding => null;

  Color? get senderBackgroundColor => null;

  Color? get receiverBackgroundColor => null;

  double? get iconContainerSize => null;

  Color? get iconBackgroundColor => null;
}

/// Image bubble configuration for either sender or receiver
class ImageBubbleConfig {
  /// Placeholder color
  final Color? placeholderColor;

  /// Loading indicator color
  final Color? loadingColor;

  /// Error icon color
  final Color? errorColor;

  /// Overlay color for multiple images
  final Color? overlayColor;

  /// Caption text color
  final Color? captionColor;

  /// Caption background color
  final Color? captionBackgroundColor;

  /// Background color for image container
  final Color? backgroundColor;

  /// Border color
  final Color? borderColor;

  /// Border width
  final double borderWidth;

  /// Shadow color
  final Color? shadowColor;

  /// Shadow elevation
  final double shadowElevation;

  /// Whether to show shadow
  final bool showShadow;

  const ImageBubbleConfig({
    this.placeholderColor,
    this.loadingColor,
    this.errorColor,
    this.overlayColor,
    this.captionColor,
    this.captionBackgroundColor,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 0.0,
    this.shadowColor,
    this.shadowElevation = 1.0,
    this.showShadow = true,
  });

  ImageBubbleConfig copyWith({
    Color? placeholderColor,
    Color? loadingColor,
    Color? errorColor,
    Color? overlayColor,
    Color? captionColor,
    Color? captionBackgroundColor,
    Color? backgroundColor,
    Color? borderColor,
    double? borderWidth,
    Color? shadowColor,
    double? shadowElevation,
    bool? showShadow,
  }) {
    return ImageBubbleConfig(
      placeholderColor: placeholderColor ?? this.placeholderColor,
      loadingColor: loadingColor ?? this.loadingColor,
      errorColor: errorColor ?? this.errorColor,
      overlayColor: overlayColor ?? this.overlayColor,
      captionColor: captionColor ?? this.captionColor,
      captionBackgroundColor:
          captionBackgroundColor ?? this.captionBackgroundColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      shadowColor: shadowColor ?? this.shadowColor,
      shadowElevation: shadowElevation ?? this.shadowElevation,
      showShadow: showShadow ?? this.showShadow,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ImageBubbleConfig &&
        other.placeholderColor == placeholderColor &&
        other.loadingColor == loadingColor &&
        other.errorColor == errorColor &&
        other.overlayColor == overlayColor &&
        other.captionColor == captionColor &&
        other.captionBackgroundColor == captionBackgroundColor &&
        other.backgroundColor == backgroundColor &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.shadowColor == shadowColor &&
        other.shadowElevation == shadowElevation &&
        other.showShadow == showShadow;
  }

  @override
  int get hashCode => Object.hash(
        placeholderColor,
        loadingColor,
        errorColor,
        overlayColor,
        captionColor,
        captionBackgroundColor,
        backgroundColor,
        borderColor,
        borderWidth,
        shadowColor,
        shadowElevation,
        showShadow,
      );
}

/// Image bubble theme configuration
class ImageBubbleTheme {
  /// Configuration for sent images
  final ImageBubbleConfig sender;

  /// Configuration for received images
  final ImageBubbleConfig receiver;

  /// Border radius for image container
  final double borderRadius;

  /// Container margin
  final EdgeInsetsGeometry containerMargin;

  /// Maximum width factor
  final double maxWidthFactor;

  /// Minimum width
  final double minWidth;

  /// Minimum height
  final double minHeight;

  /// Caption font size
  final double captionFontSize;

  /// Elevation for image container
  final double elevation;

  // Backwards compatibility getters
  Color? get placeholderColor =>
      sender.placeholderColor ?? receiver.placeholderColor;
  Color? get loadingColor => sender.loadingColor ?? receiver.loadingColor;
  Color? get errorColor => sender.errorColor ?? receiver.errorColor;
  Color? get overlayColor => sender.overlayColor ?? receiver.overlayColor;
  Color? get captionColor => sender.captionColor ?? receiver.captionColor;
  Color? get captionBackgroundColor =>
      sender.captionBackgroundColor ?? receiver.captionBackgroundColor;

  const ImageBubbleTheme({
    required this.sender,
    required this.receiver,
    this.borderRadius = 12.0,
    this.containerMargin = const EdgeInsets.symmetric(vertical: 2.0),
    this.maxWidthFactor = 0.7,
    this.minWidth = 150.0,
    this.minHeight = 150.0,
    this.captionFontSize = 14.0,
    this.elevation = 1.0,
  });

  /// Light theme for image bubble
  const ImageBubbleTheme.light()
      : this(
          sender: const ImageBubbleConfig(
            placeholderColor: Color(0xFFF5F5F5),
            loadingColor: Color(0xFF974EE9),
            errorColor: Color(0xFFFF5722),
            overlayColor: Color(0x80000000),
            captionColor: Color(0xFFFFFFFF),
            captionBackgroundColor: Color(0x80000000),
            backgroundColor: Color(0xFFF8F8F8),
            shadowColor: Color(0x1A000000),
            shadowElevation: 1.0,
            showShadow: true,
          ),
          receiver: const ImageBubbleConfig(
            placeholderColor: Color(0xFFF5F5F5),
            loadingColor: Color(0xFF974EE9),
            errorColor: Color(0xFFFF5722),
            overlayColor: Color(0x80000000),
            captionColor: Color(0xFFFFFFFF),
            captionBackgroundColor: Color(0x80000000),
            backgroundColor: Color(0xFFFFFFFF),
            shadowColor: Color(0x1A000000),
            shadowElevation: 1.0,
            showShadow: true,
          ),
        );

  /// Dark theme for image bubble
  const ImageBubbleTheme.dark()
      : this(
          sender: const ImageBubbleConfig(
            placeholderColor: Color(0xFF2C2C2E),
            loadingColor: Color(0xFF974EE9),
            errorColor: Color(0xFFFF5722),
            overlayColor: Color(0x80000000),
            captionColor: Color(0xFFFFFFFF),
            captionBackgroundColor: Color(0x80000000),
            backgroundColor: Color(0xFF1C1C1E),
            shadowColor: Color(0x40000000),
            shadowElevation: 2.0,
            showShadow: true,
          ),
          receiver: const ImageBubbleConfig(
            placeholderColor: Color(0xFF2C2C2E),
            loadingColor: Color(0xFF974EE9),
            errorColor: Color(0xFFFF5722),
            overlayColor: Color(0x80000000),
            captionColor: Color(0xFFFFFFFF),
            captionBackgroundColor: Color(0x80000000),
            backgroundColor: Color(0xFF2C2C2E),
            shadowColor: Color(0x40000000),
            shadowElevation: 2.0,
            showShadow: true,
          ),
        );

  ImageBubbleTheme copyWith({
    ImageBubbleConfig? sender,
    ImageBubbleConfig? receiver,
    double? borderRadius,
    EdgeInsetsGeometry? containerMargin,
    double? maxWidthFactor,
    double? minWidth,
    double? minHeight,
    double? captionFontSize,
    double? elevation,
  }) {
    return ImageBubbleTheme(
      sender: sender ?? this.sender,
      receiver: receiver ?? this.receiver,
      borderRadius: borderRadius ?? this.borderRadius,
      containerMargin: containerMargin ?? this.containerMargin,
      maxWidthFactor: maxWidthFactor ?? this.maxWidthFactor,
      minWidth: minWidth ?? this.minWidth,
      minHeight: minHeight ?? this.minHeight,
      captionFontSize: captionFontSize ?? this.captionFontSize,
      elevation: elevation ?? this.elevation,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ImageBubbleTheme &&
        other.sender == sender &&
        other.receiver == receiver &&
        other.borderRadius == borderRadius &&
        other.maxWidthFactor == maxWidthFactor;
  }

  @override
  int get hashCode =>
      Object.hash(sender, receiver, borderRadius, maxWidthFactor);

  double? get maxWidth => null;

  double? get maxHeight => null;
}

/// Audio bubble configuration for either sender or receiver
class AudioBubbleConfig {
  /// Background color
  final Color? backgroundColor;

  /// Play button color
  final Color? playButtonColor;

  /// Progress bar color
  final Color? progressColor;

  /// Progress background color
  final Color? progressBackgroundColor;

  /// Waveform color
  final Color? waveformColor;

  /// Waveform active color
  final Color? waveformActiveColor;

  /// Text color for duration
  final Color? textColor;

  /// Border color
  final Color? borderColor;

  /// Border width
  final double borderWidth;

  /// Shadow color
  final Color? shadowColor;

  /// Shadow elevation
  final double shadowElevation;

  /// Whether to show shadow
  final bool showShadow;

  const AudioBubbleConfig({
    this.backgroundColor,
    this.playButtonColor,
    this.progressColor,
    this.progressBackgroundColor,
    this.waveformColor,
    this.waveformActiveColor,
    this.textColor,
    this.borderColor,
    this.borderWidth = 0.0,
    this.shadowColor,
    this.shadowElevation = 1.0,
    this.showShadow = true,
  });

  AudioBubbleConfig copyWith({
    Color? backgroundColor,
    Color? playButtonColor,
    Color? progressColor,
    Color? progressBackgroundColor,
    Color? waveformColor,
    Color? waveformActiveColor,
    Color? textColor,
    Color? borderColor,
    double? borderWidth,
    Color? shadowColor,
    double? shadowElevation,
    bool? showShadow,
  }) {
    return AudioBubbleConfig(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      playButtonColor: playButtonColor ?? this.playButtonColor,
      progressColor: progressColor ?? this.progressColor,
      progressBackgroundColor:
          progressBackgroundColor ?? this.progressBackgroundColor,
      waveformColor: waveformColor ?? this.waveformColor,
      waveformActiveColor: waveformActiveColor ?? this.waveformActiveColor,
      textColor: textColor ?? this.textColor,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      shadowColor: shadowColor ?? this.shadowColor,
      shadowElevation: shadowElevation ?? this.shadowElevation,
      showShadow: showShadow ?? this.showShadow,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AudioBubbleConfig &&
        other.backgroundColor == backgroundColor &&
        other.playButtonColor == playButtonColor &&
        other.progressColor == progressColor &&
        other.progressBackgroundColor == progressBackgroundColor &&
        other.waveformColor == waveformColor &&
        other.waveformActiveColor == waveformActiveColor &&
        other.textColor == textColor &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.shadowColor == shadowColor &&
        other.shadowElevation == shadowElevation &&
        other.showShadow == showShadow;
  }

  @override
  int get hashCode => Object.hash(
        backgroundColor,
        playButtonColor,
        progressColor,
        progressBackgroundColor,
        waveformColor,
        waveformActiveColor,
        textColor,
        borderColor,
        borderWidth,
        shadowColor,
        shadowElevation,
        showShadow,
      );
}

/// Audio bubble theme configuration
class AudioBubbleTheme {
  /// Configuration for sent audio messages
  final AudioBubbleConfig sender;

  /// Configuration for received audio messages
  final AudioBubbleConfig receiver;

  /// Border radius for audio container
  final double borderRadius;

  /// Container padding
  final EdgeInsetsGeometry containerPadding;

  /// Container margin
  final EdgeInsetsGeometry containerMargin;

  /// Play button size
  final double playButtonSize;

  /// Progress bar height
  final double progressHeight;

  /// Waveform height
  final double waveformHeight;

  /// Duration font size
  final double durationFontSize;

  /// Container width
  final double containerWidth;

  /// Elevation
  final double elevation;

  // Backwards compatibility getters
  Color? get backgroundColor =>
      sender.backgroundColor ?? receiver.backgroundColor;
  Color? get playButtonColor =>
      sender.playButtonColor ?? receiver.playButtonColor;
  Color? get progressColor => sender.progressColor ?? receiver.progressColor;
  Color? get progressBackgroundColor =>
      sender.progressBackgroundColor ?? receiver.progressBackgroundColor;
  Color? get waveformColor => sender.waveformColor ?? receiver.waveformColor;
  Color? get waveformActiveColor =>
      sender.waveformActiveColor ?? receiver.waveformActiveColor;
  Color? get textColor => sender.textColor ?? receiver.textColor;

  const AudioBubbleTheme({
    required this.sender,
    required this.receiver,
    this.borderRadius = 20.0,
    this.containerPadding = const EdgeInsets.all(12.0),
    this.containerMargin = const EdgeInsets.symmetric(vertical: 2.0),
    this.playButtonSize = 40.0,
    this.progressHeight = 4.0,
    this.waveformHeight = 30.0,
    this.durationFontSize = 12.0,
    this.containerWidth = 250.0,
    this.elevation = 1.0,
  });

  /// Light theme for audio bubble
  const AudioBubbleTheme.light()
      : this(
          sender: const AudioBubbleConfig(
            backgroundColor: Color(0xFFF5F5F5),
            playButtonColor: Color(0xFF974EE9),
            progressColor: Color(0xFF974EE9),
            progressBackgroundColor: Color(0xFFE0E0E0),
            waveformColor: Color(0xFFE0E0E0),
            waveformActiveColor: Color(0xFF974EE9),
            textColor: Color(0xFF121212),
            shadowColor: Color(0x1A000000),
            shadowElevation: 1.0,
            showShadow: true,
          ),
          receiver: const AudioBubbleConfig(
            backgroundColor: Color(0xFFFFFFFF),
            playButtonColor: Color(0xFF974EE9),
            progressColor: Color(0xFF974EE9),
            progressBackgroundColor: Color(0xFFE0E0E0),
            waveformColor: Color(0xFFE0E0E0),
            waveformActiveColor: Color(0xFF974EE9),
            textColor: Color(0xFF121212),
            shadowColor: Color(0x1A000000),
            shadowElevation: 1.0,
            showShadow: true,
          ),
        );

  /// Dark theme for audio bubble
  const AudioBubbleTheme.dark()
      : this(
          sender: const AudioBubbleConfig(
            backgroundColor: Color(0xFF1C1C1E),
            playButtonColor: Color(0xFF974EE9),
            progressColor: Color(0xFF974EE9),
            progressBackgroundColor: Color(0xFF444444),
            waveformColor: Color(0xFF444444),
            waveformActiveColor: Color(0xFF974EE9),
            textColor: Color(0xFFFFFFFF),
            shadowColor: Color(0x40000000),
            shadowElevation: 2.0,
            showShadow: true,
          ),
          receiver: const AudioBubbleConfig(
            backgroundColor: Color(0xFF2C2C2E),
            playButtonColor: Color(0xFF974EE9),
            progressColor: Color(0xFF974EE9),
            progressBackgroundColor: Color(0xFF444444),
            waveformColor: Color(0xFF444444),
            waveformActiveColor: Color(0xFF974EE9),
            textColor: Color(0xFFFFFFFF),
            shadowColor: Color(0x40000000),
            shadowElevation: 2.0,
            showShadow: true,
          ),
        );

  AudioBubbleTheme copyWith({
    AudioBubbleConfig? sender,
    AudioBubbleConfig? receiver,
    double? borderRadius,
    EdgeInsetsGeometry? containerPadding,
    EdgeInsetsGeometry? containerMargin,
    double? playButtonSize,
    double? progressHeight,
    double? waveformHeight,
    double? durationFontSize,
    double? containerWidth,
    double? elevation,
  }) {
    return AudioBubbleTheme(
      sender: sender ?? this.sender,
      receiver: receiver ?? this.receiver,
      borderRadius: borderRadius ?? this.borderRadius,
      containerPadding: containerPadding ?? this.containerPadding,
      containerMargin: containerMargin ?? this.containerMargin,
      playButtonSize: playButtonSize ?? this.playButtonSize,
      progressHeight: progressHeight ?? this.progressHeight,
      waveformHeight: waveformHeight ?? this.waveformHeight,
      durationFontSize: durationFontSize ?? this.durationFontSize,
      containerWidth: containerWidth ?? this.containerWidth,
      elevation: elevation ?? this.elevation,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AudioBubbleTheme &&
        other.sender == sender &&
        other.receiver == receiver &&
        other.borderRadius == borderRadius;
  }

  @override
  int get hashCode => Object.hash(sender, receiver, borderRadius);

  double? get padding => null;

  Color? get senderBackgroundColor => null;

  Color? get receiverBackgroundColor => null;

  double? get playIconSize => null;

  Color? get playIconColor => null;
}
