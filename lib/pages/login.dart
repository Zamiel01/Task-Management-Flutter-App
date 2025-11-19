import 'package:flutter/material.dart';
import '../pages/signup.dart';
import 'package:page_transition/page_transition.dart';
import '../services/firebase.dart';   // <-- your firebase auth service
import './home.dart';
import 'package:local_auth/local_auth.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  final LocalAuthentication _localAuth = LocalAuthentication();

  final auth _auth = auth();   // <-- INSTANCE OF YOUR FIREBASE AUTH SERVICE

  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;

    try {
      authenticated = await _localAuth.authenticate(
        localizedReason: 'Scan your fingerprint to access Home',
        biometricOnly: true,
      );
    } catch (e) {
      print("Fingerprint error: $e");
    }

    if (authenticated) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Authentication failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ---------------------------------------------------
  // 🔥 NEW: Firebase Login Logic
  // ---------------------------------------------------
  Future<void> loginSubmitEvent() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      await _auth.signInWithemailAndPassword(
        email: email,
        password: password,
      );

      // If we reach here → Login successful
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );

    } catch (e) {
      print("Firebase login error: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Invalid email or password'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(31, 8, 106, 225),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 50),

                // Title
                Center(
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(text: 'Hello, ', style: TextStyle(color: Colors.yellow)),
                        TextSpan(text: 'Welcome Back!', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                const CircleAvatar(
                  backgroundImage: AssetImage('assets/login.png'),
                  radius: 75,
                ),

                const SizedBox(height: 40),

                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      // Email Input
                      Container(
                        width: 330,
                        child: TextFormField(
                          controller: _emailController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Enter your email',
                            hintStyle: const TextStyle(color: Colors.white60),
                            filled: true,
                            fillColor: const Color.fromARGB(255, 50, 52, 52),
                            prefixIcon: const Icon(Icons.email, color: Colors.white),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Please enter your email';
                            return null;
                          },
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Password Input
                      Container(
                        width: 330,
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Enter your password',
                            hintStyle: const TextStyle(color: Colors.white60),
                            filled: true,
                            fillColor: const Color.fromARGB(255, 50, 52, 52),
                            prefixIcon: const Icon(Icons.password, color: Colors.white),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Please enter your password';
                            if (value.length < 6) return 'Password must be at least 6 characters';
                            return null;
                          },
                        ),
                      ),

                      const SizedBox(height: 20),
                      const Text('OR', style: TextStyle(color: Colors.white)),
                      const SizedBox(height: 20),

                      IconButton(
                        icon: const Icon(Icons.fingerprint, color: Colors.white, size: 50),
                        onPressed: _authenticateWithBiometrics,
                      ),

                      const SizedBox(height: 30),

                      // Login Button
                      ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() => isLoading = true);
                                  await loginSubmitEvent();
                                  setState(() => isLoading = false);
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text("Login", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),

                      const SizedBox(height: 20),

                      // Signup Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account? ", style: TextStyle(color: Colors.white70)),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: SignupScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
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
