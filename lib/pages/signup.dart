import 'package:flutter/material.dart';
import '../pages/login.dart';
import '../services/firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool isLoading = false;

  final auth _authService = auth();

  Future<void> signupSubmitEvent() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (_formKey.currentState!.validate()) {
      try {
        setState(() => isLoading = true);
        
        await _authService.createUserWithEmailAndPassword(email: email, password: password);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Registered Successfully'),
            duration: Duration(seconds: 2),
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
        );
      } on FirebaseAuthException catch (e) {
        String message;
        switch (e.code) {
          case 'email-already-in-use':
            message = 'Email already exists!';
            break;
          case 'invalid-email':
            message = 'Invalid email format!';
            break;
          case 'weak-password':
            message = 'Password is too weak!';
            break;
          default:
            message = 'Something went wrong: ${e.message}';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(message),
            duration: const Duration(seconds: 2),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Error: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 2, 9, 34),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 50),
                Center(
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(text: 'Create, ', style: TextStyle(color: Colors.yellow)),
                        TextSpan(text: 'New Account!', style: TextStyle(color: Colors.white)),
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
                    children: [
                      _buildTextField(_emailController, 'Enter your email', Icons.email),
                      const SizedBox(height: 30),
                      _buildTextField(
                        _passwordController, 
                        'Enter your password', 
                        Icons.password, 
                        obscureText: true
                      ),
                      const SizedBox(height: 30),
                      _buildTextField(
                        _confirmPasswordController,
                        'Confirm password',
                        Icons.lock,
                        obscureText: true,
                        validator: (val) {
                          if (val == null || val.isEmpty) return 'Please confirm your password';
                          if (val != _passwordController.text) return 'Passwords do not match';
                          return null;
                        },
                      ),
                      const SizedBox(height: 58),
                      ElevatedButton(
                        onPressed: isLoading ? null : signupSubmitEvent,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Sign Up'),
                      ),
                      const SizedBox(height: 19),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Have an account? ", style: TextStyle(color: Colors.white70, fontSize: 16)),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const Login()),
                              );
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(color: Colors.yellow, fontSize: 16, fontWeight: FontWeight.bold),
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

  Widget _buildTextField(
      TextEditingController controller, String hint, IconData icon,
      {bool obscureText = false, String? Function(String?)? validator}) {
    return Container(
      width: 330,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white),
          filled: true,
          fillColor: const Color.fromARGB(255, 50, 52, 52),
          prefixIcon: Icon(icon, color: Colors.white),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        ),
        validator: validator ??
            (val) {
              if (val == null || val.isEmpty) return 'Please enter your ${hint.toLowerCase()}';
              if (obscureText && val.length < 6) return 'Password must be at least 6 characters';
              return null;
            },
      ),
    );
  }
}