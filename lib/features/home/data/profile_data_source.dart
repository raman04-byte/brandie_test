library;

import 'package:flutter/material.dart';

import '../../../core/models/profile_models.dart';
import '../../../core/theme/app_colors.dart';

class ProfileDataSource {
  static List<ProfileData> getProfiles() {
    return [
      const ProfileData(
        name: 'Katy Windsor',
        id: '3094083',
        platform: 'Instagram',
        platformIcon: Icons.camera_alt,
        platformColor: AppColors.pink,
        handle: '@sabrina239',
        stats: [
          StatItem(value: '3,302', label: 'Followers'),
          StatItem(value: '204', label: 'Following'),
          StatItem(value: '138', label: 'Posts'),
        ],
      ),
      const ProfileData(
        name: 'Sabrina Sanders',
        id: '3094084',
        platform: 'TikTok',
        platformIcon: Icons.music_note,
        platformColor: AppColors.black,
        handle: '@sabrina239',
        stats: [
          StatItem(value: '3,302', label: 'Followers'),
          StatItem(value: '204', label: 'Following'),
          StatItem(value: '138', label: 'Posts'),
        ],
      ),
      const ProfileData(
        name: 'Alex Friedman',
        id: '3094085',
        platform: 'Facebook',
        platformIcon: Icons.facebook,
        platformColor: AppColors.blue,
        handle: 'www.facebook.c...',
        stats: [StatItem(value: '204', label: 'Friends')],
      ),
      const ProfileData(
        name: 'Frieda Konfs',
        id: '3094086',
        platform: 'Facebook',
        platformIcon: Icons.facebook,
        platformColor: AppColors.blue,
        handle: 'www.facebook.c...',
        stats: [StatItem(value: '204', label: 'Friends')],
      ),
      const ProfileData(
        name: 'Unknown User',
        id: '3094087',
        platform: 'WhatsApp',
        platformIcon: Icons.phone,
        platformColor: AppColors.green,
        handle: '23039404',
        stats: [StatItem(value: '23039404', label: 'WhatsApp ID')],
      ),
      const ProfileData(
        name: 'Sabrina Sanders',
        id: '3094088',
        platform: 'TikTok',
        platformIcon: Icons.music_note,
        platformColor: AppColors.black,
        handle: '@sabrina239',
        stats: [
          StatItem(value: '3,302', label: 'Followers'),
          StatItem(value: '204', label: 'Following'),
          StatItem(value: '138', label: 'Posts'),
        ],
      ),
      const ProfileData(
        name: 'Emma Johnson',
        id: '4829571',
        platform: 'Twitter',
        platformIcon: Icons.alternate_email,
        platformColor: AppColors.lightBlue,
        handle: '@emma_j',
        stats: [
          StatItem(value: '1,205', label: 'Followers'),
          StatItem(value: '89', label: 'Following'),
          StatItem(value: '542', label: 'Tweets'),
        ],
      ),
      const ProfileData(
        name: 'Mike Chen',
        id: '9845321',
        platform: 'LinkedIn',
        platformIcon: Icons.business,
        platformColor: AppColors.indigo,
        handle: 'mike.chen',
        stats: [StatItem(value: '892', label: 'Connections')],
      ),
      const ProfileData(
        name: 'Sarah Williams',
        id: '1357924',
        platform: 'YouTube',
        platformIcon: Icons.play_circle,
        platformColor: AppColors.red,
        handle: '@sarahw',
        stats: [
          StatItem(value: '15.2K', label: 'Subscribers'),
          StatItem(value: '45', label: 'Videos'),
        ],
      ),
    ];
  }
}
