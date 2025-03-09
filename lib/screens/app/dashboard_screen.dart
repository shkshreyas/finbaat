import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/lesson_provider.dart';
import '../../providers/progress_provider.dart';
import '../../routes.dart';
import '../../data/upload_data.dart';
import 'lessons_screen.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  bool _isLoading = false;
  bool _showDataUploadButton = false; // For admin/development purposes only

  @override
  void initState() {
    super.initState();
    _loadData();

    // Show data upload button when in development mode
    // This should be removed in production
    _checkForDevelopmentMode();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final lessonProvider = Provider.of<LessonProvider>(
        context,
        listen: false,
      );
      final progressProvider = Provider.of<ProgressProvider>(
        context,
        listen: false,
      );

      await lessonProvider.fetchLessons();
      await progressProvider.fetchUserProgress();
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _checkForDevelopmentMode() async {
    // Check if current user email contains 'admin' or 'dev'
    // This is just a simple check for demonstration
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;
    if (user != null &&
        (user.email.contains('admin') || user.email.contains('dev'))) {
      setState(() {
        _showDataUploadButton = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      _buildHomeScreen(),
      const LessonsScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Lessons',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildHomeScreen() {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48),
                // Header
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome to FinPath',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Your journey to financial literacy',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: const Icon(
                        Icons.account_balance,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                // Admin button (only shown in development)
                if (_showDataUploadButton) ...[
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const DataUploadScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.upload),
                    label: const Text('Upload Financial Education Data'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.purple,
                    ),
                  ),
                ],

                const SizedBox(height: 24),
                // Continue learning card
                _buildContinueLearningCard(),
                const SizedBox(height: 24),
                // Quick links
                Text(
                  'Quick Links',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildQuickLinks(),
                const SizedBox(height: 24),
                // Financial topics
                Text(
                  'Financial Topics',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildTopicGrid(),
              ],
            ),
          ),
        );
  }

  Widget _buildContinueLearningCard() {
    final lessonProvider = Provider.of<LessonProvider>(context);
    final progressProvider = Provider.of<ProgressProvider>(context);

    if (lessonProvider.lessons.isEmpty) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: Text('No lessons available. Check back later!')),
        ),
      );
    }

    // Find the first incomplete lesson
    final incompleteLesson = lessonProvider.lessons.firstWhere(
      (lesson) => !progressProvider.isLessonCompleted(lesson.id),
      orElse: () => lessonProvider.lessons.first,
    );

    final progress = progressProvider.getLessonProgress(incompleteLesson.id);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.of(context).pushNamed(
            AppRoutes.lessonDetail,
            arguments: {'id': incompleteLesson.id},
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      progress > 0 ? Icons.play_circle_fill : Icons.school,
                      color: Theme.of(context).primaryColor,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          progress > 0 ? 'Continue Learning' : 'Start Learning',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          incompleteLesson.title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
              ),
              const SizedBox(height: 8),
              Text(
                '${(progress * 100).toInt()}% complete',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickLinks() {
    return Row(
      children: [
        Expanded(
          child: _buildQuickLinkCard('Lessons', Icons.library_books, () {
            setState(() {
              _selectedIndex = 1;
            });
          }),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildQuickLinkCard('Flashcards', Icons.style, () {
            // Handle navigation to flashcards
            final lessonProvider = Provider.of<LessonProvider>(
              context,
              listen: false,
            );
            if (lessonProvider.lessons.isNotEmpty) {
              Navigator.of(context).pushNamed(
                AppRoutes.flashcards,
                arguments: {'lessonId': lessonProvider.lessons.first.id},
              );
            }
          }),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildQuickLinkCard('Quizzes', Icons.quiz, () {
            // Handle navigation to quizzes
            final lessonProvider = Provider.of<LessonProvider>(
              context,
              listen: false,
            );
            if (lessonProvider.lessons.isNotEmpty) {
              Navigator.of(context).pushNamed(
                AppRoutes.lessonDetail,
                arguments: {'id': lessonProvider.lessons.first.id},
              );
            }
          }),
        ),
      ],
    );
  }

  Widget _buildQuickLinkCard(String title, IconData icon, VoidCallback onTap) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Theme.of(context).primaryColor, size: 32),
              const SizedBox(height: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopicGrid() {
    final topics = [
      {
        'title': 'Budgeting',
        'icon': Icons.account_balance_wallet,
        'color': Colors.blue,
      },
      {'title': 'Saving', 'icon': Icons.savings, 'color': Colors.green},
      {'title': 'Investing', 'icon': Icons.trending_up, 'color': Colors.purple},
      {'title': 'Debt', 'icon': Icons.money_off, 'color': Colors.red},
    ];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.4,
      ),
      itemCount: topics.length,
      itemBuilder: (context, index) {
        final topic = topics[index];
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              // Filter lessons by topic
              // For now, just navigate to lessons
              setState(() {
                _selectedIndex = 1;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    topic['icon'] as IconData,
                    color: topic['color'] as Color,
                    size: 36,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    topic['title'] as String,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
