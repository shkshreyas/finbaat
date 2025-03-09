class LessonModel {
  final String id;
  final String title;
  final String description;
  final String content;
  final int order;
  final List<String> tags;
  final int durationMinutes;
  final String? imageUrl;

  LessonModel({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.order,
    required this.tags,
    required this.durationMinutes,
    this.imageUrl,
  });

  factory LessonModel.fromMap(Map<String, dynamic> map, String id) {
    return LessonModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      content: map['content'] ?? '',
      order: map['order'] ?? 0,
      tags: List<String>.from(map['tags'] ?? []),
      durationMinutes: map['durationMinutes'] ?? 15,
      imageUrl: map['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'content': content,
      'order': order,
      'tags': tags,
      'durationMinutes': durationMinutes,
      'imageUrl': imageUrl,
    };
  }
}
