import 'package:flutter/material.dart';
import 'package:flutter_auto_size_text/flutter_auto_size_text.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../shared/widgets/common_widgets.dart';
import '../../../../shared/widgets/custom_card.dart';

// Profile data model
class ProfileData {
  final String name;
  final String id;
  final String platform;
  final IconData platformIcon;
  final Color platformColor;
  final String handle;
  final List<StatItem> stats;

  ProfileData({
    required this.name,
    required this.id,
    required this.platform,
    required this.platformIcon,
    required this.platformColor,
    required this.handle,
    required this.stats,
  });
}

class StatItem {
  final String value;
  final String label;

  StatItem({required this.value, required this.label});
}

class StatsSection extends StatelessWidget {
  final bool isLoading;

  const StatsSection({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox(
        height: 400,
        child: LoadingWidget(message: 'Loading profiles...'),
      );
    }

    final profiles = _getProfiles();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = ResponsiveUtils.isMobile(context);
        final itemWidth = isMobile
            ? constraints.maxWidth
            : (constraints.maxWidth - (16 * 2)) / 3;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: profiles.map((profile) {
            return SizedBox(
              width: itemWidth,
              child: ProfileCard(profile: profile),
            );
          }).toList(),
        );
      },
    );
  }

  List<ProfileData> _getProfiles() {
    return [
      ProfileData(
        name: 'Katy Windsor',
        id: '3094083',
        platform: 'Instagram',
        platformIcon: Icons.camera_alt,
        platformColor: Colors.pink,
        handle: '@sabrina239',
        stats: [
          StatItem(value: '3,302', label: 'Followers'),
          StatItem(value: '204', label: 'Following'),
          StatItem(value: '138', label: 'Posts'),
        ],
      ),
      ProfileData(
        name: 'Sabrina Sanders',
        id: '3094083',
        platform: 'TikTok',
        platformIcon: Icons.music_note,
        platformColor: Colors.black,
        handle: '@sabrina239',
        stats: [
          StatItem(value: '3,302', label: 'Followers'),
          StatItem(value: '204', label: 'Following'),
          StatItem(value: '138', label: 'Posts'),
        ],
      ),
      ProfileData(
        name: 'Alex Friedman',
        id: '3094083',
        platform: 'Facebook',
        platformIcon: Icons.facebook,
        platformColor: Colors.blue,
        handle: 'www.facebook.c...',
        stats: [StatItem(value: '204', label: 'Friends')],
      ),
      ProfileData(
        name: 'Frieda Konfs',
        id: '3094083',
        platform: 'Facebook',
        platformIcon: Icons.facebook,
        platformColor: Colors.blue,
        handle: 'www.facebook.c...',
        stats: [StatItem(value: '204', label: 'Friends')],
      ),
      ProfileData(
        name: 'Unknown User',
        id: '3094083',
        platform: 'WhatsApp',
        platformIcon: Icons.phone,
        platformColor: Colors.green,
        handle: '23039404',
        stats: [StatItem(value: '23039404', label: 'WhatsApp ID')],
      ),
      ProfileData(
        name: 'Sabrina Sanders',
        id: '3094083',
        platform: 'TikTok',
        platformIcon: Icons.music_note,
        platformColor: Colors.black,
        handle: '@sabrina239',
        stats: [
          StatItem(value: '3,302', label: 'Followers'),
          StatItem(value: '204', label: 'Following'),
          StatItem(value: '138', label: 'Posts'),
        ],
      ),
      ProfileData(
        name: 'Emma Johnson',
        id: '4829571',
        platform: 'Twitter',
        platformIcon: Icons.alternate_email,
        platformColor: Colors.lightBlue,
        handle: '@emma_j',
        stats: [
          StatItem(value: '1,205', label: 'Followers'),
          StatItem(value: '89', label: 'Following'),
          StatItem(value: '542', label: 'Tweets'),
        ],
      ),
      ProfileData(
        name: 'Mike Chen',
        id: '9845321',
        platform: 'LinkedIn',
        platformIcon: Icons.business,
        platformColor: Colors.indigo,
        handle: 'mike.chen',
        stats: [StatItem(value: '892', label: 'Connections')],
      ),
      ProfileData(
        name: 'Sarah Williams',
        id: '1357924',
        platform: 'YouTube',
        platformIcon: Icons.play_circle,
        platformColor: Colors.red,
        handle: '@sarahw',
        stats: [
          StatItem(value: '15.2K', label: 'Subscribers'),
          StatItem(value: '45', label: 'Videos'),
        ],
      ),
    ];
  }
}

class ProfileCard extends StatefulWidget {
  final ProfileData profile;

  const ProfileCard({super.key, required this.profile});

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: CustomCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Profile Header
            Row(
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
                    backgroundImage: AssetImage('assets/images/logo.png'),
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
                      const SizedBox(width: 4),
                      Row(
                        spacing: 4,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF4ECDC4),
                              shape: BoxShape.circle,
                            ),
                          ),
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
            ),

            const SizedBox(height: 16),

            // Platform Section
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: widget.profile.platformColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    spacing: 8,
                    children: [
                      _buildPlatformIcon(),
                      AutoSizeText(
                        widget.profile.platform,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
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
            ),

            const SizedBox(height: 12),

            // Handle
            AutoSizeText(
              widget.profile.handle,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 16),

            // Stats Row
            if (widget.profile.stats.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
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
              ),
          ],
        ),
      ),
    );
  }

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

  Widget _buildPlatformIcon() {
    IconData iconData;
    Color iconColor;

    switch (widget.profile.platform.toLowerCase()) {
      case 'instagram':
        iconData = HugeIcons.strokeRoundedInstagram;
        iconColor = const Color(0xFFE1306C);
        break;
      case 'tiktok':
        iconData = HugeIcons.strokeRoundedTiktok;
        iconColor = Colors.black;
        break;
      case 'facebook':
        iconData = Icons.facebook;
        iconColor = const Color(0xFF1877F2);
        break;
      case 'whatsapp':
        iconData = HugeIcons.strokeRoundedWhatsapp;
        iconColor = const Color(0xFF25D366);
        break;
      case 'youtube':
        iconData = HugeIcons.strokeRoundedYoutube;
        iconColor = const Color(0xFFFF0000);
        break;
      case 'twitter':
        iconData = HugeIcons.strokeRoundedNewTwitterRectangle;
        iconColor = const Color(0xFF1DA1F2);
        break;
      case 'linkedin':
        iconData = HugeIcons.strokeRoundedLinkedin02;
        iconColor = const Color(0xFF0077B5);
        break;
      default:
        iconData = Icons.public;
        iconColor = Colors.grey;
    }

    return Icon(iconData, color: iconColor, size: 16);
  }

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
        icon: Icon(icon, color: Colors.white, size: 16),
        padding: EdgeInsets.zero,
      ),
    );
  }

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

  Widget _buildStatDivider() {
    return Container(
      height: 40,
      width: 1,
      color: const Color(0xFFE0E0E0),
      margin: const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  void _handleAccept() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AutoSizeText('${widget.profile.name} accepted'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _handleDecline() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AutoSizeText('${widget.profile.name} declined'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
