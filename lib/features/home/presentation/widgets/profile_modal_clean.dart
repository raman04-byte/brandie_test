/// Profile modal widget for displaying detailed profile information
///
/// This widget handles the modal popup that shows when a profile card
/// is clicked, including navigation between profiles.
///
/// Follows clean architecture principles with DRY implementation
/// using shared glassmorphism components.
library;

import 'package:flutter/material.dart';
import '../../../../core/models/profile_models.dart';
import '../../../../shared/widgets/modal_widgets.dart';
import 'profile_detail_view.dart';

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
