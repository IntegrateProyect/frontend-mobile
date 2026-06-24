import 'package:flutter/material.dart';
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Crea tu cuenta',
          style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey[200], height: 1),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                children: [
                  const Text(
                    '¿Cómo usarás la app?',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1D1B4B),
                    ),
                  ),
                  const SizedBox(height: 12),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 14, color: Colors.grey, height: 1.5),
                      children: [
                        const TextSpan(text: 'Personalizaremos tu experiencia en '),
                        TextSpan(
                          text: 'Oriéntate+',
                          style: TextStyle(color: Color(0xFF311B92), fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(text: ' según el rol que elijas a continuación.'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  RoleCard(
                    title: 'Estudiante',
                    description: 'Explora carreras, juega minijuegos y descubre tu futuro profesional.',
                    icon: Icons.school_outlined,
                    isSelected: _selectedRole == 'student',
                    onTap: () => setState(() => _selectedRole = 'student'),
                  ),
                  RoleCard(
                    title: 'Orientador',
                    description: 'Gestiona el progreso de tus alumnos y brinda apoyo vocacional directo.',
                    icon: Icons.people_outline,
                    isSelected: _selectedRole == 'counselor',
                    onTap: () => setState(() => _selectedRole = 'counselor'),
                  ),
                  RoleCard(
                    title: 'Universidad',
                    description: 'Publica tu oferta académica, becas y conecta con futuros estudiantes.',
                    icon: Icons.account_balance_outlined,
                    isSelected: _selectedRole == 'university',
                    onTap: () => setState(() => _selectedRole = 'university'),
                  ),
                  RoleCard(
                    title: 'Alumni',
                    description: 'Comparte tu experiencia profesional y ayuda a otros a elegir su camino.',
                    icon: Icons.person_outline,
                    isSelected: _selectedRole == 'alumni',
                    onTap: () => setState(() => _selectedRole = 'alumni'),
                  ),
                ],
              ),
            ),
            
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey[100]!)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: _selectedRole == null
                        ? null
                        : () {
                            // Pasamos el rol seleccionado como argumento
                            Navigator.pushNamed(
                              context, 
                              '/register',
                              arguments: _selectedRole,
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF311B92),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey[300],
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      minimumSize: const Size.fromHeight(56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Continuar',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Al continuar, aceptas nuestros Términos de Servicio y Política de Privacidad.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
