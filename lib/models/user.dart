class AppUser {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? address;
  final String? profileImage;
  final DateTime joinedAt;
  final List<String> wishlist;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.address,
    this.profileImage,
    required this.joinedAt,
    this.wishlist = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'profileImage': profileImage,
      'joinedAt': joinedAt.toIso8601String(),
      'wishlist': wishlist,
    };
  }
}