import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterInputField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final IconData icon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization capitalization;
  final bool obscureText;
  final VoidCallback? onToggleVisibility;
  final ValueChanged<String>? onSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final Color primaryColor;

  const RegisterInputField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    required this.icon,
    this.keyboardType,
    this.textInputAction,
    this.capitalization = TextCapitalization.none,
    this.obscureText = false,
    this.onToggleVisibility,
    this.onSubmitted,
    this.inputFormatters,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 18.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8.h),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            textCapitalization: capitalization,
            obscureText: obscureText,
            autocorrect: false,
            enableSuggestions: !obscureText,
            onFieldSubmitted: onSubmitted,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: Icon(
                icon,
                color: Colors.grey[600],
                size: 21.sp,
              ),
              suffixIcon: onToggleVisibility == null
                  ? null
                  : IconButton(
                      onPressed: onToggleVisibility,
                      icon: Icon(
                        obscureText ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                        color: Colors.grey[700],
                      ),
                    ),
              filled: true,
              fillColor: const Color(0xFFF9FAFB),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 18.h,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide(
                  color: primaryColor,
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
