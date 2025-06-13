import 'package:flutter/material.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/custom_card.dart';
import '../../../../shared/widgets/common_widgets.dart';

class RecentActivitySection extends StatelessWidget {
  final bool isLoading;

  const RecentActivitySection({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent Activity', style: AppTextStyles.h4),
        const SizedBox(height: AppConstants.defaultPadding),
        if (isLoading)
          const SizedBox(
            height: 200,
            child: LoadingWidget(message: 'Loading activities...'),
          )
        else
          _buildActivityList(),
      ],
    );
  }

  Widget _buildActivityList() {
    final activities = [
      {
        'title': 'Task "Design Review" completed',
        'subtitle': '2 hours ago',
        'icon': Icons.check_circle,
        'color': Colors.green,
      },
      {
        'title': 'New task "User Testing" created',
        'subtitle': '4 hours ago',
        'icon': Icons.add_circle,
        'color': Colors.blue,
      },
      {
        'title': 'Task "Bug Fix" updated',
        'subtitle': '6 hours ago',
        'icon': Icons.edit,
        'color': Colors.orange,
      },
      {
        'title': 'Project "Mobile App" milestone reached',
        'subtitle': '1 day ago',
        'icon': Icons.flag,
        'color': Colors.purple,
      },
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: activities.length,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppConstants.defaultPadding),
      itemBuilder: (context, index) {
        final activity = activities[index];
        return _buildActivityItem(
          title: activity['title'] as String,
          subtitle: activity['subtitle'] as String,
          icon: activity['icon'] as IconData,
          color: activity['color'] as Color,
        );
      },
    );
  }

  Widget _buildActivityItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return CustomCard(
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: AppConstants.defaultPadding),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppConstants.smallPadding / 2),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textHint, size: 20),
        ],
      ),
    );
  }
}
