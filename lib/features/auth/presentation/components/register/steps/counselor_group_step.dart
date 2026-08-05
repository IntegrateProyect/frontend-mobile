import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../register_input_field.dart';

class CounselorGroupStep extends StatelessWidget {
  final TextEditingController groupNameController;
  final TextEditingController groupCodeController;
  final Color primaryColor;
  final Color darkTextColor;

  const CounselorGroupStep({
    super.key,
    required this.groupNameController,
    required this.groupCodeController,
    required this.primaryColor,
    required this.darkTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Crea tu primer grupo',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w800,
            color: darkTextColor,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Podrás invitar estudiantes utilizando el código de acceso.',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 13.sp,
            height: 1.4,
          ),
        ),
        SizedBox(height: 26.h),
        RegisterInputField(
          label: 'Nombre del grupo *',
          hint: 'Ej. 6.º A',
          controller: groupNameController,
          icon: Icons.groups_outlined,
          textInputAction: TextInputAction.next,
          capitalization: TextCapitalization.words,
          primaryColor: primaryColor,
        ),
        RegisterInputField(
          label: 'Código de acceso *',
          hint: 'Ej. GRUPO-123',
          controller: groupCodeController,
          icon: Icons.vpn_key_outlined,
          textInputAction: TextInputAction.done,
          capitalization: TextCapitalization.characters,
          primaryColor: primaryColor,
        ),
      ],
    );
  }
}
