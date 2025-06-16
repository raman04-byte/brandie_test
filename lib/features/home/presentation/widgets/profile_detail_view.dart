import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/models/profile_models.dart';

/// A widget that displays detailed profile information in a consistent format
class ProfileDetailView extends StatelessWidget {
  final ProfileData profile;

  const ProfileDetailView({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppConstants.largePadding * 1.5,
        0,
        AppConstants.largePadding * 1.5,
        AppConstants.largePadding * 1.5,
      ),
      child: Column(
        children: [
          _buildProfileAvatar(),
          const SizedBox(height: AppConstants.largePadding),
          _buildProfileName(),
          const SizedBox(height: AppConstants.defaultPadding),
          _buildProfileDetailsRow(),
          const SizedBox(height: AppConstants.defaultPadding),
          _buildDateInformation(),
          const SizedBox(height: AppConstants.largePadding * 1.5),
          _buildPlatformConnectionSection(),
          const SizedBox(height: AppConstants.largePadding * 1.5),
          _buildModalActionButtons(context),
        ],
      ),
    );
  }

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
        backgroundImage: AssetImage('assets/images/profile.png'),
        backgroundColor: Color(0xFFF5F5F5),
      ),
    );
  }

  Widget _buildProfileName() {
    return Text(
      profile.name,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

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
          'ID: ${profile.id}',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

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

  Widget _buildPlatformConnectionSection() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
      ),
      child: Column(
        children: [
          const Text(
            'Trying to connect',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: AppConstants.smallPadding),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildPlatformIcon(),
              const SizedBox(width: AppConstants.smallPadding),
              Text(
                profile.platform,
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

  Widget _buildPlatformIcon() {
    switch (profile.platform.toLowerCase()) {
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

  Widget _buildModalActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFFF4444),
              borderRadius: BorderRadius.circular(
                AppConstants.smallBorderRadius,
              ),
            ),
            child: TextButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                _handleDecline(context);
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
        const SizedBox(width: AppConstants.defaultPadding),
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF4285F4),
              borderRadius: BorderRadius.circular(
                AppConstants.smallBorderRadius,
              ),
            ),
            child: TextButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                _handleAccept(context);
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

  void _handleAccept(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${profile.name} accepted'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _handleDecline(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${profile.name} declined'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
