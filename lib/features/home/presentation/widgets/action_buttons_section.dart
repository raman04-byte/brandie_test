import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../shared/widgets/custom_button.dart';

class ActionButtonsSection extends StatelessWidget {
  const ActionButtonsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (ResponsiveUtils.isMobile(context)) {
          return _buildMobileLayout();
        } else {
          return _buildTabletDesktopLayout();
        }
      },
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        CustomButton(
          text: 'Create New Task',
          icon: Icons.add_task,
          width: double.infinity,
          onPressed: () {
            // Handle create task
          },
        ),
        const SizedBox(height: AppConstants.defaultPadding),
        Row(
          children: [
            Expanded(
              child: CustomButton(
                text: 'View Reports',
                icon: Icons.analytics,
                isOutlined: true,
                onPressed: () {
                  // Handle view reports
                },
              ),
            ),
            const SizedBox(width: AppConstants.defaultPadding),
            Expanded(
              child: CustomButton(
                text: 'Settings',
                icon: Icons.settings,
                isOutlined: true,
                onPressed: () {
                  // Handle settings
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTabletDesktopLayout() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: CustomButton(
            text: 'Create New Task',
            icon: Icons.add_task,
            height: 56,
            onPressed: () {
              // Handle create task
            },
          ),
        ),
        const SizedBox(width: AppConstants.defaultPadding),
        Expanded(
          child: CustomButton(
            text: 'View Reports',
            icon: Icons.analytics,
            height: 56,
            isOutlined: true,
            onPressed: () {
              // Handle view reports
            },
          ),
        ),
        const SizedBox(width: AppConstants.defaultPadding),
        Expanded(
          child: CustomButton(
            text: 'Settings',
            icon: Icons.settings,
            height: 56,
            isOutlined: true,
            onPressed: () {
              // Handle settings
            },
          ),
        ),
      ],
    );
  }
}
