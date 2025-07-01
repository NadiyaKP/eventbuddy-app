import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import '../services/auth_service.dart';
import '../models/user.dart';

class AuthViewModel with ChangeNotifier {
  final AuthService _authService = AuthService();
  
  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isInitializing = true;

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _currentUser != null;
  bool get isInitializing => _isInitializing;

  AuthViewModel() {
    _initialize();
  }

  Future<void> _initialize() async {
    _isInitializing = true;
    notifyListeners();

    try {
      if (_authService.currentFirebaseUser != null) {
        await _loadCurrentUser();
      }
    } catch (e) {
      _errorMessage = 'Failed to initialize authentication';
      print('Initialization error: $e');
    } finally {
      _isInitializing = false;
      notifyListeners();
    }
  }

  Future<void> _loadCurrentUser() async {
    try {
      _currentUser = await _authService.getCurrentUser();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load user data';
      print('Error loading current user: $e');
    }
    notifyListeners();
  }

  Future<bool> signUp(
    String username,
    String email,
    String mobile,
    List<String> interests,
    String password,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Check if email is already registered
      final signInMethods = await FirebaseAuth.FirebaseAuth.instance
          .fetchSignInMethodsForEmail(email);
      
      if (signInMethods.isNotEmpty) {
        _errorMessage = 'An account already exists with this email';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Register the user
      await _authService.registerUser(username, email, mobile, interests, password);
      
      // Load the newly created user
      await _loadCurrentUser();
      
      return true;
    } on FirebaseAuth.FirebaseAuthException catch (e) {
      _errorMessage = _getFirebaseErrorMessage(e.code);
      return false;
    } catch (e) {
      _errorMessage = 'Registration failed: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> quickLogin(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final userCredential = await FirebaseAuth.FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        await _loadCurrentUser();
        return _currentUser != null;
      }
      
      _errorMessage = 'Login failed';
      return false;
    } on FirebaseAuth.FirebaseAuthException catch (e) {
      _errorMessage = _getFirebaseErrorMessage(e.code);
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await FirebaseAuth.FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuth.FirebaseAuthException catch (e) {
      _errorMessage = _getFirebaseErrorMessage(e.code);
      return false;
    } catch (e) {
      _errorMessage = 'Failed to send reset email';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.logout();
      _currentUser = null;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Logout failed';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  String _getFirebaseErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'No account found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'email-already-in-use':
        return 'Email already in use';
      case 'invalid-email':
        return 'Invalid email format';
      case 'weak-password':
        return 'Password is too weak';
      case 'user-disabled':
        return 'Account disabled';
      case 'too-many-requests':
        return 'Too many attempts. Try again later';
      default:
        return 'Authentication failed';
    }
  }
}