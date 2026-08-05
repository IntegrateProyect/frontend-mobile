import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../register_input_field.dart';

class CounselorProfileStep extends StatelessWidget {
  final TextEditingController ageController;
  final TextEditingController instController;
  final TextEditingController specController;
  final Color primaryColor;
  final Color darkTextColor;

  const CounselorProfileStep({
    super.key,
    required this.ageController,
    required this.instController,
    required this.specController,
    required this.primaryColor,
    required this.darkTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Datos profesionales',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w800,
            color: darkTextColor,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Completa la información relacionada con tu trabajo como orientador.',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 13.sp,
            height: 1.4,
          ),
        ),
        SizedBox(height: 26.h),
        RegisterInputField(
          label: 'Edad *',
          hint: 'Ej. 35',
          controller: ageController,
          icon: Icons.calendar_today_outlined,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          primaryColor: primaryColor,
        ),
        RegisterInputField(
          label: 'Institución *',
          hint: 'Ej. Preparatoria del Sur',
          controller: instController,
          icon: Icons.business_outlined,
          textInputAction: TextInputAction.next,
          capitalization: TextCapitalization.words,
          primaryColor: primaryColor,
        ),
        RegisterInputField(
          label: 'Especialidad *',
          hint: 'Ej. Orientación vocacional',
          controller: specController,
          icon: Icons.badge_outlined,
          textInputAction: TextInputAction.done,
          capitalization: TextCapitalization.sentences,
          primaryColor: primaryColor,
        ),
      ],
    );
  }
}
