class UserModel {
  final String uid;
  final String email;
  final String? name;
  final String? photoUrl;

  UserModel({
    required this.uid,
    required this.email,
    this.name,
    this.photoUrl,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      email: map['email'] ?? '',
      name: map['name'],
      photoUrl: map['photoUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
    };
  }
}
