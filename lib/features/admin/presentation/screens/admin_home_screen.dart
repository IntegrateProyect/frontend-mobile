import 'package:flutter/material.dart';
import '../components/admin_stat_card.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Panel de Administrador')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Resumen General', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: const [
              AdminStatCard(title: 'Estudiantes', value: '1,240', icon: Icons.school, color: Colors.blue),
              AdminStatCard(title: 'Orientadores', value: '45', icon: Icons.psychology, color: Colors.orange),
              AdminStatCard(title: 'Universidades', value: '12', icon: Icons.account_balance, color: Colors.green),
              AdminStatCard(title: 'Egresados', value: '89', icon: Icons.person_pin, color: Colors.purple),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Gestión', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Gestión de Usuarios'),
            subtitle: const Text('Habilitar, deshabilitar o eliminar cuentas'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.pushNamed(context, '/admin-users'),
          ),
          ListTile(
            leading: const Icon(Icons.report),
            title: const Text('Ver Reportes'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
