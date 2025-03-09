import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/lesson_model.dart';
import '../../providers/lesson_provider.dart';
import '../../providers/progress_provider.dart';
import '../../providers/flashcard_provider.dart';
import '../../providers/quiz_provider.dart';
import '../../routes.dart';
import '../../theme/app_theme.dart';

class LessonDetailScreen extends StatefulWidget {
  final String lessonId;

  const LessonDetailScreen({Key? key, required this.lessonId})
    : super(key: key);

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  bool _isLoading = true;
  LessonModel? _lesson;
  double _progress = 0.0;
  final ScrollController _scrollController = ScrollController();
  bool _hasFlashcards = false;
  bool _hasQuizzes = false;

  @override
  void initState() {
    super.initState();
    _fetchLessonDetails();
    _setupScrollListener();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (!_isLoading && _lesson != null) {
        final maxScroll = _scrollController.position.maxScrollExtent;
        final currentScroll = _scrollController.position.pixels;
        final viewportHeight = _scrollController.position.viewportDimension;

        // Calculate progress based on scroll position
        final calculatedProgress =
            (currentScroll / (maxScroll + viewportHeight));
        final newProgress = calculatedProgress.clamp(0.0, 1.0);

        if ((newProgress - _progress).abs() > 0.01) {
          setState(() {
            _progress = newProgress;
          });

          // Update progress in database if significant change
          if ((newProgress - _progress).abs() > 0.05) {
            _updateProgress(newProgress);
          }
        }
      }
    });
  }

  Future<void> _fetchLessonDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch lesson
      final lessonProvider = Provider.of<LessonProvider>(
        context,
        listen: false,
      );
      final lesson = await lessonProvider.getLessonById(widget.lessonId);

      // Get current progress
      final progressProvider = Provider.of<ProgressProvider>(
        context,
        listen: false,
      );
      final progress = progressProvider.getLessonProgress(widget.lessonId);

      // Check if flashcards exist
      final flashcardProvider = Provider.of<FlashcardProvider>(
        context,
        listen: false,
      );
      await flashcardProvider.fetchFlashcardsByLesson(widget.lessonId);

      // Check if quizzes exist
      final quizProvider = Provider.of<QuizProvider>(context, listen: false);
      await quizProvider.fetchQuizzesByLesson(widget.lessonId);

      if (mounted) {
        setState(() {
          _lesson = lesson;
          _progress = progress;
          _hasFlashcards = flashcardProvider.flashcards.isNotEmpty;
          _hasQuizzes = quizProvider.quizzes.isNotEmpty;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading lesson: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _updateProgress(double newProgress) async {
    if (_lesson == null) return;

    final progressProvider = Provider.of<ProgressProvider>(
      context,
      listen: false,
    );
    final isCompleted = newProgress >= 0.9;

    await progressProvider.updateProgress(
      _lesson!.id,
      newProgress,
      isCompleted,
    );
  }

  void _markAsCompleted() async {
    if (_lesson == null) return;

    final progressProvider = Provider.of<ProgressProvider>(
      context,
      listen: false,
    );
    await progressProvider.updateProgress(_lesson!.id, 1.0, true);

    if (mounted) {
      setState(() {
        _progress = 1.0;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lesson marked as completed!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _openFlashcards() {
    Navigator.of(
      context,
    ).pushNamed(AppRoutes.flashcards, arguments: {'lessonId': widget.lessonId});
  }

  void _openQuiz() {
    // Use the first quiz from the lesson if available
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    if (quizProvider.quizzes.isNotEmpty) {
      Navigator.of(context).pushNamed(
        AppRoutes.quiz,
        arguments: {'quizId': quizProvider.quizzes.first.id},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLoading ? 'Loading...' : _lesson?.title ?? 'Lesson'),
        actions: [
          if (!_isLoading && _lesson != null && _progress < 1.0)
            IconButton(
              icon: const Icon(Icons.check_circle_outline),
              onPressed: _markAsCompleted,
              tooltip: 'Mark as completed',
            ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _lesson == null
              ? const Center(child: Text('Lesson not found'))
              : Column(
                children: [
                  // Progress indicator
                  LinearProgressIndicator(value: _progress, minHeight: 6),

                  // Lesson content
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Learning tools section
                          if (_hasFlashcards || _hasQuizzes)
                            Card(
                              margin: const EdgeInsets.only(bottom: 24),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Learning Tools',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        if (_hasFlashcards)
                                          InkWell(
                                            onTap: _openFlashcards,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          12,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Colors.blue.shade100,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                    child: const Icon(
                                                      Icons.style,
                                                      size: 32,
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  const Text('Flashcards'),
                                                ],
                                              ),
                                            ),
                                          ),
                                        if (_hasQuizzes)
                                          InkWell(
                                            onTap: _openQuiz,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          12,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Colors.green.shade100,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                    child: const Icon(
                                                      Icons.quiz,
                                                      size: 32,
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  const Text('Quiz'),
                                                ],
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          // Lesson header
                          if (_lesson!.imageUrl != null &&
                              _lesson!.imageUrl!.isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                _lesson!.imageUrl!,
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 200,
                                    color: Colors.grey.shade200,
                                    child: const Center(
                                      child: Icon(Icons.image_not_supported),
                                    ),
                                  );
                                },
                              ),
                            ),
                          const SizedBox(height: 16),

                          // Title and description
                          Text(
                            _lesson!.title,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _lesson!.description,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),

                          // Tags
                          if (_lesson!.tags.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children:
                                  _lesson!.tags.map((tag) {
                                    return Chip(
                                      label: Text(tag),
                                      backgroundColor: Theme.of(
                                        context,
                                      ).primaryColor.withOpacity(0.1),
                                    );
                                  }).toList(),
                            ),
                          ],

                          const Divider(height: 32),

                          // Lesson content
                          Text(
                            _lesson!.content,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      bottomNavigationBar:
          !_isLoading && _lesson != null
              ? BottomAppBar(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${(_progress * 100).toStringAsFixed(0)}% completed',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      ElevatedButton(
                        onPressed: _progress >= 1.0 ? null : _markAsCompleted,
                        child: const Text('Complete Lesson'),
                      ),
                    ],
                  ),
                ),
              )
              : null,
    );
  }
}
