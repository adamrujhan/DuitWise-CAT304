import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA0E5C7),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),

              // Title
              const Text(
                "DuitWise",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 20),

              // Subtitle
              const Text(
                "Create an account",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "Register with email",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 40),

              // Username
              const _AuthField(hint: "Username"),

              const SizedBox(height: 16),

              // Email
              const _AuthField(hint: "Email"),

              const SizedBox(height: 16),

              // Password
              const _AuthField(hint: "Password", obscure: true),

              const SizedBox(height: 16),

              // Date of birth
              const _AuthField(hint: "Date of birth"),

              const SizedBox(height: 26),

              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    // TODO: Register user
                  },
                  child: const Text(
                    "Continue",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // OR divider
              Row(
                children: const [
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: Colors.black26,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      "or",
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: Colors.black26,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Continue with...
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Continue with",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    Row(
                      children: [
                        // Google Button
                        _SocialIconButton(
                          icon: "assets/icons/google.png",
                          onTap: () {
                            // TODO: Google Sign-In
                          },
                        ),

                        const SizedBox(width: 12),

                        // Apple Button
                        _SocialIconButton(
                          icon: "assets/icons/apple.png",
                          onTap: () {
                            // TODO: Apple Sign-In
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // Terms text
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "By clicking continue, you agree to our Terms of Service\nand Privacy Policy",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}


/// Reusable text field widget
class _AuthField extends StatelessWidget {
  final String hint;
  final bool obscure;

  const _AuthField({
    required this.hint,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 18,
          ),
        ),
      ),
    );
  }
}


/// Reusable social button
class _SocialIconButton extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;

  const _SocialIconButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Image.asset(
          icon,
          width: 28,
          height: 28,
        ),
      ),
    );
  }
}
