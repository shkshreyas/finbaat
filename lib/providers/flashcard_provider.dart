import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/flashcard_model.dart';

class FlashcardProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<FlashcardModel> _flashcards = [];
  bool _loading = false;
  String _currentLessonId = '';

  List<FlashcardModel> get flashcards => _flashcards;
  bool get loading => _loading;
  String get currentLessonId => _currentLessonId;

  Future<void> fetchFlashcardsByLesson(String lessonId) async {
    if (lessonId.isEmpty) return;

    try {
      _loading = true;
      _currentLessonId = lessonId;
      notifyListeners();

      final snapshot =
          await _firestore
              .collection('flashcards')
              .where('lessonId', isEqualTo: lessonId)
              .orderBy('order')
              .get();

      _flashcards =
          snapshot.docs
              .map((doc) => FlashcardModel.fromMap(doc.data(), doc.id))
              .toList();
    } catch (e) {
      _flashcards = [];
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> addFlashcard(FlashcardModel flashcard) async {
    try {
      _loading = true;
      notifyListeners();

      await _firestore.collection('flashcards').add(flashcard.toMap());
      await fetchFlashcardsByLesson(_currentLessonId);
    } catch (e) {
      // Handle error
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> updateFlashcard(FlashcardModel flashcard) async {
    try {
      _loading = true;
      notifyListeners();

      await _firestore
          .collection('flashcards')
          .doc(flashcard.id)
          .update(flashcard.toMap());

      await fetchFlashcardsByLesson(_currentLessonId);
    } catch (e) {
      // Handle error
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> deleteFlashcard(String flashcardId) async {
    try {
      _loading = true;
      notifyListeners();

      await _firestore.collection('flashcards').doc(flashcardId).delete();
      await fetchFlashcardsByLesson(_currentLessonId);
    } catch (e) {
      // Handle error
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
