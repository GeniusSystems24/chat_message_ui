import 'package:flutter/material.dart';
import 'package:link_preview_generator/link_preview_generator.dart';
import 'package:super_interactive_text/super_interactive_text.dart';
import 'package:url_launcher/url_launcher.dart';

/// Enum for preview location
enum PreviewLocation { input, bubble }

/// Widget for text data preview
class TextDataPreviewCard extends StatelessWidget {
  /// Location where preview will be displayed
  final PreviewLocation previewLocation;

  /// Text data for preview
  final SuperInteractiveTextData textData;

  /// Card width
  final double? width;

  /// Constraints for the card
  final BoxConstraints? constraints;

  /// Callback when a route is tapped
  final Function(String route)? onRouteTap;

  const TextDataPreviewCard({
    super.key,
    required this.textData,
    this.width,
    this.constraints,
    this.previewLocation = PreviewLocation.input,
    this.onRouteTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: width ?? double.infinity,
      child: _buildContent(context, theme),
    );
  }

  /// Build card content based on text type
  Widget _buildContent(BuildContext context, ThemeData theme) {
    if (textData is LinkTextData) {
      return _buildLinkContent(context, theme);
    }
    if (textData is EmailTextData) {
      return _buildEmailContent(context, theme);
    }
    if (textData is PhoneNumberTextData) {
      return _buildPhoneContent(context, theme);
    }
    if (textData is SocialMediaTextData) {
      return _buildSocialMediaContent(context, theme);
    }
    if (textData is RouteTextData) {
      return _buildRouteContent(context, theme);
    }
    return _buildDefaultContent(context, theme);
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri? url = Uri.tryParse(urlString);
    if (url != null && await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  /// Build link content
  Widget _buildLinkContent(BuildContext context, ThemeData theme) {
    return LinkPreviewGenerator(
      link: textData.text,
      boxShadow: [],
      bodyStyle: theme.textTheme.bodyMedium,
      titleStyle: theme.textTheme.titleMedium,
      linkPreviewStyle: previewLocation == PreviewLocation.input
          ? LinkPreviewStyle.small
          : LinkPreviewStyle.large,
      bodyTextOverflow: TextOverflow.ellipsis,
      errorBody: "",
      errorTitle: "",
      showGraphic: true,
      showBody: true,
      showTitle: true,
      showDomain: true,
      backgroundColor: theme.colorScheme.surface,
      bodyMaxLines: 3,
      borderRadius: 12,
      removeElevation: false,
      onTap: previewLocation == PreviewLocation.input
          ? null
          : () => _launchUrl(textData.text),
      placeholderWidget: _buildLinkPlaceholder(theme),
      errorWidget: _buildLinkErrorWidget(theme),
    );
  }

  /// Build email content
  Widget _buildEmailContent(BuildContext context, ThemeData theme) {
    final emailLink = 'mailto:${textData.text}';

    return LinkPreviewGenerator(
      link: emailLink,
      boxShadow: [],
      bodyStyle: theme.textTheme.bodyMedium,
      titleStyle: theme.textTheme.titleMedium,
      linkPreviewStyle: previewLocation == PreviewLocation.input
          ? LinkPreviewStyle.small
          : LinkPreviewStyle.large,
      bodyTextOverflow: TextOverflow.ellipsis,
      errorBody: "",
      errorTitle: "",
      showGraphic: false,
      showBody: true,
      showTitle: true,
      showDomain: false,
      backgroundColor: theme.colorScheme.surface,
      bodyMaxLines: 2,
      borderRadius: 12,
      removeElevation: false,
      onTap: previewLocation == PreviewLocation.input
          ? null
          : () => _launchUrl(emailLink),
      placeholderWidget: _buildEmailPlaceholder(theme),
      errorWidget: _buildEmailErrorWidget(theme),
    );
  }

  /// Build phone content
  Widget _buildPhoneContent(BuildContext context, ThemeData theme) {
    return InkWell(
      onTap: previewLocation == PreviewLocation.input
          ? null
          : () => _launchUrl('tel:${textData.text}'),
      child: Row(
        children: [
          Icon(Icons.phone, size: 20, color: theme.colorScheme.tertiary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              textData.text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.tertiary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// Build social media content
  Widget _buildSocialMediaContent(BuildContext context, ThemeData theme) {
    final socialMedia = textData as SocialMediaTextData;

    return LinkPreviewGenerator(
      link: socialMedia.url,
      boxShadow: [],
      bodyStyle: theme.textTheme.bodyMedium,
      titleStyle: theme.textTheme.titleMedium,
      linkPreviewStyle: previewLocation == PreviewLocation.input
          ? LinkPreviewStyle.small
          : LinkPreviewStyle.large,
      bodyTextOverflow: TextOverflow.ellipsis,
      errorBody: "",
      errorTitle: "",
      showGraphic: true,
      showBody: true,
      showTitle: true,
      showDomain: true,
      backgroundColor: theme.colorScheme.surface,
      bodyMaxLines: 3,
      borderRadius: 12,
      removeElevation: false,
      onTap: previewLocation == PreviewLocation.input
          ? null
          : () => _launchUrl(socialMedia.url),
      placeholderWidget: _buildSocialMediaPlaceholder(socialMedia, theme),
      errorWidget: _buildSocialMediaErrorWidget(socialMedia, theme),
    );
  }

  /// Build route content
  Widget _buildRouteContent(BuildContext context, ThemeData theme) {
    final route = textData as RouteTextData;

    // We removed project-specific widgets (ClubFutureBuilder etc)
    // and rely on a simple callback or default view.

    return InkWell(
      onTap: previewLocation == PreviewLocation.input
          ? null
          : () => onRouteTap?.call(route.text),
      child: Container(
        constraints: constraints,
        child: _buildDefaultRouteView(theme, route),
      ),
    );
  }

  /// Build default content
  Widget _buildDefaultContent(BuildContext context, ThemeData theme) {
    return Text(
      textData.text,
      style: theme.textTheme.bodyMedium,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  // Helper methods for building widgets (same as before)
  Widget _buildLinkPlaceholder(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Loading preview...',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkErrorWidget(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.link, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              textData.text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                decoration: TextDecoration.underline,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailPlaceholder(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.secondary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Loading email preview...',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailErrorWidget(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.email, size: 20, color: theme.colorScheme.secondary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              textData.text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.secondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialMediaPlaceholder(
    SocialMediaTextData socialMedia,
    ThemeData theme,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _getSocialMediaLogo(socialMedia.type, theme),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Loading ${_getSocialMediaName(socialMedia.type)}...',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialMediaErrorWidget(
    SocialMediaTextData socialMedia,
    ThemeData theme,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _getSocialMediaLogo(socialMedia.type, theme),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getSocialMediaName(socialMedia.type),
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      socialMedia.url,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultRouteView(ThemeData theme, RouteTextData route) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.navigation,
              size: 20,
              color: theme.colorScheme.onSurface,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Open route',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    route.text,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Get social media logo
  Widget _getSocialMediaLogo(SocialMediaType type, ThemeData theme) {
    Color backgroundColor;
    Color iconColor;
    IconData iconData;

    switch (type) {
      case SocialMediaType.instagram:
        backgroundColor = const Color(0xFFE4405F);
        iconColor = Colors.white;
        iconData = Icons.camera_alt;
        break;
      case SocialMediaType.twitter:
        backgroundColor = const Color(0xFF1DA1F2);
        iconColor = Colors.white;
        iconData = Icons.flutter_dash;
        break;
      case SocialMediaType.facebook:
        backgroundColor = const Color(0xFF1877F2);
        iconColor = Colors.white;
        iconData = Icons.facebook;
        break;
      case SocialMediaType.youtube:
        backgroundColor = const Color(0xFFFF0000);
        iconColor = Colors.white;
        iconData = Icons.play_circle;
        break;
      case SocialMediaType.linkedin:
        backgroundColor = const Color(0xFF0077B5);
        iconColor = Colors.white;
        iconData = Icons.work;
        break;
      case SocialMediaType.whatsapp:
        backgroundColor = const Color(0xFF25D366);
        iconColor = Colors.white;
        iconData = Icons.chat;
        break;
      case SocialMediaType.telegram:
        backgroundColor = const Color(0xFF0088CC);
        iconColor = Colors.white;
        iconData = Icons.send;
        break;
      default:
        backgroundColor = theme.colorScheme.surfaceContainerHighest;
        iconColor = theme.colorScheme.onSurface;
        iconData = Icons.share;
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(iconData, size: 20, color: iconColor),
    );
  }

  /// Get social media platform name
  String _getSocialMediaName(SocialMediaType type) {
    switch (type) {
      case SocialMediaType.instagram:
        return 'Instagram';
      case SocialMediaType.twitter:
        return 'Twitter / X';
      case SocialMediaType.facebook:
        return 'Facebook';
      case SocialMediaType.youtube:
        return 'YouTube';
      case SocialMediaType.linkedin:
        return 'LinkedIn';
      case SocialMediaType.whatsapp:
        return 'WhatsApp';
      case SocialMediaType.telegram:
        return 'Telegram';
      default:
        return 'Social media';
    }
  }
}
