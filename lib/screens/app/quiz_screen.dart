import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../../providers/quiz_provider.dart';
import '../../models/quiz_model.dart';
import '../../routes.dart';

class QuizScreen extends StatefulWidget {
  final String quizId;

  const QuizScreen({Key? key, required this.quizId}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  bool _isLoading = true;
  QuizModel? _quiz;
  int _currentQuestionIndex = 0;
  List<int> _selectedAnswers = [];
  int _timeRemaining = 0;
  Timer? _timer;
  bool _quizCompleted = false;

  @override
  void initState() {
    super.initState();
    _loadQuiz();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadQuiz() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final quizProvider = Provider.of<QuizProvider>(context, listen: false);
      final quiz = await quizProvider.getQuizById(widget.quizId);

      if (mounted && quiz != null) {
        setState(() {
          _quiz = quiz;
          _selectedAnswers = List.filled(quiz.questions.length, -1);
          _timeRemaining = quiz.timeLimit * 60; // Convert to seconds
          _isLoading = false;
        });

        _startTimer();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading quiz: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_timeRemaining > 0) {
            _timeRemaining--;
          } else {
            _timer?.cancel();
            _submitQuiz();
          }
        });
      }
    });
  }

  void _selectAnswer(int answerIndex) {
    setState(() {
      _selectedAnswers[_currentQuestionIndex] = answerIndex;
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < (_quiz?.questions.length ?? 0) - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      _submitQuiz();
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  Future<void> _submitQuiz() async {
    if (_quizCompleted || _quiz == null) return;

    setState(() {
      _quizCompleted = true;
    });

    _timer?.cancel();

    // Calculate score
    int correctAnswers = 0;
    for (int i = 0; i < _quiz!.questions.length; i++) {
      if (_selectedAnswers[i] == _quiz!.questions[i].correctOptionIndex) {
        correctAnswers++;
      }
    }

    final score = (correctAnswers / _quiz!.questions.length * 100).round();
    final passed = score >= _quiz!.passingScore;

    // Save result
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    await quizProvider.submitQuizResult(
      QuizResult(
        id: '',
        quizId: _quiz!.id,
        userId: '', // This will be set in the provider
        score: score,
        totalQuestions: _quiz!.questions.length,
        passed: passed,
        completedAt: DateTime.now(),
      ),
    );

    if (mounted) {
      Navigator.of(context).pushReplacementNamed(
        AppRoutes.quizResult,
        arguments: {
          'score': score,
          'totalQuestions': _quiz!.questions.length,
          'passed': passed,
          'quizId': _quiz!.id,
        },
      );
    }
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_quiz == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Quiz not found',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    final currentQuestion = _quiz!.questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(_quiz!.title),
        actions: [
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _timeRemaining < 60 ? Colors.red : Colors.blue,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.timer, color: Colors.white, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    _formatTime(_timeRemaining),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          // Progress indicator
          LinearProgressIndicator(
            value: (_currentQuestionIndex + 1) / _quiz!.questions.length,
            minHeight: 8,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Question ${_currentQuestionIndex + 1} of ${_quiz!.questions.length}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  'Score to pass: ${_quiz!.passingScore}%',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),

          // Question content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentQuestion.question,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Answer options
                  ...List.generate(
                    currentQuestion.options.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color:
                                _selectedAnswers[_currentQuestionIndex] == index
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey.shade300,
                            width: 2,
                          ),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap:
                              _quizCompleted
                                  ? null
                                  : () => _selectAnswer(index),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color:
                                        _selectedAnswers[_currentQuestionIndex] ==
                                                index
                                            ? Theme.of(context).primaryColor
                                            : Colors.grey.shade200,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child:
                                        _selectedAnswers[_currentQuestionIndex] ==
                                                index
                                            ? const Icon(
                                              Icons.check,
                                              color: Colors.white,
                                              size: 18,
                                            )
                                            : Text(
                                              String.fromCharCode(
                                                65 + index,
                                              ), // A, B, C, D...
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    currentQuestion.options[index],
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Navigation buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed:
                      _currentQuestionIndex > 0 && !_quizCompleted
                          ? _previousQuestion
                          : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.arrow_back),
                      SizedBox(width: 8),
                      Text('Previous'),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed:
                      _quizCompleted
                          ? null
                          : _selectedAnswers[_currentQuestionIndex] == -1
                          ? null
                          : _currentQuestionIndex == _quiz!.questions.length - 1
                          ? _submitQuiz
                          : _nextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _currentQuestionIndex == _quiz!.questions.length - 1
                            ? Colors.green
                            : Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        _currentQuestionIndex == _quiz!.questions.length - 1
                            ? 'Submit'
                            : 'Next',
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        _currentQuestionIndex == _quiz!.questions.length - 1
                            ? Icons.check_circle
                            : Icons.arrow_forward,
                      ),
                    ],
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
