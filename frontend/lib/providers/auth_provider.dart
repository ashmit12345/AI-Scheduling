import 'package:flutter/foundation.dart';

import '../data/models/user_model.dart';

/// Possible states the authentication flow can be in. The UI layer switches
/// on this rather than inferring status from nullable fields.
enum AuthStatus { unauthenticated, authenticating, authenticated, error }

/// Centralized authentication state for the app.
///
/// Wrap the app (or the relevant subtree) with:
/// ```dart
/// ChangeNotifierProvider(create: (_) => AuthProvider())
/// ```
/// and read it with `context.watch<AuthProvider>()` /
/// `context.read<AuthProvider>()`.
///
/// NOTE: [login] currently mocks authentication so the frontend is
/// demoable without a backend. Swap the body of [login] for a real API
/// call (e.g. Django REST endpoint per the proposal's tool stack) once
/// the backend is available — the public interface will not need to change.
class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  AuthStatus _status = AuthStatus.unauthenticated;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isAuthenticating => _status == AuthStatus.authenticating;

  /// Attempts to log the user in with the given credentials and role.
  ///
  /// Returns `true` on success. On failure, sets [status] to
  /// [AuthStatus.error] and populates [errorMessage], returning `false`.
  Future<bool> login({
    required String email,
    required String password,
    required UserRole role,
  }) async {
    _status = AuthStatus.authenticating;
    _errorMessage = null;
    notifyListeners();

    try {
      // --- Mock authentication ---
      // Simulates network latency; replace with a real API/service call.
      await Future.delayed(const Duration(milliseconds: 800));

      if (email.trim().isEmpty || !email.contains('@')) {
        throw Exception('Please enter a valid email address.');
      }
      if (password.length < 4) {
        throw Exception('Password must be at least 4 characters.');
      }

      _currentUser = UserModel(
        id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
        name: email.split('@').first,
        email: email.trim(),
        role: role,
      );
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  /// Clears the current session and returns the app to the unauthenticated
  /// state.
  void logout() {
    _currentUser = null;
    _status = AuthStatus.unauthenticated;
    _errorMessage = null;
    notifyListeners();
  }
}
