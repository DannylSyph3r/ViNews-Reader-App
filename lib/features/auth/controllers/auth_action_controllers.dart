import 'dart:async';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:vinews_news_reader/features/auth/controllers/auth_controllers.dart';
import 'package:vinews_news_reader/features/auth/repository/auth_repository.dart';
import 'package:vinews_news_reader/features/auth/states/login_state.dart';

var logger = Logger();

// User Authentication StateNotifier Class
class AuthNotifier extends StateNotifier<UserAuthenticationState> {
  AuthNotifier(this._authRepository)
      : super(const UserAuthenticationStateInitial()) {
    _authSubscription = _authRepository.authStateChange.listen((user) async {
      if (user != null) {
        logger.i("User is not null");
        // Reload user's data to get the latest email verification status
        await user.reload();
        if (user.emailVerified) {
          logger.i("User email is verified");
          state = UserAuthenticationStateSuccess(user, isEmailVerified: true);
        } else {
          logger.i("User email is not verified");
          state = UserAuthenticationStateSuccess(user, isEmailVerified: false);
        }
      } else {
        logger.i("User is null");
        state = const UserAuthenticationStateInitial();
      }
    });
  }

  final AuthRepository _authRepository;
  StreamSubscription<User?>? _authSubscription;

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  Future<void> userLogin(
      {required String email, required String password}) async {
    state = const UserAuthenticationStateLoading();
    final authResponse = await _authRepository.loginwithEmaillAndPassword(
      email: email,
      password: password,
    );

    state = authResponse.fold(
      (error) => UserAuthenticationStateError(error.toString()),
      (response) {
        if (response != null && !response.emailVerified) {
          // If the user's email is not verified, send verification link
          sendUserEmailVerificationLink();
        }
        return UserAuthenticationStateSuccess(response!,
            isEmailVerified: response.emailVerified);
      },
    );
  }

  Future<void> userSignup({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    state = const UserAuthenticationStateLoading();
    final authResponse = await _authRepository.signUpWithEmailPassword(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
    );

    state = authResponse.fold(
      (error) => UserAuthenticationStateError(error.toString()),
      (response) {
        if (!response.emailVerified) {
          // If the user's email is not verified, send verification link
          sendUserEmailVerificationLink();
        }
        return UserAuthenticationStateSuccess(response,
            isEmailVerified: response.emailVerified);
      },
    );
  }

  Future<void> continueAuthWithGoogle({required bool isSignUp}) async {
    state = const UserAuthenticationStateLoading();
    final authResponse = await _authRepository.continueWithGoogleAuthentication(
      isSignUp: isSignUp,
    );
    state = authResponse.fold(
        (error) => UserAuthenticationStateError(error),
        (response) => UserAuthenticationStateSuccess(response,
            isEmailVerified: response.emailVerified));
  }

  Future<void> sendUserEmailVerificationLink() async {
    state = const UserAuthenticationStateLoading();
    final authResponse = await _authRepository.sendEmailVerificationLink();
    state = authResponse.fold(
        (error) => UserAuthenticationStateError(error.toString()),
        (response) => UserAuthenticationStateSuccess(response!,
            isEmailVerified: response.emailVerified));
  }

  Future<void> checkEmailVerificationStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload();
      if (user.emailVerified) {
        logger.i("User email is verified");
        state = UserAuthenticationStateSuccess(user, isEmailVerified: true);
      } else {
        logger.i("User email is not verified");
        state = UserAuthenticationStateSuccess(user, isEmailVerified: false);
      }
    }
  }

  Future<void> sendUserForgotPasswordLink(
      {required String emailAddress}) async {
    state = const UserAuthenticationStateLoading();
    final authResponse =
        await _authRepository.sendPasswordResetLink(emailAddress: emailAddress);

    state = authResponse.fold(
      (error) => UserAuthenticationStateError(error.toString()),
      (response) => UserAuthenticationStateSuccess(response!,
          isEmailVerified: response.emailVerified),
    );
  }

  Future<void> userSignOut() async {
    state = const UserAuthenticationStateLoading();
    await _authRepository.signOut();
    state = const UserAuthenticationStateInitial();
  }
}

// ButtonStateNotifier class for controlling button activity state until the necessary textfields are occupied
class ActiveButtonStateNotifier extends StateNotifier<bool> {
  ActiveButtonStateNotifier() : super(false);

  void updateButtonState(List<TextEditingController> controllers) {
    final isButtonActive =
        controllers.every((controller) => controller.text.isNotEmpty);
    state = isButtonActive;
  }

  //Reset the button state
  void resetButtonState() {
    state = false;
  }
}

// Email Address Validator State Notifier class for validating correct email addresses for email address textfields
class EmailValidatorStateNotifier extends StateNotifier<bool> {
  EmailValidatorStateNotifier() : super(false);

  void updateEmailValidatorState(TextEditingController controller) {
    final isValidEmail = controller.text.isNotEmpty &&
        EmailValidator.validate(controller.text.trim());
    state = isValidEmail;
  }
}

// Resend Code Timer StateNotifier class to control the activity of a button after 2 minutes where a user can request for a new OTP
class ResendTimerNotifier extends StateNotifier<int> {
  Timer? _timer;

  ResendTimerNotifier() : super(120) {
    startTimer();
  }

  void startTimer() {
    const oneSecond = Duration(seconds: 1);
    _timer?.cancel();
    _timer = Timer.periodic(oneSecond, (timer) {
      if (state > 0) {
        state = state - 1;
      } else {
        _timer?.cancel();
      }
    });
  }

  void resetTimer() {
    state = 120;
    startTimer();
  }

  void pauseTimer() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

// Providers

// final authNotifierProvider =
//     StateNotifierProvider<AuthNotifier, UserAuthenticationState>((ref) {
//   final authNotifier = AuthNotifier(ref.read(authRepositoryProvider));
//   authNotifier._startListeningToAuthStateChanges();
//   return authNotifier;
// });

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, UserAuthenticationState>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return AuthNotifier(authRepository);
});

final showLoginPasswordProvider = StateProvider<bool>((ref) => true);

final showSignUpPasswordProvider = StateProvider<bool>((ref) => true);

final showSignUpConfirmPasswordProvider = StateProvider<bool>((ref) => true);

final activeButtonStateProvider =
    StateNotifierProvider<ActiveButtonStateNotifier, bool>(
        (ref) => ActiveButtonStateNotifier());

final emailValidatorProvider =
    StateNotifierProvider<EmailValidatorStateNotifier, bool>((ref) {
  return EmailValidatorStateNotifier();
});

final resendTimerProvider =
    StateNotifierProvider<ResendTimerNotifier, int>((ref) {
  return ResendTimerNotifier();
});

final pinCompleteProvider = StateProvider<bool>((ref) => false);
