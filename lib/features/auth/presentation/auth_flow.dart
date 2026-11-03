import 'package:flutter/material.dart';

import 'screens/recovery_screens.dart';
import 'screens/sign_in_screen.dart';
import 'screens/sign_up_screen.dart';

enum AuthStep { signIn, signUp, forgotPassword, otp, resetPassword, success }

class AuthFlow extends StatefulWidget {
  const AuthFlow({required this.onSignedIn, super.key});

  final VoidCallback onSignedIn;

  @override
  State<AuthFlow> createState() => _AuthFlowState();
}

class _AuthFlowState extends State<AuthFlow> {
  AuthStep _step = AuthStep.signIn;
  String _recoveryDestination = '';

  void _goTo(AuthStep step) => setState(() => _step = step);

  @override
  Widget build(BuildContext context) {
    final screen = switch (_step) {
      AuthStep.signIn => SignInScreen(
        onCreateAccount: () => _goTo(AuthStep.signUp),
        onForgotPassword: () => _goTo(AuthStep.forgotPassword),
        onSignedIn: widget.onSignedIn,
      ),
      AuthStep.signUp => SignUpScreen(
        onBack: () => _goTo(AuthStep.signIn),
        onSignIn: () => _goTo(AuthStep.signIn),
        onRegistered: () => _goTo(AuthStep.success),
      ),
      AuthStep.forgotPassword => ForgotPasswordScreen(
        onBack: () => _goTo(AuthStep.signIn),
        onCodeSent: (destination) {
          _recoveryDestination = destination;
          _goTo(AuthStep.otp);
        },
      ),
      AuthStep.otp => OtpVerificationScreen(
        destination: _recoveryDestination,
        onBack: () => _goTo(AuthStep.forgotPassword),
        onVerified: () => _goTo(AuthStep.resetPassword),
      ),
      AuthStep.resetPassword => ResetPasswordScreen(
        onBack: () => _goTo(AuthStep.otp),
        onPasswordReset: () => _goTo(AuthStep.signIn),
      ),
      AuthStep.success => SignUpSuccessScreen(
        onContinue: () => _goTo(AuthStep.signIn),
      ),
    };

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: KeyedSubtree(key: ValueKey(_step), child: screen),
    );
  }
}
