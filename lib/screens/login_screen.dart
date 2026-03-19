import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:retailsaas/locator.dart';
import 'package:retailsaas/screens/product_selection_screen.dart';
import 'package:retailsaas/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final success = await getIt<AuthService>().login(
      _usernameCtrl.text.trim(),
      _passwordCtrl.text.trim(),
    );

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ProductSelectionScreen(),
          ),
        );
      } else {
        setState(() {
          _errorMessage = 'Invalid username or password';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7), // Light grey background
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.storefront, color: Colors.white),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Welcome back',
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Please enter your details to sign in.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Inputs
              TextField(
                controller: _usernameCtrl,
                keyboardType: TextInputType.text,
                maxLength: 10,
                decoration: InputDecoration(
                  labelText: '10-Digit Phone Number',
                  hintText: 'Enter your phone number',
                  counterText: '',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  prefixIcon: const Icon(Icons.phone_android),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordCtrl,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
                onSubmitted: (_) => _login(),
              ),

              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    _errorMessage!,
                    style: GoogleFonts.inter(
                      color: Colors.red,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

              const SizedBox(height: 32),

              // Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Sign in',
                          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
