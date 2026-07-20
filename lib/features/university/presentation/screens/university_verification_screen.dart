import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../providers/university_profile_provider.dart';
import '../components/verification_form.dart';
import '../components/verification_pending_view.dart';

class UniversityVerificationScreen extends StatelessWidget {
  const UniversityVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final profileProvider = context.watch<UniversityProfileProvider>();
    final user = authProvider.user;
    final status = user?.verificationStatus ?? 'UNVERIFIED';

    final bool isLoading = authProvider.isLoading || profileProvider.isLoading;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E1B4B), Color(0xFF311B92)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Hero(
                tag: 'verification_card',
                child: Card(
                  elevation: 20,
                  shadowColor: Colors.black.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.r),
                  ),
                  color: Colors.white.withOpacity(0.98),
                  child: Padding(
                    padding: EdgeInsets.all(32.w),
                    child: status == 'PENDING'
                        ? VerificationPendingView(
                            universityName: user?.universityName,
                            isLoading: isLoading,
                            onRefresh: () => _refreshStatus(context, authProvider),
                          )
                        : VerificationForm(
                            isLoading: isLoading,
                            onSubmit: (cct, rfc) => _submitClaim(context, cct, rfc),
                          ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submitClaim(BuildContext context, String cct, String rfc) async {
    final profileProvider = context.read<UniversityProfileProvider>();
    final authProvider = context.read<AuthProvider>();

    try {
      final res = await profileProvider.claimUniversity(
        cct.trim().toUpperCase(),
        rfc.trim().toUpperCase(),
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res['message'] ?? 'Solicitud enviada correctamente.'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        // Refrescamos el perfil de autenticación para obtener el estado PENDING
        await authProvider.studentProfileExists();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _refreshStatus(BuildContext context, AuthProvider authProvider) async {
    try {
      await authProvider.studentProfileExists();
      if (context.mounted) {
        final status = authProvider.user?.verificationStatus;
        if (status == 'VERIFIED') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('¡Cuenta verificada con éxito!'), backgroundColor: Colors.green),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tu estado sigue en revisión.'), duration: Duration(seconds: 2)),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al refrescar: $e'), backgroundColor: Colors.redAccent),
        );
      }
    }
  }
}
