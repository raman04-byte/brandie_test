/// Mock data source for profile information
///
/// In a real application, this would be replaced with API calls
/// or database queries. For demo purposes, it provides static data.
library;

import 'package:flutter/material.dart';

import '../../../core/models/profile_models.dart';

/// Data source that provides profile information
class ProfileDataSource {
  /// Returns a list of mock profile data
  ///
  /// In a real application, this would fetch data from an API
  /// or local database.
  static List<ProfileData> getProfiles() {
    return [
      const ProfileData(
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
      const ProfileData(
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
      const ProfileData(
        name: 'Alex Friedman',
        id: '3094083',
        platform: 'Facebook',
        platformIcon: Icons.facebook,
        platformColor: Colors.blue,
        handle: 'www.facebook.c...',
        stats: [StatItem(value: '204', label: 'Friends')],
      ),
      const ProfileData(
        name: 'Frieda Konfs',
        id: '3094083',
        platform: 'Facebook',
        platformIcon: Icons.facebook,
        platformColor: Colors.blue,
        handle: 'www.facebook.c...',
        stats: [StatItem(value: '204', label: 'Friends')],
      ),
      const ProfileData(
        name: 'Unknown User',
        id: '3094083',
        platform: 'WhatsApp',
        platformIcon: Icons.phone,
        platformColor: Colors.green,
        handle: '23039404',
        stats: [StatItem(value: '23039404', label: 'WhatsApp ID')],
      ),
      const ProfileData(
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
      const ProfileData(
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
      const ProfileData(
        name: 'Mike Chen',
        id: '9845321',
        platform: 'LinkedIn',
        platformIcon: Icons.business,
        platformColor: Colors.indigo,
        handle: 'mike.chen',
        stats: [StatItem(value: '892', label: 'Connections')],
      ),
      const ProfileData(
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
