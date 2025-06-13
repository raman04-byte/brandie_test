import 'package:flutter/material.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/custom_card.dart';
import '../../../../shared/widgets/common_widgets.dart';

class StatsSection extends StatelessWidget {
  final bool isLoading;

  const StatsSection({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox(
        height: 120,
        child: LoadingWidget(message: 'Loading stats...'),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = ResponsiveUtils.getGridColumns(context);
        final childAspectRatio = ResponsiveUtils.isMobile(context) ? 1.8 : 1.5;

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: AppConstants.defaultPadding,
          mainAxisSpacing: AppConstants.defaultPadding,
          childAspectRatio: childAspectRatio,
          children: const [
            InfoCard(
              title: 'Total Tasks',
              value: '24',
              icon: Icons.task_alt,
              iconColor: Colors.blue,
            ),
            InfoCard(
              title: 'Completed',
              value: '18',
              icon: Icons.check_circle,
              iconColor: Colors.green,
            ),
            InfoCard(
              title: 'Pending',
              value: '6',
              icon: Icons.pending,
              iconColor: Colors.orange,
            ),
          ],
        );
      },
    );
  }
}
