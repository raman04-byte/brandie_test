import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import 'glassmorphism_container.dart';

/// A base modal dialog widget that provides consistent styling and behavior
/// for all modal dialogs in the application
class BaseModal extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? maxHeight;
  final bool showCloseButton;
  final VoidCallback? onClose;

  const BaseModal({
    super.key,
    required this.child,
    this.width,
    this.maxHeight,
    this.showCloseButton = true,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final dialogWidth = width ?? (screenSize.width > 1200 ? 550 : 420);

    return Material(
      color: Colors.transparent,
      child: GlassmorphismBackground(
        child: Center(
          child: GlassmorphismContainer(
            width: dialogWidth,
            borderRadius: 24.0,
            backgroundColor: const Color(0xE6FFFFFF), // 90% white opacity
            borderColor: const Color(0x33FFFFFF), // 20% white opacity
            blurSigma: 5.0,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.8),
                blurRadius: 0,
                offset: const Offset(0, 0),
              ),
            ],
            child: Container(
              constraints: BoxConstraints(
                maxHeight: maxHeight ?? screenSize.height * 0.9,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showCloseButton) _buildCloseButton(context),
                  Flexible(child: child),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: onClose ?? () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close, color: AppColors.grey),
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
        ),
      ],
    );
  }
}

/// A modal dialog with navigation buttons for browsing through items
class NavigableModal extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? maxHeight;
  final bool showCloseButton;
  final VoidCallback? onClose;
  final VoidCallback? onNavigateLeft;
  final VoidCallback? onNavigateRight;
  final bool canNavigateLeft;
  final bool canNavigateRight;

  const NavigableModal({
    super.key,
    required this.child,
    this.width,
    this.maxHeight,
    this.showCloseButton = true,
    this.onClose,
    this.onNavigateLeft,
    this.onNavigateRight,
    this.canNavigateLeft = true,
    this.canNavigateRight = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GlassmorphismBackground(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left navigation button
              if (onNavigateLeft != null)
                GlassmorphismNavigationButton(
                  icon: Icons.chevron_left,
                  onPressed: canNavigateLeft ? onNavigateLeft! : () {},
                ),
              const SizedBox(width: 40),
              // Main dialog
              BaseModal(
                width: width,
                maxHeight: maxHeight,
                showCloseButton: showCloseButton,
                onClose: onClose,
                child: child,
              ),
              const SizedBox(width: 40),
              // Right navigation button
              if (onNavigateRight != null)
                GlassmorphismNavigationButton(
                  icon: Icons.chevron_right,
                  onPressed: canNavigateRight ? onNavigateRight! : () {},
                ),
            ],
          ),
        ),
      ),
    );
  }
}
