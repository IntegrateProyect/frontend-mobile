import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../providers/student_home_provider.dart';
import 'student_ui_colors.dart';

Future<bool> requireStudentGroup({
  required BuildContext context,
}) async {
  final provider = context.read<StudentHomeProvider>();

  if (provider.hasGroup) return true;

  final joined = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const _StudentGroupRequiredDialog(),
  );

  return joined == true;
}

class _StudentGroupRequiredDialog extends StatefulWidget {
  const _StudentGroupRequiredDialog();

  @override
  State<_StudentGroupRequiredDialog> createState() =>
      _StudentGroupRequiredDialogState();
}

class _StudentGroupRequiredDialogState
    extends State<_StudentGroupRequiredDialog> {
  final TextEditingController _codeController = TextEditingController();

  bool _isJoining = false;
  String? _errorMessage;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _joinGroup() async {
    final code = _codeController.text.trim();

    if (code.isEmpty) {
      setState(() {
        _errorMessage = 'Escribe el código de acceso del grupo.';
      });
      return;
    }

    setState(() {
      _isJoining = true;
      _errorMessage = null;
    });

    final provider = context.read<StudentHomeProvider>();
    final success = await provider.joinGroupByCode(code);

    if (!mounted) return;

    if (success) {
      Navigator.pop(context, true);
      return;
    }

    setState(() {
      _isJoining = false;
      _errorMessage =
          provider.errorMessage ?? 'No fue posible unirte al grupo.';
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor =
    isDark ? Colors.white : StudentUiColors.darkText;
    final secondaryColor =
    isDark ? Colors.grey.shade400 : Colors.grey.shade600;

    return AlertDialog(
      backgroundColor: isDark ? const Color(0xFF1A1B2E) : Colors.white,
      surfaceTintColor:
      isDark ? const Color(0xFF1A1B2E) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(26.r),
      ),
      contentPadding: EdgeInsets.all(22.w),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 76.w,
              height: 76.w,
              decoration: BoxDecoration(
                color: StudentUiColors.primary.withOpacity(0.10),
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Icon(
                Icons.groups_2_rounded,
                color: StudentUiColors.primary,
                size: 40.sp,
              ),
            ),
            SizedBox(height: 18.h),
            Text(
              'Únete a un grupo',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: titleColor,
                fontSize: 21.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 9.h),
            Text(
              'Para utilizar todas las funciones de Oriéntate+, primero '
                  'debes unirte al grupo asignado por tu orientador.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: secondaryColor,
                fontSize: 12.sp,
                height: 1.4,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 20.h),
            TextField(
              controller: _codeController,
              enabled: !_isJoining,
              textCapitalization: TextCapitalization.none,
              autocorrect: false,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _joinGroup(),
              decoration: InputDecoration(
                labelText: 'Código del grupo',
                hintText: 'Ejemplo: yedaniA',
                prefixIcon: const Icon(Icons.vpn_key_outlined),
                errorText: _errorMessage,
              ),
            ),
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton.icon(
                onPressed: _isJoining ? null : _joinGroup,
                icon: _isJoining
                    ? SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Icon(Icons.group_add_rounded),
                label: Text(
                  _isJoining ? 'Uniéndote...' : 'Unirme al grupo',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: StudentUiColors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor:
                  StudentUiColors.primary.withOpacity(0.6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.h),
            TextButton(
              onPressed:
              _isJoining ? null : () => Navigator.pop(context, false),
              child: const Text('Ahora no'),
            ),
          ],
        ),
      ),
    );
  }
}