library;

import 'package:flutter/material.dart';
import 'package:flutter_auto_size_text/flutter_auto_size_text.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/constants/assets.dart';
import '../../../../core/models/profile_models.dart';
import '../../../../core/models/profile_status_manager.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/custom_card.dart';
import 'profile_modal.dart';

class ProfileCard extends StatefulWidget {
  final ProfileData profile;
  final List<ProfileData> allProfiles;
  final int currentIndex;
  final VoidCallback? onStatusChanged;

  const ProfileCard({
    super.key,
    required this.profile,
    required this.allProfiles,
    required this.currentIndex,
    this.onStatusChanged,
  });

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  bool _isHovered = false;
  final ProfileStatusManager _statusManager = ProfileStatusManager();

  @override
  void initState() {
    super.initState();
    _statusManager.addListener(_onStatusChanged);
  }

  @override
  void dispose() {
    _statusManager.removeListener(_onStatusChanged);
    super.dispose();
  }

  void _onStatusChanged() {
    if (mounted) {
      setState(() {});
      widget.onStatusChanged?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: CustomCard(
        padding: const EdgeInsets.all(16),
        onTap: () => _showProfileModal(context, widget.currentIndex),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 16),
            _buildPlatformSection(),
            const SizedBox(height: 12),
            _buildProfileHandle(),
            const SizedBox(height: 16),
            if (widget.profile.stats.isNotEmpty) _buildStatsSection(),
          ],
        ),
      ),
    );
  }

  /// Builds the profile header with avatar and basic info
  Widget _buildProfileHeader() {
    return Row(
      children: [
        // Profile Avatar
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.lightGrey, width: 1),
          ),
          child: const CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage(Assets.profile),
            backgroundColor: AppColors.lightGrey,
          ),
        ),
        const SizedBox(width: 12),

        // Profile Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AutoSizeText(
                widget.profile.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF212328),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4ECDC4),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  AutoSizeText(
                    'ID: ${widget.profile.id}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF54565F),
                    ),
                    maxLines: 1,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds the platform section with badge and action buttons or status
  Widget _buildPlatformSection() {
    final currentStatus = _statusManager.getProfileStatus(widget.profile.id);
    final isProcessed = _statusManager.isProfileProcessed(widget.profile.id);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: widget.profile.platformColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPlatformIcon(),
              const SizedBox(width: 8),
              AutoSizeText(
                widget.profile.platform,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black87,
                ),
                maxLines: 1,
              ),
            ],
          ),
        ),
        const Spacer(),
        if (isProcessed)
          _buildStatusBadge(currentStatus)
        else
          AnimatedOpacity(
            opacity: _isHovered ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildActionButton(
                  icon: Icons.close,
                  color: const Color(0xFFDD2828),
                  onPressed: () => _handleDecline(),
                ),
                const SizedBox(width: 8),
                _buildActionButton(
                  icon: Icons.check,
                  color: const Color(0xFF3C54EF),
                  onPressed: () => _handleAccept(),
                ),
              ],
            ),
          ),
      ],
    );
  }

  /// Builds a status badge for processed profiles
  Widget _buildStatusBadge(ProfileStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: status.color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: 16, color: status.color),
          const SizedBox(width: 6),
          Text(
            status == ProfileStatus.approved ? 'Approved' : 'Declined',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: status.color,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the profile handle display
  Widget _buildProfileHandle() {
    return AutoSizeText(
      widget.profile.handle,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
        color: AppColors.black87,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// Builds the stats section with proper layout
  Widget _buildStatsSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: widget.profile.stats.length == 1
            ? MainAxisAlignment.center
            : MainAxisAlignment.spaceAround,
        children: _buildStatsRow(),
      ),
    );
  }

  /// Builds the stats row with proper separators
  List<Widget> _buildStatsRow() {
    List<Widget> widgets = [];

    for (int i = 0; i < widget.profile.stats.length; i++) {
      widgets.add(
        _buildStatItem(
          widget.profile.stats[i].value,
          widget.profile.stats[i].label,
        ),
      );

      if (i < widget.profile.stats.length - 1) {
        widgets.add(_buildStatDivider());
      }
    }

    return widgets;
  }

  /// Builds an individual stat item
  Widget _buildStatItem(String value, String label) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AutoSizeText(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: Color(0xFF212328),
            ),
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          AutoSizeText(
            label,
            style: const TextStyle(
              color: Color(0xFF656B76),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Builds a divider between stats
  Widget _buildStatDivider() {
    return Container(
      height: 40,
      width: 1,
      color: const Color(0xFFE0E0E0),
      margin: const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  /// Builds the platform icon based on platform type
  Widget _buildPlatformIcon() {
    switch (widget.profile.platform.toLowerCase()) {
      case 'instagram':
        return const Icon(
          HugeIcons.strokeRoundedInstagram,
          color: Color(0xFFE1306C),
          size: 16,
        );
      case 'tiktok':
        return const Icon(
          HugeIcons.strokeRoundedTiktok,
          color: AppColors.black,
          size: 16,
        );
      case 'facebook':
        return const Icon(Icons.facebook, color: Color(0xFF1877F2), size: 16);
      case 'whatsapp':
        return const Icon(
          HugeIcons.strokeRoundedWhatsapp,
          color: Color(0xFF25D366),
          size: 16,
        );
      case 'youtube':
        return const Icon(
          HugeIcons.strokeRoundedYoutube,
          color: Color(0xFFFF0000),
          size: 16,
        );
      case 'twitter':
        return const Icon(
          HugeIcons.strokeRoundedNewTwitterRectangle,
          color: Color(0xFF1DA1F2),
          size: 16,
        );
      case 'linkedin':
        return const Icon(
          HugeIcons.strokeRoundedLinkedin02,
          color: Color(0xFF0077B5),
          size: 16,
        );
      default:
        return const Icon(Icons.public, color: AppColors.grey, size: 16);
    }
  }

  /// Builds an action button with consistent styling
  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: AppColors.white, size: 16),
        padding: EdgeInsets.zero,
      ),
    );
  }

  /// Shows the profile modal dialog
  void _showProfileModal(BuildContext context, int initialIndex) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      pageBuilder:
          (
            BuildContext buildContext,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return ProfileModal(
              profiles: widget.allProfiles,
              initialIndex: initialIndex,
            );
          },
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.8, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
            ),
            child: child,
          ),
        );
      },
    );
  }

  /// Handles the accept action
  void _handleAccept() {
    _statusManager.approveProfile(widget.profile.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: AppColors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text('${widget.profile.name} approved successfully'),
            ),
          ],
        ),
        backgroundColor: AppColors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Handles the decline action
  void _handleDecline() {
    _statusManager.declineProfile(widget.profile.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.cancel, color: AppColors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text('${widget.profile.name} declined successfully'),
            ),
          ],
        ),
        backgroundColor: AppColors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
