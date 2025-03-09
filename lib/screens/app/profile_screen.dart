import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/progress_provider.dart';
import '../../routes.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final progressProvider = Provider.of<ProgressProvider>(
        context,
        listen: false,
      );
      await progressProvider.fetchUserProgress();
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final progressProvider = Provider.of<ProgressProvider>(context);
    final user = authProvider.user;

    // Calculate stats
    final completedLessons = progressProvider.completedLessonsCount;
    final totalLessons = progressProvider.totalLessonsCount;
    final completedQuizzes = progressProvider.completedQuizzesCount;
    final averageScore = progressProvider.averageQuizScore;

    return Scaffold(
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // App Bar with User Info
                  SliverAppBar(
                    expandedHeight: 260,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Theme.of(context).primaryColor,
                              Theme.of(context).primaryColor.withOpacity(0.7),
                            ],
                          ),
                        ),
                        child: SafeArea(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 16),
                              // Profile picture
                              Hero(
                                tag: 'profile_avatar',
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 3,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundColor: Colors.white.withOpacity(
                                      0.9,
                                    ),
                                    child: Text(
                                      user?.name?.isNotEmpty == true
                                          ? user!.name![0].toUpperCase()
                                          : 'U',
                                      style: TextStyle(
                                        fontSize: 40,
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              // User name
                              Text(
                                user?.name ?? 'User',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              // User email
                              Text(
                                user?.email ?? '',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Tab Bar
                  SliverPersistentHeader(
                    delegate: _SliverAppBarDelegate(
                      TabBar(
                        controller: _tabController,
                        labelColor: Theme.of(context).primaryColor,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Theme.of(context).primaryColor,
                        tabs: const [
                          Tab(text: 'STATS'),
                          Tab(text: 'SETTINGS'),
                          Tab(text: 'ABOUT'),
                        ],
                      ),
                    ),
                    pinned: true,
                  ),

                  // Tab Bar View
                  SliverFillRemaining(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // STATS Tab
                        AnimationLimiter(
                          child: ListView(
                            padding: const EdgeInsets.all(16),
                            children: AnimationConfiguration.toStaggeredList(
                              duration: const Duration(milliseconds: 375),
                              childAnimationBuilder:
                                  (widget) => SlideAnimation(
                                    horizontalOffset: 50.0,
                                    child: FadeInAnimation(child: widget),
                                  ),
                              children: [
                                const SizedBox(height: 8),
                                // Learning Progress Card
                                _buildStatsCard(context, 'Learning Progress', [
                                  _buildStatItem(
                                    context,
                                    'Completed Lessons',
                                    '$completedLessons/$totalLessons',
                                    Icons.book,
                                  ),
                                  _buildStatItem(
                                    context,
                                    'Quiz Average',
                                    '${averageScore.toStringAsFixed(1)}%',
                                    Icons.quiz,
                                  ),
                                  _buildStatItem(
                                    context,
                                    'Quizzes Completed',
                                    '$completedQuizzes',
                                    Icons.check_circle,
                                  ),
                                ]),
                                const SizedBox(height: 16),
                                // Progress Streak Card
                                _buildStatsCard(
                                  context,
                                  'Streaks & Achievements',
                                  [
                                    _buildStatItem(
                                      context,
                                      'Current Streak',
                                      '${progressProvider.currentStreak} days',
                                      Icons.local_fire_department,
                                      iconColor: Colors.orange,
                                    ),
                                    _buildStatItem(
                                      context,
                                      'Longest Streak',
                                      '${progressProvider.longestStreak} days',
                                      Icons.emoji_events,
                                      iconColor: Colors.amber,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                // Study Time Card
                                _buildStatsCard(context, 'Study Time', [
                                  _buildStatItem(
                                    context,
                                    'This Week',
                                    '${progressProvider.weeklyStudyTimeMinutes} min',
                                    Icons.access_time,
                                  ),
                                  _buildStatItem(
                                    context,
                                    'Total',
                                    '${progressProvider.totalStudyTimeMinutes} min',
                                    Icons.hourglass_bottom,
                                  ),
                                ]),
                              ],
                            ),
                          ),
                        ),

                        // SETTINGS Tab
                        AnimationLimiter(
                          child: ListView(
                            padding: const EdgeInsets.all(16),
                            children: AnimationConfiguration.toStaggeredList(
                              duration: const Duration(milliseconds: 375),
                              childAnimationBuilder:
                                  (widget) => SlideAnimation(
                                    horizontalOffset: 50.0,
                                    child: FadeInAnimation(child: widget),
                                  ),
                              children: [
                                const SizedBox(height: 8),
                                _buildSettingCard(context, 'Appearance', [
                                  // Dark mode toggle
                                  ListTile(
                                    leading: Icon(
                                      themeProvider.isDarkMode
                                          ? Icons.dark_mode
                                          : Icons.light_mode,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    title: const Text('Dark Mode'),
                                    trailing: Switch(
                                      activeColor:
                                          Theme.of(context).primaryColor,
                                      value: themeProvider.isDarkMode,
                                      onChanged: (value) {
                                        themeProvider.setThemeMode(
                                          value
                                              ? ThemeMode.dark
                                              : ThemeMode.light,
                                        );
                                      },
                                    ),
                                  ),
                                ]),
                                const SizedBox(height: 16),
                                _buildSettingCard(context, 'Notifications', [
                                  // Notifications toggle
                                  SwitchListTile(
                                    secondary: Icon(
                                      Icons.notifications,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    title: const Text('Enable Notifications'),
                                    subtitle: const Text(
                                      'Get reminders and updates',
                                    ),
                                    value: true, // Connect to actual provider
                                    onChanged: (value) {
                                      // Implement notification settings
                                    },
                                  ),
                                  // Daily reminder time
                                  ListTile(
                                    leading: Icon(
                                      Icons.alarm,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    title: const Text('Daily Reminder'),
                                    subtitle: const Text('8:00 PM'),
                                    trailing: const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                    ),
                                    onTap: () {
                                      // Show time picker
                                    },
                                  ),
                                ]),
                                const SizedBox(height: 16),
                                _buildSettingCard(context, 'Account', [
                                  // Edit profile
                                  ListTile(
                                    leading: Icon(
                                      Icons.edit,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    title: const Text('Edit Profile'),
                                    trailing: const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                    ),
                                    onTap: () {
                                      // Navigate to edit profile
                                    },
                                  ),
                                  // Logout
                                  ListTile(
                                    leading: const Icon(
                                      Icons.logout,
                                      color: Colors.red,
                                    ),
                                    title: const Text(
                                      'Logout',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    onTap: () async {
                                      final confirmed = await showDialog<bool>(
                                        context: context,
                                        builder:
                                            (context) => AlertDialog(
                                              title: const Text('Logout'),
                                              content: const Text(
                                                'Are you sure you want to logout?',
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed:
                                                      () => Navigator.of(
                                                        context,
                                                      ).pop(false),
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed:
                                                      () => Navigator.of(
                                                        context,
                                                      ).pop(true),
                                                  child: const Text('Logout'),
                                                ),
                                              ],
                                            ),
                                      );

                                      if (confirmed == true &&
                                          context.mounted) {
                                        await authProvider.signOut();
                                        if (context.mounted) {
                                          Navigator.of(
                                            context,
                                          ).pushReplacementNamed(
                                            AppRoutes.login,
                                          );
                                        }
                                      }
                                    },
                                  ),
                                ]),
                              ],
                            ),
                          ),
                        ),

                        // ABOUT Tab
                        AnimationLimiter(
                          child: ListView(
                            padding: const EdgeInsets.all(16),
                            children: AnimationConfiguration.toStaggeredList(
                              duration: const Duration(milliseconds: 375),
                              childAnimationBuilder:
                                  (widget) => SlideAnimation(
                                    horizontalOffset: 50.0,
                                    child: FadeInAnimation(child: widget),
                                  ),
                              children: [
                                const SizedBox(height: 8),
                                _buildAboutCard(
                                  context,
                                  'About FinPath',
                                  'FinPath is a financial education app designed to help you learn the fundamentals of personal finance. Our mission is to make financial literacy accessible to everyone.',
                                  Icons.account_balance,
                                ),
                                const SizedBox(height: 16),
                                _buildSettingCard(context, 'App Information', [
                                  ListTile(
                                    leading: Icon(
                                      Icons.info_outline,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    title: const Text('Version'),
                                    trailing: const Text('1.0.0'),
                                  ),
                                  const Divider(height: 1),
                                  ListTile(
                                    leading: Icon(
                                      Icons.policy_outlined,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    title: const Text('Privacy Policy'),
                                    trailing: const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                    ),
                                    onTap: () {
                                      // Navigate to privacy policy
                                    },
                                  ),
                                  const Divider(height: 1),
                                  ListTile(
                                    leading: Icon(
                                      Icons.description_outlined,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    title: const Text('Terms of Service'),
                                    trailing: const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                    ),
                                    onTap: () {
                                      // Navigate to terms of service
                                    },
                                  ),
                                  const Divider(height: 1),
                                  ListTile(
                                    leading: Icon(
                                      Icons.contact_support_outlined,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    title: const Text('Contact Support'),
                                    trailing: const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                    ),
                                    onTap: () {
                                      // Navigate to contact support
                                    },
                                  ),
                                ]),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }

  Widget _buildStatsCard(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSettingCard(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(height: 1),
          ...children,
        ],
      ),
    );
  }

  Widget _buildAboutCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Theme.of(context).primaryColor),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    Color? iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: iconColor ?? Theme.of(context).primaryColor,
            size: 28,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
