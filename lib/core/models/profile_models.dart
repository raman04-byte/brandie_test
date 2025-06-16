library;

import 'package:flutter/material.dart';

class ProfileData {
  final String name;
  final String id;
  final String platform;
  final IconData platformIcon;
  final Color platformColor;
  final String handle;
  final List<StatItem> stats;
  final ProfileStatus status;

  const ProfileData({
    required this.name,
    required this.id,
    required this.platform,
    required this.platformIcon,
    required this.platformColor,
    required this.handle,
    required this.stats,
    this.status = ProfileStatus.pending,
  });
  ProfileData copyWith({
    String? name,
    String? id,
    String? platform,
    IconData? platformIcon,
    Color? platformColor,
    String? handle,
    List<StatItem>? stats,
    ProfileStatus? status,
  }) {
    return ProfileData(
      name: name ?? this.name,
      id: id ?? this.id,
      platform: platform ?? this.platform,
      platformIcon: platformIcon ?? this.platformIcon,
      platformColor: platformColor ?? this.platformColor,
      handle: handle ?? this.handle,
      stats: stats ?? this.stats,
      status: status ?? this.status,
    );
  }
}

class StatItem {
  final String value;
  final String label;

  const StatItem({required this.value, required this.label});

  StatItem copyWith({String? value, String? label}) {
    return StatItem(value: value ?? this.value, label: label ?? this.label);
  }
}

enum ProfileStatus {
  pending,
  approved,
  declined;

  String get displayText {
    switch (this) {
      case ProfileStatus.pending:
        return 'Pending';
      case ProfileStatus.approved:
        return 'Account connection approved successfully';
      case ProfileStatus.declined:
        return 'Account connection declined successfully';
    }
  }

  Color get color {
    switch (this) {
      case ProfileStatus.pending:
        return const Color(0xFF6C757D);
      case ProfileStatus.approved:
        return const Color(0xFF28A745);
      case ProfileStatus.declined:
        return const Color(0xFFDC3545);
    }
  }
  IconData get icon {
    switch (this) {
      case ProfileStatus.pending:
        return Icons.schedule;
      case ProfileStatus.approved:
        return Icons.check_circle;
      case ProfileStatus.declined:
        return Icons.cancel;
    }
  }
}
