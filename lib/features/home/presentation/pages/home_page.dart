import 'package:flutter/material.dart';
import '../widgets/header_section.dart';
import '../widgets/stats_section.dart';
import '../widgets/action_buttons_section.dart';
import '../widgets/recent_activity_section.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/responsive_utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    // Simulate loading data
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _onRefresh() async {
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(
              ResponsiveUtils.getResponsivePadding(context),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                const HeaderSection(),

                const SizedBox(height: AppConstants.largePadding),

                // Stats Section
                StatsSection(isLoading: _isLoading),

                const SizedBox(height: AppConstants.largePadding),

                // Action Buttons Section
                const ActionButtonsSection(),

                const SizedBox(height: AppConstants.largePadding),

                // Recent Activity Section
                RecentActivitySection(isLoading: _isLoading),

                // Bottom spacing for better scroll experience
                const SizedBox(height: AppConstants.largePadding),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
