library;

import 'package:flutter/material.dart';

import '../../../../core/utils/responsive_utils.dart';
import '../../../../shared/widgets/common_widgets.dart';
import '../../../home/data/profile_data_source.dart';
import 'profile_card.dart';

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

    final profiles = ProfileDataSource.getProfiles();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = ResponsiveUtils.isMobile(context);
        final itemWidth = isMobile
            ? constraints.maxWidth
            : (constraints.maxWidth - (16 * 2)) / 3;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: profiles.asMap().entries.map((entry) {
            final index = entry.key;
            final profile = entry.value;
            return SizedBox(
              width: itemWidth,
              child: ProfileCard(
                profile: profile,
                allProfiles: profiles,
                currentIndex: index,
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
