library;

import 'package:flutter/material.dart';
import '../../../../core/models/profile_models.dart';
import '../../../../shared/widgets/modal_widgets.dart';
import 'profile_detail_view.dart';


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
    return NavigableModal(
      onNavigateLeft: _navigateLeft,
      onNavigateRight: _navigateRight,
      canNavigateLeft: currentIndex > 0,
      canNavigateRight: currentIndex < widget.profiles.length - 1,
      child: ProfileDetailView(profile: currentProfile),
    );
  }

  /// Navigates to the previous profile
  void _navigateLeft() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
    } else {
      _showNavigationMessage('You are at the first profile');
    }
  }

  /// Navigates to the next profile
  void _navigateRight() {
    if (currentIndex < widget.profiles.length - 1) {
      setState(() {
        currentIndex++;
      });
    } else {
      _showNavigationMessage('You are at the last profile');
    }
  }

  /// Shows a navigation message to the user
  void _showNavigationMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }
}
