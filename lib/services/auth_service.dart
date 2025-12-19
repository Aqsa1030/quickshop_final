import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickshop_final/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Login with email and password
  static Future<User> login(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user data after successful login
      final user = userCredential.user!;
      await saveUserToPrefs(user);

      return user;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  // Signup with email and password
  static Future<User> signup(String name, String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update display name
      await userCredential.user!.updateDisplayName(name);

      // Save user data
      await saveUserToPrefs(userCredential.user!);

      return userCredential.user!;
    } catch (e) {
      throw Exception('Signup failed: $e');
    }
  }

  // Save Firebase user to shared preferences
  static Future<void> saveUserToPrefs(User firebaseUser) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', firebaseUser.uid);
    await prefs.setString('user_email', firebaseUser.email ?? '');
    await prefs.setString('user_name', firebaseUser.displayName ?? 'User');
    await prefs.setBool('isLoggedIn', true);
  }

  // Get current user from shared preferences
  static Future<AppUser?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      final id = prefs.getString('user_id') ?? '';
      final email = prefs.getString('user_email') ?? '';
      final name = prefs.getString('user_name') ?? 'User';

      return AppUser(
        id: id,
        name: name,
        email: email,
        joinedAt: DateTime.now(),
      );
    }

    return null;
  }

  // Logout
  static Future<void> logout() async {
    await _auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    await prefs.remove('user_email');
    await prefs.remove('user_name');
    await prefs.setBool('isLoggedIn', false);
  }

  // Check if user is logged in via Firebase
  static bool isFirebaseUserLoggedIn() {
    return _auth.currentUser != null;
  }
}