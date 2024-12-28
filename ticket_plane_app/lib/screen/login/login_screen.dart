import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticket_plane_app/base/end_point.dart';
import 'package:ticket_plane_app/screen/login/data/user.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _key = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _hasPasswordText = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    passwordController.addListener(() {
      setState(() {
        _hasPasswordText = passwordController.text.isNotEmpty;
      });
    });
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUsername = prefs.getString('username');
    final savedPassword = prefs.getString('password');

    if (savedUsername != null && savedPassword != null) {
      // Bạn có thể kiểm tra thêm với API nếu cần
      print('User is already logged in: \$savedUsername');
      context.go('/home'); // Chuyển tới màn hình chính
    }
  }

  Future<void> _login() async {
    if (_key.currentState!.validate()) {
      final String username = emailController.text.trim();
      final String password = passwordController.text.trim();

      try {
        final response = await http.get(
          Uri.parse(EndPoint.user),
        );

        if (response.statusCode == 200) {
          final List<dynamic> users = jsonDecode(response.body);
          final user = users.firstWhere(
            (u) => u['username'] == username,
            orElse: () => null,
          );

          if (user != null && user['password'] == password) {
            final userData = UserElement.fromJson(user);

            // Lưu thông tin vào SharedPreferences
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('username', username);
            await prefs.setString('password', password);

            print("Login successful: \${userData.toString()}");
            context.go('/home');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content:
                      Text('Tên đăng nhập hoặc mật khẩu không chính xác.')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: \${response.reasonPhrase}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: \$e')),
        );
        print("Error during login: \$e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 46, 24, 240),
                  Color.fromARGB(255, 61, 166, 252),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Main content
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logo or Title
                    const Text(
                      'Welcome Back!',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Log in to continue',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Username field
                    Form(
                      key: _key,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Username',
                              prefixIcon:
                                  const Icon(Icons.person, color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Password field with eye icon
                          TextFormField(
                            controller: passwordController,
                            obscureText: _obscurePassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Password',
                              prefixIcon:
                                  const Icon(Icons.lock, color: Colors.grey),
                              suffixIcon: _hasPasswordText
                                  ? IconButton(
                                      icon: Icon(
                                        _obscurePassword
                                            ? FontAwesomeIcons.eyeSlash
                                            : FontAwesomeIcons.eye,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                    )
                                  : null,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Login button
                    ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.purple,
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 100),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Log In',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Divider
                    Row(
                      children: const [
                        Expanded(
                          child: Divider(
                            color: Colors.white54,
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            'OR',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.white54,
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Social login buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SocialIconButton(
                          icon: FontAwesomeIcons.google,
                          color: Colors.red,
                          onPressed: () {
                            // TODO: Add Google login logic
                          },
                        ),
                        const SizedBox(width: 20),
                        SocialIconButton(
                          icon: FontAwesomeIcons.facebookF,
                          color: Colors.blue,
                          onPressed: () {
                            // TODO: Add Facebook login logic
                          },
                        ),
                        const SizedBox(width: 20),
                        SocialIconButton(
                          icon: FontAwesomeIcons.apple,
                          color: Colors.black,
                          onPressed: () {
                            // TODO: Add Apple login logic
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // Sign up link
                    TextButton(
                      onPressed: () {
                        // TODO: Navigate to sign-up screen
                      },
                      child: RichText(
                        text: TextSpan(
                          text: 'Don’t have an account? ',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                          children: [
                            TextSpan(
                              text: 'Sign Up',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget for social icon buttons
class SocialIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const SocialIconButton({
    super.key,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: color),
      ),
    );
  }
}
