import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';

class VerificationPendingView extends StatelessWidget {
  final String? universityName;
  final bool isLoading;
  final VoidCallback onRefresh;

  const VerificationPendingView({
    super.key,
    this.universityName,
    required this.isLoading,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF311B92);
    const Color accentColor = Color(0xFF1D1B4B);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.orange[50],
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.hourglass_empty_rounded, size: 64.sp, color: Colors.orangeAccent),
        ),
        SizedBox(height: 24.h),
        Text(
          'Solicitud en Revisión',
          style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w900, color: accentColor),
        ),
        SizedBox(height: 12.h),
        Text(
          universityName != null ? 'Institución: $universityName' : 'Vinculación de CCT enviada.',
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: primaryColor),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 12.h),
        Text(
          'Un administrador está auditando tus credenciales con SEP y SAT. Este proceso puede tardar un momento.',
          style: TextStyle(fontSize: 13.sp, color: Colors.grey[600], height: 1.5),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 32.h),
        SizedBox(
          width: double.infinity,
          height: 56.h,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
              elevation: 0,
            ),
            onPressed: isLoading ? null : onRefresh,
            child: isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Refrescar Estado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
        SizedBox(height: 16.h),
        TextButton(
          onPressed: () async {
            await context.read<AuthProvider>().logout();
          },
          child: const Text('Cerrar Sesión', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
