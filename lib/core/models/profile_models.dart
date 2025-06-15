/// Profile data models for the application
///
/// These models represent the core data structures used throughout
/// the application for profile-related functionality.
library;

import 'package:flutter/material.dart';

/// Represents a social media profile with associated statistics
class ProfileData {
  final String name;
  final String id;
  final String platform;
  final IconData platformIcon;
  final Color platformColor;
  final String handle;
  final List<StatItem> stats;

  const ProfileData({
    required this.name,
    required this.id,
    required this.platform,
    required this.platformIcon,
    required this.platformColor,
    required this.handle,
    required this.stats,
  });

  /// Creates a copy of this profile with updated values
  ProfileData copyWith({
    String? name,
    String? id,
    String? platform,
    IconData? platformIcon,
    Color? platformColor,
    String? handle,
    List<StatItem>? stats,
  }) {
    return ProfileData(
      name: name ?? this.name,
      id: id ?? this.id,
      platform: platform ?? this.platform,
      platformIcon: platformIcon ?? this.platformIcon,
      platformColor: platformColor ?? this.platformColor,
      handle: handle ?? this.handle,
      stats: stats ?? this.stats,
    );
  }
}

/// Represents a statistical item with a value and label
class StatItem {
  final String value;
  final String label;

  const StatItem({required this.value, required this.label});

  /// Creates a copy of this stat item with updated values
  StatItem copyWith({String? value, String? label}) {
    return StatItem(value: value ?? this.value, label: label ?? this.label);
  }
}
