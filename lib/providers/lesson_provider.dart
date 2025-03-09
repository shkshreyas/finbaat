import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/lesson_model.dart';

class LessonProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<LessonModel> _lessons = [];
  LessonModel? _currentLesson;
  bool _loading = false;

  List<LessonModel> get lessons => _lessons;
  LessonModel? get currentLesson => _currentLesson;
  bool get loading => _loading;

  Future<void> fetchLessons() async {
    try {
      _loading = true;
      notifyListeners();

      final snapshot =
          await _firestore.collection('lessons').orderBy('order').get();

      _lessons =
          snapshot.docs
              .map((doc) => LessonModel.fromMap(doc.data(), doc.id))
              .toList();
    } catch (e) {
      _lessons = [];
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<LessonModel?> getLessonById(String id) async {
    if (_lessons.isNotEmpty) {
      final lesson = _lessons.firstWhere(
        (lesson) => lesson.id == id,
        orElse: () => _lessons.first,
      );
      _currentLesson = lesson;
      notifyListeners();
      return lesson;
    }

    try {
      _loading = true;
      notifyListeners();

      final doc = await _firestore.collection('lessons').doc(id).get();

      if (doc.exists) {
        final lesson = LessonModel.fromMap(doc.data()!, doc.id);
        _currentLesson = lesson;
        notifyListeners();
        return lesson;
      }

      return null;
    } catch (e) {
      return null;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
