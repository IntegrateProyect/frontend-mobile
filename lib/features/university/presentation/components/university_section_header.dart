import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UniversitySectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const UniversitySectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    const Color _primaryColor = Color(0xFF311B92);
    const Color _accentColor = Color(0xFF1D1B4B);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 15.sp, 
            fontWeight: FontWeight.w900, 
            color: _accentColor,
            letterSpacing: -0.4,
          ),
        ),
        if (actionLabel != null)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              foregroundColor: _primaryColor,
            ),
            child: Text(actionLabel!, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11.sp)),
          ),
      ],
    );
  }
}
