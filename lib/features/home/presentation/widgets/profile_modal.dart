library;

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_auto_size_text/flutter_auto_size_text.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/constants/assets.dart';
import '../../../../core/models/profile_models.dart';
import '../../../../core/models/profile_status_manager.dart';
import '../../../../core/theme/app_colors.dart';

class ProfileModal extends StatefulWidget {
  final List<ProfileData> profiles;
  final int initialIndex;

  const ProfileModal({
    super.key,
    required this.profiles,
    required this.initialIndex,
  });

  @override
  State<ProfileModal> createState() => _ProfileModalState();
}

class _ProfileModalState extends State<ProfileModal> {
  late int currentIndex;
  final ProfileStatusManager _statusManager = ProfileStatusManager();

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
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
    }
  }

  ProfileData get currentProfile => widget.profiles[currentIndex];
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Material(
      color: AppColors.transparent,
      child: Stack(
        children: [
          // Glassmorphism background
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.white.withValues(alpha: 0.15),
                      AppColors.white.withValues(alpha: 0.05),
                      AppColors.black.withValues(alpha: 0.05),
                      AppColors.black.withValues(alpha: 0.1),
                    ],
                    stops: const [0.0, 0.3, 0.7, 1.0],
                  ),
                ),
              ),
            ),
          ),
          // Main content
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Left navigation button
                _buildLeftNavigationButton(),
                const SizedBox(width: 40),
                // Main dialog
                _buildMainDialogContent(screenSize),
                const SizedBox(width: 40),
                // Right navigation button
                _buildRightNavigationButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the left navigation button
  Widget _buildLeftNavigationButton() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
            child: Material(
              color: AppColors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: _navigateLeft,
                child: const Icon(
                  Icons.chevron_left,
                  color: AppColors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the right navigation button
  Widget _buildRightNavigationButton() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
            child: Material(
              color: AppColors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: _navigateRight,
                child: const Icon(
                  Icons.chevron_right,
                  color: AppColors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the main dialog content
  Widget _buildMainDialogContent(Size screenSize) {
    // Calculate responsive size based on screen size
    double dialogWidth = screenSize.width > 1200
        ? 1000
        : screenSize.width > 800
        ? 400
        : screenSize.width * 0.5;

    // Ensure the dialog doesn't get too tall on smaller screens
    double maxHeight = screenSize.height * 0.85;

    // Adjust padding for smaller screens
    double horizontalPadding = screenSize.width > 600 ? 40 : 20;

    return Container(
      width: dialogWidth,
      height: maxHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.15),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: AppColors.white.withValues(alpha: 0.8),
            blurRadius: 0,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.white.withValues(alpha: 0.9),
                  AppColors.white.withValues(alpha: 0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildCloseButton(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      0,
                      horizontalPadding,
                      horizontalPadding,
                    ),
                    child: Column(
                      children: [
                        _buildProfileAvatar(),
                        const SizedBox(height: 24),
                        _buildProfileName(),
                        const SizedBox(height: 12),
                        _buildProfileDetailsRow(),
                        const SizedBox(height: 12),
                        _buildDateInformation(),
                        const SizedBox(height: 40),
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppColors.white.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.black.withValues(alpha: 0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              _buildPlatformConnectionSection(),
                              const SizedBox(height: 40),
                              _buildModalActionSection(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the close button
  Widget _buildCloseButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close, color: Color(0xFF666666)),
            iconSize: 20,
            padding: const EdgeInsets.all(8),
          ),
        ),
      ],
    );
  }

  /// Builds the profile avatar
  Widget _buildProfileAvatar() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300, width: 3),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const CircleAvatar(
        radius: 47,
        backgroundImage: AssetImage(Assets.profile),
        backgroundColor: Color(0xFFF5F5F5),
      ),
    );
  }

  /// Builds the profile name
  Widget _buildProfileName() {
    return AutoSizeText(
      currentProfile.name,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: Color(0xFF212328),
      ),
      maxLines: 1,
      textAlign: TextAlign.center,
    );
  }

  /// Builds the profile details row
  Widget _buildProfileDetailsRow() {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 20,
      runSpacing: 12,
      children: [
        _buildLocationInfo(),
        _buildAgeIndicator(),
        _buildIdInfo(),
        _buildSocialLinks(),
        _buildEmailInfo(),
      ],
    );
  }

  /// Builds location information
  Widget _buildLocationInfo() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20,
          height: 14,
          decoration: const BoxDecoration(
            // borderRadius: BorderRadius.circular(2),
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage('https://flagcdn.com/w40/gb.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 8),
        const AutoSizeText(
          'Birmingham, UK',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF656B76),
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
        ),
      ],
    );
  }

  /// Builds age indicator
  Widget _buildAgeIndicator() {
    // return Container(
    //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    //   decoration: BoxDecoration(
    //     color: AppColors.pink.shade50,
    //     borderRadius: BorderRadius.circular(14),
    //     border: Border.all(color: AppColors.pink.shade200, width: 1),
    //   ),
    //   child: Text(
    //     '42',
    //     style: TextStyle(
    //       fontSize: 13,
    //       color: AppColors.pink.shade600,
    //       fontWeight: FontWeight.w600,
    //     ),
    //   ),
    // );
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        HugeIcon(
          icon: HugeIcons.strokeRoundedMaleSymbol,
          color: Color(0xFF4ECDC4),
          size: 16,
        ),
        SizedBox(width: 6),
        Text(
          '42',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF666666),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// Builds ID information
  Widget _buildIdInfo() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: Color(0xFF4ECDC4),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          'ID: ${currentProfile.id}',
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF666666),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// Builds social links
  Widget _buildSocialLinks() {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.facebook, color: Color(0xFF1877F2), size: 16),
        SizedBox(width: 6),
        Text(
          '@sabrina_rk4',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF666666),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// Builds email information
  Widget _buildEmailInfo() {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.email_outlined, color: Color(0xFF666666), size: 16),
        SizedBox(width: 6),
        Text(
          'sabrina@gmail.com',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF666666),
            fontWeight: FontWeight.w100,
          ),
        ),
      ],
    );
  }

  /// Builds date information
  Widget _buildDateInformation() {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 30,
      runSpacing: 12,
      children: [
        _buildDateItem(Icons.calendar_today_outlined, 'Joined: 17 Jun, 2021'),
        _buildDateItem(Icons.access_time, 'Last Seen: 17 Jun, 2021'),
        _buildDateItem(Icons.post_add, 'Last Post: 17 Jun, 2021'),
      ],
    );
  }

  /// Builds a date item
  Widget _buildDateItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: const Color(0xFF666666)),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF666666),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// Builds platform connection section
  Widget _buildPlatformConnectionSection() {
    return Column(
      children: [
        const Text(
          'Trying to connect',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF666666),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPlatformIcon(),
              const SizedBox(width: 12),
              Text(
                currentProfile.platform,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black87,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _buildProfileHandle(),
        const SizedBox(height: 28),
        if (currentProfile.stats.isNotEmpty) _buildModalStatsSection(),
        const SizedBox(height: 20),
        _buildProfileLinkButton(),
      ],
    );
  }

  /// Builds the profile handle display
  Widget _buildProfileHandle() {
    return Text(
      currentProfile.handle,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1a1a1a),
      ),
      textAlign: TextAlign.center,
    );
  }

  /// Builds the platform icon
  Widget _buildPlatformIcon() {
    switch (currentProfile.platform.toLowerCase()) {
      case 'instagram':
        return const Icon(
          HugeIcons.strokeRoundedInstagram,
          color: Color(0xFFE1306C),
          size: 20,
        );
      case 'tiktok':
        return const Icon(
          HugeIcons.strokeRoundedTiktok,
          color: AppColors.black,
          size: 20,
        );
      case 'facebook':
        return const Icon(Icons.facebook, color: Color(0xFF1877F2), size: 20);
      case 'whatsapp':
        return const Icon(
          HugeIcons.strokeRoundedWhatsapp,
          color: Color(0xFF25D366),
          size: 20,
        );
      case 'youtube':
        return const Icon(
          HugeIcons.strokeRoundedYoutube,
          color: Color(0xFFFF0000),
          size: 20,
        );
      case 'twitter':
        return const Icon(
          HugeIcons.strokeRoundedNewTwitterRectangle,
          color: Color(0xFF1DA1F2),
          size: 20,
        );
      case 'linkedin':
        return const Icon(
          HugeIcons.strokeRoundedLinkedin02,
          color: Color(0xFF0077B5),
          size: 20,
        );
      default:
        return const Icon(Icons.public, color: AppColors.grey, size: 20);
    }
  }

  /// Builds modal stats section
  Widget _buildModalStatsSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: currentProfile.stats.map((stat) {
          return Column(
            children: [
              Text(
                stat.value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1a1a1a),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                stat.label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  /// Builds profile link button
  Widget _buildProfileLinkButton() {
    String linkText = 'Go to ${currentProfile.platform} profile';
    if (currentProfile.platform.toLowerCase() == 'tiktok') {
      linkText = 'Go to TikTok profile';
    } else if (currentProfile.platform.toLowerCase() == 'whatsapp') {
      linkText = 'Go to WhatsApp profile';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.primary, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.open_in_new, size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          Text(
            linkText,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds modal action section - shows action buttons or status message
  Widget _buildModalActionSection() {
    final currentStatus = _statusManager.getProfileStatus(currentProfile.id);
    final isProcessed = _statusManager.isProfileProcessed(currentProfile.id);

    if (isProcessed) {
      return _buildStatusMessage(currentStatus);
    } else {
      return _buildModalActionButtons();
    }
  }

  /// Builds status message for processed profiles
  Widget _buildStatusMessage(ProfileStatus status) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: status.color.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(status.icon, color: status.color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              status.displayText,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: status.color,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds modal action buttons
  Widget _buildModalActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            text: 'Decline',
            icon: Icons.close,
            backgroundColor: AppColors.red,
            onPressed: _handleDecline,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _buildActionButton(
            text: 'Approve',
            icon: Icons.check,
            backgroundColor: AppColors.primary,
            onPressed: _handleAccept,
          ),
        ),
      ],
    );
  }

  /// Builds a styled action button with glassmorphism effect
  Widget _buildActionButton({
    required String text,
    required IconData icon,
    required Color backgroundColor,
    required VoidCallback onPressed,
  }) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: AppColors.white.withValues(alpha: 0.1),
            blurRadius: 0,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onPressed,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.white.withValues(alpha: 0.1),
                  AppColors.transparent,
                ],
              ),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: AppColors.white, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    text,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Navigates to the previous profile
  void _navigateLeft() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You are at the first profile'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  /// Navigates to the next profile
  void _navigateRight() {
    if (currentIndex < widget.profiles.length - 1) {
      setState(() {
        currentIndex++;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You are at the last profile'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  /// Handles the accept action
  void _handleAccept() {
    _statusManager.approveProfile(currentProfile.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.white, size: 20),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Account connection approved successfully',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Handles the decline action
  void _handleDecline() {
    _statusManager.declineProfile(currentProfile.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.cancel, color: AppColors.white, size: 20),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Account connection declined successfully',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
