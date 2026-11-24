import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/auth_repository.dart';
import '../../domain/models/user_model.dart';

class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final UserModel? user;
  final String? error;
  final String? verificationId;
  final String? pendingPhone;

  const AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.user,
    this.error,
    this.verificationId,
    this.pendingPhone,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    UserModel? user,
    String? error,
    String? verificationId,
    String? pendingPhone,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error,
      verificationId: verificationId ?? this.verificationId,
      pendingPhone: pendingPhone ?? this.pendingPhone,
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _repo;

  AuthController(this._repo) : super(const AuthState()) {
    checkSavedSession();
  }

  Future<void> checkSavedSession() async {
    final user = await _repo.getSavedUser();
    if (user != null) {
      state = state.copyWith(isAuthenticated: true, user: user);
    }
  }

  Future<void> sendOtp(String phoneNumber) async {
    state = state.copyWith(isLoading: true, error: null, pendingPhone: phoneNumber);
    try {
      final success = await _repo.sendOtp(phoneNumber);
      if (success) {
        state = state.copyWith(
          isLoading: false,
          verificationId: 'v_id_${DateTime.now().millisecondsSinceEpoch}',
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to send verification code. Please check your number.',
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> verifyOtp(String otp, {String? fullName}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final phone = state.pendingPhone ?? '+919876543210';
      final user = await _repo.verifyOtp(
        phoneNumber: phone,
        otp: otp,
        fullName: fullName,
      );

      if (user != null) {
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          user: user,
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Invalid verification code. Please try again.',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<void> logout() async {
    await _repo.signOut();
    state = const AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthController(repo);
});
