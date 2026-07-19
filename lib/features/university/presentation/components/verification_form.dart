import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../providers/university_provider.dart';

class VerificationForm extends StatefulWidget {
  final bool isLoading;
  final Function(String cct, String rfc) onSubmit;

  const VerificationForm({
    super.key,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  State<VerificationForm> createState() => _VerificationFormState();
}

class _VerificationFormState extends State<VerificationForm> {
  final _formKey = GlobalKey<FormState>();
  final _cctController = TextEditingController();
  final _rfcController = TextEditingController();

  @override
  void dispose() {
    _cctController.dispose();
    _rfcController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF311B92);
    const Color accentColor = Color(0xFF1D1B4B);

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.account_balance_rounded, size: 64.sp, color: primaryColor),
          SizedBox(height: 16.h),
          Text(
            'Verificación Institucional',
            style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w900, color: accentColor),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            'Ingresa el CCT de Chiapas y el RFC de tu institución para certificar tu cuenta.',
            style: TextStyle(fontSize: 13.sp, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32.h),
          _buildTextField(
            controller: _cctController,
            label: 'CCT (Clave de Centro de Trabajo)',
            hint: 'Ej: 07USU0012A',
            icon: Icons.pin_drop_rounded,
            validator: (value) {
              if (value == null || value.trim().isEmpty) return 'El CCT es obligatorio';
              if (value.trim().length != 10) return 'Debe tener 10 caracteres';
              return null;
            },
          ),
          SizedBox(height: 16.h),
          _buildTextField(
            controller: _rfcController,
            label: 'RFC Moral',
            hint: 'Ej: UNA741018XXX',
            icon: Icons.branding_watermark_rounded,
            validator: (value) {
              if (value == null || value.trim().isEmpty) return 'El RFC es obligatorio';
              return null;
            },
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
              onPressed: widget.isLoading ? null : () {
                if (_formKey.currentState!.validate()) {
                  widget.onSubmit(_cctController.text, _rfcController.text);
                }
              },
              child: widget.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Enviar Solicitud', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      textCapitalization: TextCapitalization.characters,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 20.sp),
        filled: true,
        fillColor: const Color(0xFFF8F9FE),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none),
      ),
    );
  }
}
