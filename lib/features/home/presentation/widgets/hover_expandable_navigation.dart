import 'package:flutter/material.dart';
import 'package:flutter_auto_size_text/flutter_auto_size_text.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import 'common_image_logo.dart';

class NavItemData {
  final IconData icon;
  final String label;

  const NavItemData({required this.icon, required this.label});
}

class HoverExpandableNavigation extends StatefulWidget {
  final Function(int)? onItemSelected;
  final int selectedIndex;
  final List<NavItemData>? navItems;

  const HoverExpandableNavigation({
    super.key,
    this.onItemSelected,
    this.selectedIndex = 0,
    this.navItems,
  });

  @override
  State<HoverExpandableNavigation> createState() =>
      _HoverExpandableNavigationState();
}

class _HoverExpandableNavigationState extends State<HoverExpandableNavigation> {
  bool _isHovered = false;

  final double collapsedWidth = 90;
  final double expandedWidth = 240;

  void _onEnter(PointerEvent event) {
    setState(() => _isHovered = true);
  }

  void _onExit(PointerEvent event) {
    setState(() => _isHovered = false);
  }

  @override
  Widget build(BuildContext context) {
    final navItems = widget.navItems;

    return MouseRegion(
      onEnter: _onEnter,
      onExit: _onExit,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        width: _isHovered ? expandedWidth : collapsedWidth,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(2, 0),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            spacing: 32,
            children: [
              const CommonImageLogo(),
              ...navItems!.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return _NavItem(
                  icon: item.icon,
                  label: item.label,
                  showLabel: _isHovered,
                  isSelected: widget.selectedIndex == index,
                  onTap: () => widget.onItemSelected?.call(index),
                );
              }),
              _NavItem(
                icon: HugeIcons.strokeRoundedLogout02,
                label: 'Sign Out',
                showLabel: _isHovered,
                isSelected: widget.selectedIndex == navItems.length,
                onTap: () => widget.onItemSelected?.call(navItems.length),
                commonColor: AppColors.red,
                iconColor: AppColors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool showLabel;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? commonColor;
  final Color? iconColor;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.showLabel,
    required this.isSelected,
    required this.onTap,
    this.commonColor = AppColors.text400,
    this.iconColor = AppColors.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      hoverColor: AppColors.primary,
      child: Container(
        height: 56,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : null,
          border: isSelected
              ? Border.all(color: AppColors.primary.withValues(alpha: 0.3))
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? AppColors.primary : iconColor,
                size: 24,
              ),
              if (showLabel) ...[
                const SizedBox(width: 16),
                Expanded(
                  child: AutoSizeText(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: isSelected ? AppColors.primary : commonColor,
                    ),
                    maxLines: 1,
                    // overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
