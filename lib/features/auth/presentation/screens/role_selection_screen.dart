import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../components/role_card.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String? _selectedRole;

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      backgroundColor: Colors.white,
      appBar: PlatformAppBar(
        leading: PlatformIconButton(
          icon: Icon(Icons.chevron_left, color: Colors.black, size: 28.sp),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Crea tu cuenta',
          style: TextStyle(color: Colors.black, fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                children: [
                  Text(
                    '¿Cómo usarás la app?',
                    style: TextStyle(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1D1B4B),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 14.sp, color: Colors.grey[600], height: 1.5),
                      children: [
                        const TextSpan(text: 'Personalizaremos tu experiencia en '),
                        TextSpan(
                          text: 'Oriéntate+',
                          style: TextStyle(color: const Color(0xFF311B92), fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(text: ' según el rol que elijas.'),
                      ],
                    ),
                  ),
                  SizedBox(height: 32.h),
                  
                  // Cambiamos GridView por una lista de Widgets para permitir altura dinámica
                  _buildRoleCard(
                    title: 'Estudiante',
                    description: 'Explora carreras, juega minijuegos y descubre tu futuro profesional.',
                    icon: Icons.school_outlined,
                    role: 'estudiante',
                  ),
                  _buildRoleCard(
                    title: 'Orientador',
                    description: 'Gestiona el progreso de tus alumnos y brinda apoyo vocacional directo.',
                    icon: Icons.people_outline,
                    role: 'orientador',
                  ),
                  _buildRoleCard(
                    title: 'Universidad',
                    description: 'Publica tu oferta académica, becas y conecta con futuros estudiantes.',
                    icon: Icons.account_balance_outlined,
                    role: 'universidad',
                  ),
                  _buildRoleCard(
                    title: 'Alumni',
                    description: 'Comparte tu experiencia profesional y ayuda a otros a elegir su camino.',
                    icon: Icons.person_outline,
                    role: 'alumni',
                  ),
                ],
              ),
            ),
            
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleCard({required String title, required String description, required IconData icon, required String role}) {
    return RoleCard(
      title: title,
      description: description,
      icon: icon,
      isSelected: _selectedRole == role,
      onTap: () => setState(() => _selectedRole = role),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FractionallySizedBox(
            widthFactor: 1.0,
            child: ElevatedButton(
              onPressed: _selectedRole == null ? null : () => context.push('/register', extra: _selectedRole),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF311B92),
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey[300],
                padding: EdgeInsets.symmetric(vertical: 18.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                elevation: 0,
              ),
              child: Text('Continuar', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Al continuar, aceptas nuestros Términos de Servicio.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 11.sp),
          ),
        ],
      ),
    );
  }
}
