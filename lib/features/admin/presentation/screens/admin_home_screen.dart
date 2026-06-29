import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:orientate/features/auth/presentation/providers/auth_provider.dart';
import 'package:orientate/features/admin/presentation/providers/admin_provider.dart';
import 'package:orientate/features/admin/presentation/components/admin_stat_card.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  @override
  void initState() {
    super.initState();
    // Cargamos las estadísticas reales de la API al entrar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminProvider>().fetchStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    final adminProvider = context.watch<AdminProvider>();
    final stats = adminProvider.stats;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Panel de Administrador',
          style: TextStyle(color: Color(0xFF1D1B4B), fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF311B92)),
            onPressed: () => adminProvider.fetchStats(),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: () async {
              final authProvider = context.read<AuthProvider>();
              await authProvider.logout();
              if (mounted) {
                context.go('/login');
              }
            },
          ),
        ],
      ),
      body: adminProvider.isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF311B92)))
          : RefreshIndicator(
              onRefresh: () => adminProvider.fetchStats(),
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const Text(
                    'Estado del Sistema',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1D1B4B)),
                  ),
                  const SizedBox(height: 16),
                  
                  // Tarjetas de Estadísticas conectadas a la API
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.1,
                    children: [
                      AdminStatCard(
                        title: 'Estudiantes',
                        value: stats?.totalStudents.toString() ?? '0',
                        icon: Icons.school_outlined,
                        color: const Color(0xFF311B92),
                      ),
                      AdminStatCard(
                        title: 'Orientadores',
                        value: stats?.totalCounselors.toString() ?? '0',
                        icon: Icons.people_alt_outlined,
                        color: Colors.orange,
                      ),
                      AdminStatCard(
                        title: 'Universidades',
                        value: stats?.totalUniversities.toString() ?? '0',
                        icon: Icons.account_balance_outlined,
                        color: Colors.green,
                      ),
                      AdminStatCard(
                        title: 'Egresados',
                        value: stats?.totalAlumni.toString() ?? '0',
                        icon: Icons.workspace_premium_outlined,
                        color: Colors.purple,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  const Text(
                    'Gestión de plataforma',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1D1B4B)),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildActionTile(
                    title: 'Control de Usuarios',
                    subtitle: 'Ver, editar o suspender cuentas',
                    icon: Icons.manage_accounts_outlined,
                    onTap: () => Navigator.pushNamed(context, '/admin-users'),
                  ),
                  _buildActionTile(
                    title: 'Validación de Instituciones',
                    subtitle: 'Validar nuevos códigos',
                    icon: Icons.verified_user_outlined,
                    onTap: () {},
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildActionTile({required String title, required String subtitle, required IconData icon, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: const Color(0xFFF5F3FF), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: const Color(0xFF311B92)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
