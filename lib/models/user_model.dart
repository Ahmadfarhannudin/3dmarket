class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String avatarUrl;
  final bool blocked;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.role = 'Kreator',
    this.avatarUrl = '',
    this.blocked = false,
  });
}
