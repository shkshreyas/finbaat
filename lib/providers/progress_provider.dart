import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/progress_model.dart';
import '../models/user_model.dart';

class ProgressProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<ProgressModel> _progressList = [];
  bool _loading = false;

  Map<String, double> _lessonProgress = {};
  List<String> _completedLessons = [];
  List<Map<String, dynamic>> _quizResults = [];

  // New fields for enhanced profile stats
  int _currentStreak = 0;
  int _longestStreak = 0;
  int _weeklyStudyTimeMinutes = 0;
  int _totalStudyTimeMinutes = 0;

  List<ProgressModel> get progressList => _progressList;
  bool get loading => _loading;
  Map<String, double> get lessonProgress => _lessonProgress;
  List<String> get completedLessons => _completedLessons;
  List<Map<String, dynamic>> get quizResults => _quizResults;

  // Getters for enhanced profile stats
  int get currentStreak => _currentStreak;
  int get longestStreak => _longestStreak;
  int get weeklyStudyTimeMinutes => _weeklyStudyTimeMinutes;
  int get totalStudyTimeMinutes => _totalStudyTimeMinutes;
  int get completedLessonsCount => _completedLessons.length;
  int get totalLessonsCount => 5; // Default to 5 lessons in our dataset
  int get completedQuizzesCount => _quizResults.length;
  double get averageQuizScore {
    if (_quizResults.isEmpty) return 0;
    double totalScore = 0;
    for (var result in _quizResults) {
      totalScore += (result['score'] as num).toDouble();
    }
    return totalScore / _quizResults.length;
  }

  Future<void> fetchUserProgress() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      // Fetch lesson progress
      final progressSnapshot =
          await _firestore
              .collection('progress')
              .where('userId', isEqualTo: user.uid)
              .get();

      if (progressSnapshot.docs.isNotEmpty) {
        final progressDoc = progressSnapshot.docs.first;
        final data = progressDoc.data();

        // Update lesson progress
        if (data.containsKey('lessonProgress')) {
          _lessonProgress = Map<String, double>.from(data['lessonProgress']);
        }

        // Update completed lessons
        if (data.containsKey('completedLessons')) {
          _completedLessons = List<String>.from(data['completedLessons']);
        }

        // Update streak data
        _currentStreak = data['currentStreak'] ?? 0;
        _longestStreak = data['longestStreak'] ?? 0;

        // Update study time
        _weeklyStudyTimeMinutes = data['weeklyStudyTimeMinutes'] ?? 0;
        _totalStudyTimeMinutes = data['totalStudyTimeMinutes'] ?? 0;
      }

      // Fetch quiz results
      final quizResultsSnapshot =
          await _firestore
              .collection('quizResults')
              .where('userId', isEqualTo: user.uid)
              .get();

      _quizResults = quizResultsSnapshot.docs.map((doc) => doc.data()).toList();

      notifyListeners();
    } catch (e) {
      print('Error fetching user progress: $e');
    }
  }

  Future<void> updateProgress(
    String lessonId,
    double progressPercentage,
    bool isCompleted,
  ) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final progressData = {
        'lessonId': lessonId,
        'progressPercentage': progressPercentage,
        'isCompleted': isCompleted,
        'lastUpdated': FieldValue.serverTimestamp(),
      };

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('progress')
          .doc(lessonId)
          .set(progressData, SetOptions(merge: true));

      await fetchUserProgress();
    } catch (e) {
      // Handle error
    }
  }

  double getLessonProgress(String lessonId) {
    return _lessonProgress[lessonId] ?? 0.0;
  }

  bool isLessonCompleted(String lessonId) {
    return _completedLessons.contains(lessonId);
  }

  Future<void> updateLessonProgress(String lessonId, double progress) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      // Update local state
      _lessonProgress[lessonId] = progress;

      // Mark lesson as completed if progress is 100%
      if (progress >= 1.0 && !_completedLessons.contains(lessonId)) {
        _completedLessons.add(lessonId);
      }

      // Update weekly study time (assume 5 minutes of study time for this update)
      _weeklyStudyTimeMinutes += 5;
      _totalStudyTimeMinutes += 5;

      // Update streak
      _currentStreak = _currentStreak + 1;
      if (_currentStreak > _longestStreak) {
        _longestStreak = _currentStreak;
      }

      notifyListeners();

      // Update Firestore
      final progressSnapshot =
          await _firestore
              .collection('progress')
              .where('userId', isEqualTo: user.uid)
              .get();

      if (progressSnapshot.docs.isEmpty) {
        // Create new progress document
        await _firestore.collection('progress').add({
          'userId': user.uid,
          'lessonProgress': _lessonProgress,
          'completedLessons': _completedLessons,
          'currentStreak': _currentStreak,
          'longestStreak': _longestStreak,
          'weeklyStudyTimeMinutes': _weeklyStudyTimeMinutes,
          'totalStudyTimeMinutes': _totalStudyTimeMinutes,
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      } else {
        // Update existing progress document
        await _firestore
            .collection('progress')
            .doc(progressSnapshot.docs.first.id)
            .update({
              'lessonProgress': _lessonProgress,
              'completedLessons': _completedLessons,
              'currentStreak': _currentStreak,
              'longestStreak': _longestStreak,
              'weeklyStudyTimeMinutes': _weeklyStudyTimeMinutes,
              'totalStudyTimeMinutes': _totalStudyTimeMinutes,
              'lastUpdated': FieldValue.serverTimestamp(),
            });
      }
    } catch (e) {
      print('Error updating lesson progress: $e');
    }
  }

  Future<void> saveQuizResult(
    String quizId,
    int score,
    int totalQuestions,
    bool passed,
  ) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final quizResult = {
        'userId': user.uid,
        'quizId': quizId,
        'score': score,
        'totalQuestions': totalQuestions,
        'passed': passed,
        'completedAt': FieldValue.serverTimestamp(),
      };

      // Add to local state
      _quizResults.add(quizResult);

      // Add weekly study time (15 minutes for completing a quiz)
      _weeklyStudyTimeMinutes += 15;
      _totalStudyTimeMinutes += 15;

      notifyListeners();

      // Save to Firestore
      await _firestore.collection('quizResults').add(quizResult);

      // Update user progress document with updated study times
      final progressSnapshot =
          await _firestore
              .collection('progress')
              .where('userId', isEqualTo: user.uid)
              .get();

      if (progressSnapshot.docs.isNotEmpty) {
        await _firestore
            .collection('progress')
            .doc(progressSnapshot.docs.first.id)
            .update({
              'weeklyStudyTimeMinutes': _weeklyStudyTimeMinutes,
              'totalStudyTimeMinutes': _totalStudyTimeMinutes,
            });
      }
    } catch (e) {
      print('Error saving quiz result: $e');
    }
  }
}
