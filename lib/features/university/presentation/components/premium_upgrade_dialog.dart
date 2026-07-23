import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../screens/checkout_webview.dart';

void showPremiumUpgradeDialog(BuildContext context, {required String feature}) {
  showDialog(
    context: context,
    builder: (dialogCtx) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
      ),
      backgroundColor: Colors.white,
      title: Column(
        children: [
          Icon(
            Icons.workspace_premium_rounded,
            color: const Color(0xFF311B92),
            size: 48.sp,
          ),
          SizedBox(height: 12.h),
          Text(
            '¡Desbloquea Premium! 🚀',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1D1B4B),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Has alcanzado el límite de $feature de tu Plan Básico Universitario.',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 16.h),
            const Text(
              'El Plan Premium te permite:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D1B4B),
              ),
            ),
            SizedBox(height: 8.h),
            _buildFeatureRow('• Carreras publicadas ilimitadas.'),
            _buildFeatureRow('• Anuncios y Convocatorias ilimitados.'),
            _buildFeatureRow('• Publicar eventos en la cartelera interactiva.'),
            _buildFeatureRow('• Sello de verificación azul destacable.'),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actionsPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogCtx),
          child: Text(
            'Cancelar',
            style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w600),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            Navigator.pop(dialogCtx);
            _startUpgradeFlow(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF311B92),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          ),
          child: const Text('Actualizar ahora'),
        ),
      ],
    ),
  );
}

Widget _buildFeatureRow(String text) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 3.h),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 13.sp,
        color: Colors.grey[800],
      ),
    ),
  );
}

void _startUpgradeFlow(BuildContext context) async {
  final authProvider = context.read<AuthProvider>();

  // Mostramos indicador de carga
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => const Center(
      child: CircularProgressIndicator(
        color: Color(0xFF311B92),
      ),
    ),
  );

  final initPoint = await authProvider.createPaymentPreference(199.00); // $199 ARS
  
  if (context.mounted) {
    Navigator.pop(context); // Cierra el indicador de carga
  }

  if (initPoint == null) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? 'Error al iniciar pasarela de pagos'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
    return;
  }

  if (context.mounted) {
    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (ctx) => CheckoutWebView(initPointUrl: initPoint),
      ),
    );

    if (result == 'success' && context.mounted) {
      authProvider.setPremium(true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Felicidades! Tu cuenta ahora es Premium 🌟'),
          backgroundColor: Colors.green,
        ),
      );
    } else if (result == 'pending' && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El pago está pendiente de aprobación.'),
          backgroundColor: Colors.orange,
        ),
      );
    } else if (result == 'failure' && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El pago fue rechazado. Reinténtalo.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }
}
