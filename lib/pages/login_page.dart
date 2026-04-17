import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:plexi_play/exceptions/auth_exception.dart';
import 'package:plexi_play/exceptions/custom_exception.dart';
import 'package:plexi_play/supabase/auth_controller.dart';
import '../theme/neo_theme.dart';
import '../widgets/neo_button.dart';
import '../widgets/neo_text_field.dart';
import 'feed_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  bool _isLogin = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: NeoTheme.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(
              color: NeoTheme.black,
              width: NeoTheme.borderThick,
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
          content: Text(
            message,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(foregroundColor: NeoTheme.black),
              child: const Text(
                'OK',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleAuth() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final username = _usernameController.text.trim();

    if (!_isLogin) {
      if (username.isEmpty) {
        _showErrorDialog(
          'Missing Username',
          'Please enter a username to sign up.',
        );
        return;
      }
      if (username.length < 3) {
        _showErrorDialog(
          'Invalid Username',
          'Username must be at least 3 characters.',
        );
        return;
      }
    }

    if (email.isEmpty) {
      _showErrorDialog('Missing Email', 'Please enter your email address.');
      return;
    }

    final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    if (!emailRegex.hasMatch(email)) {
      _showErrorDialog('Invalid Email', 'Please enter a valid email address.');
      return;
    }

    if (password.isEmpty) {
      _showErrorDialog('Missing Password', 'Please enter your password.');
      return;
    }
    if (password.length < 6) {
      _showErrorDialog(
        'Invalid Password',
        'Password must be at least 6 characters.',
      );
      return;
    }

    ref
        .read(authControllerProvider.notifier)
        .signUpOrLogin(
          email: email,
          password: password,
          username: username,
          isLogin: _isLogin,
        );
  }

  @override
  void initState() {
    _grantNotificationPermission();
    super.initState();
  }

  void _grantNotificationPermission() async {
    final hasNotificationPermission = await Permission.notification.isGranted;
    if (!hasNotificationPermission) {
      final status = await Permission.notification.request();
      log('Notification permission status: $status');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    ref.listen(authControllerProvider, (previous, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error.toString()),
            backgroundColor: Colors.red,
          ),
        );
      } else if (next is AsyncData) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const FeedPage()),
        );
      }
    });
    return Scaffold(
      backgroundColor: NeoTheme.cream,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo/Name
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: NeoTheme.boxDecoration(
                    color: NeoTheme.white,
                    borderRadius: 16,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: NeoTheme.black,
                            width: NeoTheme.borderThick,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          color: NeoTheme.black,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'PlexiPlay',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),

                // Login Card
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 400),
                  decoration: NeoTheme.boxDecoration(color: NeoTheme.white),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        top: -16,
                        right: -10,
                        child: Transform.rotate(
                          angle: 0.05,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: NeoTheme.green,
                              border: Border.all(
                                color: NeoTheme.black,
                                width: NeoTheme.borderThick,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                  color: NeoTheme.black,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                            child: const Text(
                              'WELCOME',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: NeoTheme.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              _isLogin ? 'Welcome Back!' : 'Join PlexiPlay',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _isLogin
                                  ? 'Enter your details below to log in to your account!'
                                  : 'Enter your details below to create a brand new account!',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 32),
                            if (!_isLogin) ...[
                              NeoTextField(
                                controller: _usernameController,
                                labelText: 'Username',
                                hintText: 'johndoe',
                              ),
                              const SizedBox(height: 20),
                            ],
                            NeoTextField(
                              controller: _emailController,
                              labelText: 'Email',
                              hintText: 'john@example.com',
                            ),
                            const SizedBox(height: 20),
                            NeoTextField(
                              controller: _passwordController,
                              labelText: 'Password',
                              hintText: '••••••••',
                              obscureText: true,
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: NeoButton(
                                text: _isLogin ? 'LOG IN' : 'SIGN UP',
                                backgroundColor: NeoTheme.yellow,
                                onPressed: authState.isLoading
                                    ? null
                                    : _handleAuth,
                                isLoading: authState.isLoading,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isLogin = !_isLogin;
                                });
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: NeoTheme.black,
                              ),
                              child: Text(
                                _isLogin
                                    ? "Don't have an account? Sign Up"
                                    : "Already have an account? Log In",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
