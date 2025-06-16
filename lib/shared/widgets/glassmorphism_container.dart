import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';

class GlassmorphismContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final double borderRadius;
  final double blurSigma;
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final List<BoxShadow>? boxShadow;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const GlassmorphismContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.borderRadius = AppConstants.defaultBorderRadius,
    this.blurSigma = 10.0,
    this.backgroundColor = const Color(0x33FFFFFF), // 20% white opacity
    this.borderColor = const Color(0x4DFFFFFF), // 30% white opacity
    this.borderWidth = 1.5,
    this.boxShadow,
    this.padding,
    this.margin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final container = Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor, width: borderWidth),
        boxShadow:
            boxShadow ??
            [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: onTap != null
                ? Material(
                    color: AppColors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(borderRadius),
                      onTap: onTap,
                      child: child,
                    ),
                  )
                : child,
          ),
        ),
      ),
    );

    return container;
  }
}

/// A specialized glassmorphism navigation button for modal dialogs
class GlassmorphismNavigationButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double size;

  const GlassmorphismNavigationButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 56.0,
  });

  @override
  Widget build(BuildContext context) {
    return GlassmorphismContainer(
      width: size,
      height: size,
      borderRadius: 15.0,
      onTap: onPressed,
      child: Icon(icon, color: AppColors.white, size: 28),
    );
  }
}

/// A glassmorphism background overlay for modal dialogs
class GlassmorphismBackground extends StatelessWidget {
  final Widget child;
  final double blurSigma;

  const GlassmorphismBackground({
    super.key,
    required this.child,
    this.blurSigma = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Glassmorphism background
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0x26FFFFFF), // 15% white opacity
                    Color(0x0DFFFFFF), // 5% white opacity
                    Color(0x0D000000), // 5% black opacity
                    Color(0x1A000000), // 10% black opacity
                  ],
                  stops: [0.0, 0.3, 0.7, 1.0],
                ),
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}
