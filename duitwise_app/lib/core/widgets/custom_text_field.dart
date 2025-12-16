import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final bool obscure;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final TextInputAction inputAction;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final BorderSide? borderSide;

  const CustomTextField({
    super.key,
    required this.hint,
    this.obscure = false,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.inputAction = TextInputAction.done,
    this.validator,
    this.onChanged,
    this.borderSide,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        textInputAction: inputAction,
        maxLines: 1,
        onChanged: onChanged,
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
          enabledBorder: borderSide == null
              ? InputBorder.none
              : OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: borderSide!,
                ),

          focusedBorder: borderSide == null
              ? InputBorder.none
              : OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: borderSide!.copyWith(width: 2),
                ),
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
