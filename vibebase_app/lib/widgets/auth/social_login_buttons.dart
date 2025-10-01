import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';

// Platform detection helper that works on web
bool get isIOS {
  if (kIsWeb) return false;
  try {
    // Only import dart:io on non-web platforms
    return const bool.fromEnvironment('dart.library.io') && 
           Theme.of(WidgetsBinding.instance.platformDispatcher.views.first as BuildContext).platform == TargetPlatform.iOS;
  } catch (e) {
    return false;
  }
}

class SocialLoginButtons extends ConsumerWidget {
  final bool showGoogle;
  final bool showApple;

  const SocialLoginButtons({
    super.key,
    this.showGoogle = true,
    this.showApple = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Check platform in a web-safe way
    final platformIsIOS = !kIsWeb && Theme.of(context).platform == TargetPlatform.iOS;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showGoogle) ...[
          _GoogleSignInButton(onPressed: () => _signInWithGoogle(context, ref)),
          const SizedBox(height: 12),
        ],
        if (showApple && platformIsIOS) ...[
          _AppleSignInButton(onPressed: () => _signInWithApple(context, ref)),
        ],
      ],
    );
  }

  Future<void> _signInWithGoogle(BuildContext context, WidgetRef ref) async {
    try {
      final authService = ref.read(authServiceProvider);
      await authService.signInWithGoogle();
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signed in with Google!')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _signInWithApple(BuildContext context, WidgetRef ref) async {
    try {
      final authService = ref.read(authServiceProvider);
      await authService.signInWithApple();
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signed in with Apple!')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}

class _GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _GoogleSignInButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Image.asset(
        'assets/images/google_logo.png',
        height: 24,
        width: 24,
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.g_mobiledata, size: 24),
      ),
      label: const Text('Continue with Google'),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.black87,
      ),
    );
  }
}

class _AppleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _AppleSignInButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        Icons.apple,
        color: isDark ? Colors.white : Colors.black,
      ),
      label: const Text('Continue with Apple'),
      style: OutlinedButton.styleFrom(
        foregroundColor: isDark ? Colors.white : Colors.black87,
      ),
    );
  }
}
