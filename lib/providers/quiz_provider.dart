import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/quiz_model.dart';

class QuizProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<QuizModel> _quizzes = [];
  QuizModel? _currentQuiz;
  List<QuizResult> _quizResults = [];
  bool _loading = false;

  List<QuizModel> get quizzes => _quizzes;
  QuizModel? get currentQuiz => _currentQuiz;
  List<QuizResult> get quizResults => _quizResults;
  bool get loading => _loading;

  Future<void> fetchQuizzesByLesson(String lessonId) async {
    if (lessonId.isEmpty) return;

    try {
      _loading = true;
      notifyListeners();

      final snapshot =
          await _firestore
              .collection('quizzes')
              .where('lessonId', isEqualTo: lessonId)
              .get();

      _quizzes =
          snapshot.docs
              .map((doc) => QuizModel.fromMap(doc.data(), doc.id))
              .toList();
    } catch (e) {
      _quizzes = [];
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<QuizModel?> getQuizById(String id) async {
    try {
      _loading = true;
      notifyListeners();

      final doc = await _firestore.collection('quizzes').doc(id).get();

      if (doc.exists) {
        _currentQuiz = QuizModel.fromMap(doc.data()!, doc.id);
        notifyListeners();
        return _currentQuiz;
      }

      return null;
    } catch (e) {
      return null;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUserResults() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      _loading = true;
      notifyListeners();

      final snapshot =
          await _firestore
              .collection('quizResults')
              .where('userId', isEqualTo: user.uid)
              .orderBy('completedAt', descending: true)
              .get();

      _quizResults =
          snapshot.docs
              .map((doc) => QuizResult.fromMap(doc.data(), doc.id))
              .toList();
    } catch (e) {
      _quizResults = [];
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> submitQuizResult(QuizResult result) async {
    try {
      _loading = true;
      notifyListeners();

      await _firestore.collection('quizResults').add(result.toMap());
      await fetchUserResults();
    } catch (e) {
      // Handle error
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  bool hasUserPassedQuiz(String quizId) {
    return _quizResults.any(
      (result) => result.quizId == quizId && result.passed,
    );
  }
}
