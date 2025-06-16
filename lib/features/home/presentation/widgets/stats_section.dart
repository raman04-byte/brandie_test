import 'package:flutter/material.dart';

import '../../../../core/models/profile_models.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../shared/widgets/common_widgets.dart';
import '../../../home/data/profile_data_source.dart';
import 'profile_card.dart';

/// A section widget that displays a grid of profile cards
/// with responsive layout and loading states
class StatsSection extends StatelessWidget {
  final bool isLoading;
  final String searchQuery;
  final String sortOption;
  final bool isAscending;

  const StatsSection({
    super.key,
    required this.isLoading,
    this.searchQuery = '',
    this.sortOption = 'Date Connected',
    this.isAscending = true,
  });
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox(
        height: 400,
        child: LoadingWidget(message: 'Loading profiles...'),
      );
    }

    final profiles = ProfileDataSource.getProfiles();
    final filteredProfiles = _filterAndSortProfiles(profiles);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = ResponsiveUtils.isMobile(context);
        final itemWidth = isMobile
            ? constraints.maxWidth
            : (constraints.maxWidth - (16 * 2)) / 3;

        if (filteredProfiles.isEmpty) {
          return const SizedBox(
            height: 200,
            child: Center(
              child: Text(
                'No profiles found matching your search.',
                style: TextStyle(fontSize: 16, color: AppColors.grey),
              ),
            ),
          );
        }
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: filteredProfiles.asMap().entries.map((entry) {
            final profile = entry.value;
            // Use original index from all profiles for modal navigation
            final originalIndex = profiles.indexOf(profile);
            return SizedBox(
              width: itemWidth,
              child: ProfileCard(
                profile: profile,
                allProfiles: profiles, // Pass all profiles for modal navigation
                currentIndex: originalIndex,
              ),
            );
          }).toList(),
        );
      },
    );
  }

  /// Filters and sorts profiles based on search query and sort option
  List<ProfileData> _filterAndSortProfiles(List<ProfileData> profiles) {
    List<ProfileData> filtered = profiles;

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      filtered = profiles.where((profile) {
        return profile.name.toLowerCase().contains(query) ||
            profile.handle.toLowerCase().contains(query) ||
            profile.platform.toLowerCase().contains(query);
      }).toList();
    } // Apply sorting
    switch (sortOption) {
      case 'Date Connected':
        // For demo purposes, sort by name since we don't have actual connection dates
        filtered.sort(
          (a, b) =>
              isAscending ? a.name.compareTo(b.name) : b.name.compareTo(a.name),
        );
        break;
      case 'Username':
        filtered.sort(
          (a, b) => isAscending
              ? a.handle.compareTo(b.handle)
              : b.handle.compareTo(a.handle),
        );
        break;
    }

    return filtered;
  }
}
