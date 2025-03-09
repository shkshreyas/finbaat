import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/lesson_provider.dart';
import '../../providers/progress_provider.dart';
import '../../routes.dart';

class LessonsScreen extends StatefulWidget {
  const LessonsScreen({Key? key}) : super(key: key);

  @override
  State<LessonsScreen> createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
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

  @override
  Widget build(BuildContext context) {
    final lessonProvider = Provider.of<LessonProvider>(context);
    final progressProvider = Provider.of<ProgressProvider>(context);
    final lessons = lessonProvider.lessons;

    return Scaffold(
      appBar: AppBar(title: const Text('All Lessons')),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : lessons.isEmpty
                ? const Center(child: Text('No lessons available'))
                : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: lessons.length,
                  itemBuilder: (context, index) {
                    final lesson = lessons[index];
                    final progress = progressProvider.getLessonProgress(
                      lesson.id,
                    );
                    final isCompleted = progressProvider.isLessonCompleted(
                      lesson.id,
                    );

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            AppRoutes.lessonDetail,
                            arguments: {'id': lesson.id},
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    child: Text('${index + 1}'),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      lesson.title,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  if (isCompleted)
                                    const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                lesson.description,
                                style: Theme.of(context).textTheme.bodyMedium,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: 16,
                                    color:
                                        Theme.of(
                                          context,
                                        ).textTheme.bodySmall?.color,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${lesson.durationMinutes} min',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${(progress * 100).toStringAsFixed(0)}%',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              LinearProgressIndicator(
                                value: progress,
                                minHeight: 4,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
