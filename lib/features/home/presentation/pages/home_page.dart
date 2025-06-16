import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auto_size_text/flutter_auto_size_text.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../widgets/common_image_logo.dart';
import '../widgets/hover_expandable_navigation.dart';
import '../widgets/stats_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = false;
  int _selectedNavIndex = 0;
  String _searchQuery = '';
  String _sortOption = 'Date Connected';
  bool _isAscending = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<NavItemData> navItems = const [
    NavItemData(
      icon: HugeIcons.strokeRoundedDashboardSquare03,
      label: 'Dashboard',
    ),
    NavItemData(
      icon: HugeIcons.strokeRoundedLicenseThirdParty,
      label: 'Shared Content',
    ),
    NavItemData(icon: HugeIcons.strokeRoundedUserMultiple, label: 'Members'),
    NavItemData(icon: HugeIcons.strokeRoundedImage02, label: 'Library Assets'),
    NavItemData(
      icon: HugeIcons.strokeRoundedBookOpen01,
      label: 'Education Hub',
    ),
    NavItemData(icon: HugeIcons.strokeRoundedChampion, label: 'Campaigns'),
    NavItemData(icon: HugeIcons.strokeRoundedUserGroup02, label: 'Communities'),
    NavItemData(icon: HugeIcons.strokeRoundedGrid, label: 'Hashtags'),
    NavItemData(
      icon: HugeIcons.strokeRoundedDashboardCircleSettings,
      label: 'AI Console',
    ),
    NavItemData(
      icon: HugeIcons.strokeRoundedFileVerified,
      label: 'Review Accounts',
    ),
    NavItemData(
      icon: HugeIcons.strokeRoundedNotification01,
      label: 'Push Notifications',
    ),
    NavItemData(
      icon: HugeIcons.strokeRoundedSlidersHorizontal,
      label: 'Sharing Controls',
    ),
    NavItemData(
      icon: HugeIcons.strokeRoundedUserSettings01,
      label: 'User Management',
    ),
    NavItemData(icon: HugeIcons.strokeRoundedBrush, label: 'Appearance'),
    NavItemData(
      icon: HugeIcons.strokeRoundedInformationCircle,
      label: 'FAQ & Tutorials',
    ),
  ];

  String _selectedLang = 'UK'; // Default language
  final Map<String, String> _languages = {
    'UK': 'GB', // GB is the ISO code for United Kingdom
    'US': 'US',
    'FR': 'FR',
    'DE': 'DE',
    'IN': 'IN',
  };

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

  void _onNavItemSelected(int index) {
    setState(() {
      _selectedNavIndex = index;
    });
    // Close drawer if on mobile
    if (_scaffoldKey.currentState?.isDrawerOpen == true) {
      Navigator.of(context).pop();
    }
    debugPrint('Navigation item selected: ${_getPageTitle()}');
  }

  String _getPageTitle() {
    if (_selectedNavIndex < navItems.length) {
      return navItems[_selectedNavIndex].label;
    }
    return AppConstants.appName;
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      key: _scaffoldKey,
      appBar: isSmallScreen
          ? AppBar(
              title: AutoSizeText(_getPageTitle(), maxLines: 1),
              leading: IconButton(
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
                icon: const Icon(Icons.menu),
              ),
            )
          : AppBar(
              title: AutoSizeText(
                _getPageTitle(),
                maxLines: 1,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              actionsPadding: const EdgeInsets.only(top: 10, right: 10),
              centerTitle: true,
              actions: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      const BoxShadow(
                        color: AppColors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                    border: Border.all(color: AppColors.grey, width: 1),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedLang,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedLang = value;
                          });
                        }
                      },
                      items: _languages.entries.map((entry) {
                        return DropdownMenuItem<String>(
                          value: entry.key,
                          child: Row(
                            children: [
                              CountryFlag.fromCountryCode(
                                entry.value.toLowerCase(),
                                height: 24,
                                width: 24,
                                shape: const Circle(),
                                // borderRadius: 12,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                entry.key,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      icon: const Icon(Icons.arrow_drop_down),
                    ),
                  ),
                ),
              ],
            ),
      drawer: isSmallScreen
          ? Drawer(child: _buildNavList(showLabel: true))
          : null,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isSmallScreen)
            HoverExpandableNavigation(
              selectedIndex: _selectedNavIndex,
              onItemSelected: _onNavItemSelected,
              navItems: navItems,
            ),
          Expanded(
            child: SafeArea(
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(
                    ResponsiveUtils.getResponsivePadding(context),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Header Section
                      TopBar(
                        onSearchChanged: (query) {
                          setState(() {
                            _searchQuery = query;
                          });
                        },
                        onSortChanged: (sortOption) {
                          setState(() {
                            _sortOption = sortOption;
                          });
                        },
                        onSortDirectionChanged: (isAscending) {
                          setState(() {
                            _isAscending = isAscending;
                          });
                        },
                      ),

                      const SizedBox(height: AppConstants.largePadding),

                      // Stats Section
                      StatsSection(
                        isLoading: _isLoading,
                        searchQuery: _searchQuery,
                        sortOption: _sortOption,
                        isAscending: _isAscending,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavList({required bool showLabel}) {
    return SingleChildScrollView(
      child: Column(
        spacing: 32,
        children: [
          const CommonImageLogo(),
          const Divider(),
          ...navItems.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return ListTile(
              leading: Icon(item.icon),
              title: showLabel ? AutoSizeText(item.label, maxLines: 1) : null,
              selected: _selectedNavIndex == index,
              onTap: () => _onNavItemSelected(index),
            );
          }),
          ListTile(
            leading: const Icon(
              HugeIcons.strokeRoundedLogout02,
              color: AppColors.red,
            ),
            title: showLabel
                ? const AutoSizeText(
                    'Sign Out',
                    maxLines: 1,
                    style: TextStyle(color: AppColors.red),
                  )
                : null,

            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class TopBar extends StatefulWidget {
  final Function(String)? onSearchChanged;
  final Function(String)? onSortChanged;
  final Function(bool)? onSortDirectionChanged;

  const TopBar({
    super.key,
    this.onSearchChanged,
    this.onSortChanged,
    this.onSortDirectionChanged,
  });

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  String _selectedSortOption = 'Date Connected';
  bool _isAscending = true;
  final TextEditingController _searchController = TextEditingController();

  final List<String> sortOptions = ['Date Connected', 'Username'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Wrap(
            spacing: 12,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              // Search
              SearchBar(
                controller: _searchController,
                onChanged: (value) {
                  widget.onSearchChanged?.call(value);
                },
                leading: const HugeIcon(
                  icon: HugeIcons.strokeRoundedSearch01,
                  color: Color(0xFF8A909A),
                ),
                scrollPadding: EdgeInsets.zero,
                hintText: 'Search by username, first name, last name',
                hintStyle: const WidgetStatePropertyAll(
                  TextStyle(
                    color: Color(0xFF8A909A),
                    fontWeight: FontWeight.w300,
                    fontSize: 14,
                  ),
                ),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                elevation: const WidgetStatePropertyAll(10),
              ),

              // Sort By Dropdown
              const AutoSizeText(
                'Sort By:',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF8A909A),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    const BoxShadow(
                      color: AppColors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                  border: Border.all(color: AppColors.lightGrey, width: 1),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    value: _selectedSortOption,
                    focusColor: AppColors.primary,
                    iconEnabledColor: AppColors.primary,
                    items: sortOptions.map((option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Text(option),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      // Handle sort option change
                      setState(() {
                        if (value != null) {
                          _selectedSortOption = value;
                        }
                      });
                      if (value != null) {
                        widget.onSortChanged?.call(value);
                      }
                    },
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.black87,
                    ),
                    icon: const Icon(Icons.arrow_drop_down, size: 20),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ), // Sort Direction
              ToggleButtons(
                borderRadius: BorderRadius.circular(8),
                isSelected: [_isAscending, !_isAscending],
                onPressed: (index) {
                  setState(() {
                    _isAscending = index == 0;
                  });
                  widget.onSortDirectionChanged?.call(_isAscending);
                },
                color: AppColors.lightGrey,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: _isAscending ? AppColors.primary : AppColors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: Icon(
                      Icons.arrow_upward,
                      size: 20,
                      color: _isAscending ? AppColors.white : AppColors.grey,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: !_isAscending
                          ? AppColors.primary
                          : AppColors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: Icon(
                      Icons.arrow_downward,
                      size: 20,
                      color: !_isAscending ? AppColors.white : AppColors.grey,
                    ),
                  ),
                ],
              ),

              // Filter Button
              OutlinedButton.icon(
                onPressed: () {},
                icon: const HugeIcon(
                  icon: HugeIcons.strokeRoundedFilter,
                  color: AppColors.grey,
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.grey,
                  side: const BorderSide(color: Color(0xFFD7D8E0)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                ),
                label: const AutoSizeText(
                  'Filter',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.grey,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              // Archive Button
              OutlinedButton.icon(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                ),
                icon: const Icon(Icons.list),
                label: const Text('Archive'),
              ),

              // Validate Button
              ElevatedButton.icon(
                onPressed: () {},

                icon: const Icon(Icons.arrow_forward),
                iconAlignment: IconAlignment.end,
                label: const Text('Validate'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
