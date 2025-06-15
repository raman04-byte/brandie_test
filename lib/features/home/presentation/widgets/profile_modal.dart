/// Profile modal widget for displaying detailed profile information
///
/// This widget handles the modal popup that shows when a profile card
/// is clicked, including navigation between profiles.
library;

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/models/profile_models.dart';

/// A modal dialog that displays detailed profile information
/// with navigation capabilities between multiple profiles
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

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  ProfileData get currentProfile => widget.profiles[currentIndex];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _buildLeftNavigationButton(),
          _buildMainDialogContent(),
          _buildRightNavigationButton(),
        ],
      ),
    );
  }

  /// Builds the left navigation button
  Widget _buildLeftNavigationButton() {
    return Positioned(
      left: 20,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300, width: 2),
        ),
        child: IconButton(
          onPressed: _navigateLeft,
          icon: const Icon(Icons.chevron_left, color: Colors.grey, size: 24),
        ),
      ),
    );
  }

  /// Builds the right navigation button
  Widget _buildRightNavigationButton() {
    return Positioned(
      right: 20,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300, width: 2),
        ),
        child: IconButton(
          onPressed: _navigateRight,
          icon: const Icon(Icons.chevron_right, color: Colors.grey, size: 24),
        ),
      ),
    );
  }

  /// Builds the main dialog content
  Widget _buildMainDialogContent() {
    return Container(
      width: 500,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCloseButton(),
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 0, 40, 40),
            child: Column(
              children: [
                _buildProfileAvatar(),
                const SizedBox(height: 16),
                _buildProfileName(),
                const SizedBox(height: 16),
                _buildProfileDetailsRow(),
                const SizedBox(height: 16),
                _buildDateInformation(),
                const SizedBox(height: 24),
                _buildPlatformConnectionSection(),
                const SizedBox(height: 24),
                if (currentProfile.stats.isNotEmpty) _buildModalStatsSection(),
                const SizedBox(height: 24),
                _buildProfileLinkButton(),
                const SizedBox(height: 32),
                _buildModalActionButtons(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the close button
  Widget _buildCloseButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close, color: Colors.grey),
          padding: const EdgeInsets.all(16),
        ),
      ],
    );
  }

  /// Builds the profile avatar
  Widget _buildProfileAvatar() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300, width: 2),
      ),
      child: const CircleAvatar(
        radius: 38,
        backgroundImage: AssetImage('assets/images/logo.png'),
        backgroundColor: Color(0xFFF5F5F5),
      ),
    );
  }

  /// Builds the profile name
  Widget _buildProfileName() {
    return Text(
      currentProfile.name,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  /// Builds the profile details row
  Widget _buildProfileDetailsRow() {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 12,
      runSpacing: 8,
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
          height: 20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            image: const DecorationImage(
              image: NetworkImage('https://flagcdn.com/w40/gb.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 6),
        const Text(
          'Birmingham, UK',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }

  /// Builds age indicator
  Widget _buildAgeIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.pink.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        '42',
        style: TextStyle(
          fontSize: 12,
          color: Colors.pink,
          fontWeight: FontWeight.w500,
        ),
      ),
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
        const SizedBox(width: 4),
        Text(
          'ID: ${currentProfile.id}',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
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
        SizedBox(width: 4),
        Text(
          '@sabrina_rk4',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  /// Builds email information
  Widget _buildEmailInfo() {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.email_outlined, color: Colors.grey, size: 16),
        SizedBox(width: 4),
        Text(
          'sabrina@gmail.com',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  /// Builds date information
  Widget _buildDateInformation() {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 16,
      runSpacing: 8,
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
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  /// Builds platform connection section
  Widget _buildPlatformConnectionSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text(
            'Trying to connect',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildPlatformIcon(),
              const SizedBox(width: 8),
              Text(
                currentProfile.platform,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds the platform icon
  Widget _buildPlatformIcon() {
    switch (currentProfile.platform.toLowerCase()) {
      case 'instagram':
        return const Icon(
          HugeIcons.strokeRoundedInstagram,
          color: Color(0xFFE1306C),
          size: 16,
        );
      case 'tiktok':
        return const Icon(
          HugeIcons.strokeRoundedTiktok,
          color: Colors.black,
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
        return const Icon(Icons.public, color: Colors.grey, size: 16);
    }
  }

  /// Builds modal stats section
  Widget _buildModalStatsSection() {
    if (currentProfile.stats.length == 1) {
      // Single stat (like WhatsApp)
      return Column(
        children: [
          Text(
            currentProfile.stats.first.value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            currentProfile.stats.first.label,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      );
    } else {
      // Multiple stats
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: currentProfile.stats.map((stat) {
          return Column(
            children: [
              Text(
                stat.value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                stat.label,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          );
        }).toList(),
      );
    }
  }

  /// Builds profile link button
  Widget _buildProfileLinkButton() {
    String linkText = 'Go to ${currentProfile.platform} profile';
    if (currentProfile.platform.toLowerCase() == 'facebook') {
      linkText = 'Go to Facebook URL';
    }

    return TextButton.icon(
      onPressed: () {
        // Handle profile link navigation
      },
      icon: const Icon(Icons.open_in_new, size: 16, color: Color(0xFF4285F4)),
      label: Text(
        linkText,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF4285F4),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// Builds modal action buttons
  Widget _buildModalActionButtons() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFFF4444),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                _handleDecline();
              },
              icon: const Icon(Icons.close, color: Colors.white, size: 18),
              label: const Text(
                'Decline',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF4285F4),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                _handleAccept();
              },
              icon: const Icon(Icons.check, color: Colors.white, size: 18),
              label: const Text(
                'Approve',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${currentProfile.name} accepted'),
        backgroundColor: Colors.green,
      ),
    );
  }

  /// Handles the decline action
  void _handleDecline() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${currentProfile.name} declined'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
