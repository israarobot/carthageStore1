import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Reactive variables
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;

  // Getters
  bool get isLoading => _isLoading.value;
  RxString get errorMessage => _errorMessage; // Changed to return RxString
  // String? get errorMessage => _errorMessage.value.isEmpty ? null : _errorMessage.value; // Removed

  // Clear error message
  void clearError() {
    _errorMessage.value = '';
  }

  // Register a user (buyer or seller)
  Future<void> registerUser({
    required String email,
    required String password,
    required String role,
    required bool agreeToTerms,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      _errorMessage.value = "Please fill in both email and password fields.";
      return;
    }

    if (password.length < 6) {
      _errorMessage.value = "Password must be at least 6 characters.";
      return;
    }

    if (!agreeToTerms) {
      _errorMessage.value = "Please agree to the terms and conditions.";
      return;
    }

    _isLoading.value = true;

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final user = userCredential.user;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': email.trim(),
          'role': role,
          'createdAt': Timestamp.now(),
        });

        Get.offNamed('/login'); // Navigate to login
      } else {
        _errorMessage.value = "Failed to create user.";
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          _errorMessage.value = "The email is already in use.";
          break;
        case 'invalid-email':
          _errorMessage.value = "The email is invalid.";
          break;
        case 'weak-password':
          _errorMessage.value = "The password is too weak.";
          break;
        default:
          _errorMessage.value = e.message ?? "Registration failed.";
      }
    } catch (e) {
      _errorMessage.value = "An unexpected error occurred: $e";
    } finally {
      _isLoading.value = false;
    }
  }

  // Login a user
  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      _errorMessage.value = "Please fill in both email and password fields.";
      return;
    }

    _isLoading.value = true;

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final user = userCredential.user;
      if (user != null) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();

        if (!userDoc.exists) {
          await _auth.signOut();
          _errorMessage.value = "User data not found.";
          return;
        }

        final userData = userDoc.data() as Map<String, dynamic>;
        final role = userData['role'] as String?;

        if (role == 'buyer') {
          Get.offNamed('/home');
        } else if (role == 'seller') {
          Get.offNamed('/dashboard-seller');
        } else if (role == 'admin') {
          Get.offNamed('/admin');
        } else {
          await _auth.signOut();
          _errorMessage.value = "You are not authorized to access. Only buyers and sellers are allowed.";
        }
      } else {
        _errorMessage.value = "Login failed.";
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          _errorMessage.value = "No user found with this email.";
          break;
        case 'wrong-password':
          _errorMessage.value = "Incorrect password.";
          break;
        case 'invalid-email':
          _errorMessage.value = "The email is invalid.";
          break;
        default:
          _errorMessage.value = e.message ?? "Login failed.";
      }
    } catch (e) {
      _errorMessage.value = "An unexpected error occurred: $e";
    } finally {
      _isLoading.value = false;
    }
  }
}