import 'dart:async';

import 'package:docdoc/core/services/shared_preferences_singelton.dart';
import 'package:docdoc/features/auth/presentation/views/sign_in_view.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Handles session cleanup when a login-email change is confirmed via deep link.
class AuthEmailChangeSessionServiceSessionService {
  AuthEmailChangeSessionServiceSessionService._();

  static final AuthEmailChangeSessionServiceSessionService instance =
      AuthEmailChangeSessionServiceSessionService._();

  static const String pendingEmailChangeKey = 'pending_email_change';
  static const String pendingEmailChangeTargetKey =
      'pending_email_change_target';
  static const String showEmailChangeSignInMessageKey =
      'show_email_change_sign_in_message';

  StreamSubscription<AuthState>? _authSubscription;

  Future<void> markPendingEmailChange(String newEmail) async {
    await Prefs.setBool(pendingEmailChangeKey, true);
    await Prefs.setString(
      pendingEmailChangeTargetKey,
      newEmail.trim().toLowerCase(),
    );
  }

  Future<void> clearPendingEmailChange() async {
    await Prefs.remove(pendingEmailChangeKey);
    await Prefs.remove(pendingEmailChangeTargetKey);
  }

  /// Listens for a successful email-change deep link, then signs the user out.
  void listenForEmailChangeConfirmation(
      GlobalKey<NavigatorState> navigatorKey) {
    _authSubscription?.cancel();
    _authSubscription =
        Supabase.instance.client.auth.onAuthStateChange.listen((authState) {
      unawaited(
        _handleAuthStateForEmailChange(authState, navigatorKey),
      );
    });
  }

  Future<void> _handleAuthStateForEmailChange(
    AuthState authState,
    GlobalKey<NavigatorState> navigatorKey,
  ) async {
    if (authState.event != AuthChangeEvent.signedIn) return;
    if (!(Prefs.getBool(pendingEmailChangeKey) ?? false)) return;

    final targetEmail = Prefs.getString(pendingEmailChangeTargetKey);
    final userEmail = authState.session?.user.email?.trim().toLowerCase();
    if (targetEmail == null ||
        targetEmail.isEmpty ||
        userEmail == null ||
        userEmail != targetEmail) {
      return;
    }

    await signOutAfterEmailChange(navigatorKey);
  }

  Future<void> signOutAfterEmailChange(
    GlobalKey<NavigatorState> navigatorKey,
  ) async {
    await clearPendingEmailChange();
    await Prefs.remove('api_token');

    try {
      await Supabase.instance.client.auth.signOut();
    } catch (_) {
      // Session may already be invalid; still route to sign-in.
    }

    await Prefs.setBool(showEmailChangeSignInMessageKey, true);

    final navigator = navigatorKey.currentState;
    if (navigator == null) return;

    navigator.pushNamedAndRemoveUntil(
      SignInView.routeName,
      (_) => false,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = navigatorKey.currentContext;
      if (context == null) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Email updated successfully. Sign in with your new email address.',
          ),
        ),
      );
      unawaited(Prefs.remove(showEmailChangeSignInMessageKey));
    });
  }

  void dispose() {
    _authSubscription?.cancel();
    _authSubscription = null;
  }
}
