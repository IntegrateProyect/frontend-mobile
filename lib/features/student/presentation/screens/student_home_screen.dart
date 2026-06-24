import 'package:flutter/material.dart';
import 'package:orientate/core/routes/AppRoutes.dart';

class StudentHomeScreen extends StatelessWidget {
  const StudentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Oriéntate+',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting Section
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '¡Hola, Diego! 👋',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1D1B4B)),
                      ),
                      Text(
                        'Tu futuro comienza hoy.',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, AppRoutes.studentProfile.path),
                    child: Stack(
                      children: [
                        const CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=diego'),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Featured Progress Card
            _buildFeaturedProgressCard(),

            // Explora Recursos
            _buildSectionHeader('Explora Recursos', showSeeAll: true),
            _buildResourcesGrid(),

            // Recomendaciones para ti
            _buildSectionHeader('Recomendaciones para ti', icon: Icons.star_border),
            _buildRecommendationsList(),

            // Próximo Evento
            _buildNextEventCard(),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF311B92),
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        onTap: (index) {
          if (index == 3) {
            Navigator.pushNamed(context, AppRoutes.studentProfile.path);
          }
        },
        selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), activeIcon: Icon(Icons.explore), label: 'Explorar'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), activeIcon: Icon(Icons.chat_bubble), label: 'Chatbot'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }

  Widget _buildFeaturedProgressCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 4, 
              decoration: const BoxDecoration(
                color: Color(0xFF4285F4), 
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20))
              )
            ),
          ),
          Row(
            children: [
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tu Camino\nVocacional',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1D1B4B)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Completa el test de habilidades para desbloquear nuevas recomendaciones.',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF311B92),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      child: const Text('Continuar ahora', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 70,
                        width: 70,
                        child: CircularProgressIndicator(
                          value: 0.65,
                          strokeWidth: 8,
                          backgroundColor: Colors.grey[100],
                          color: const Color(0xFF311B92),
                        ),
                      ),
                      const Text(
                        '65%',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1D1B4B)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {bool showSeeAll = false, IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20, color: const Color(0xFF1D1B4B)),
            const SizedBox(width: 8),
          ],
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1D1B4B)),
          ),
          const Spacer(),
          if (showSeeAll)
            TextButton(
              onPressed: () {},
              child: const Row(
                children: [
                  Text('VER TODO', style: TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.bold)),
                  Icon(Icons.chevron_right, size: 16, color: Colors.blue),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildResourcesGrid() {
    final List<Map<String, dynamic>> resources = [
      {'label': 'Perfil Vocacional', 'icon': Icons.trending_up, 'color': Colors.blue},
      {'label': 'Minijuegos', 'icon': Icons.sports_esports_outlined, 'color': Colors.purple},
      {'label': 'Chatbot AI', 'icon': Icons.chat_bubble_outline, 'color': Colors.teal},
      {'label': 'Resultados', 'icon': Icons.pie_chart_outline, 'color': Colors.indigo},
      {'label': 'Carreras', 'icon': Icons.school_outlined, 'color': Colors.pink},
      {'label': 'Universidades', 'icon': Icons.account_balance_outlined, 'color': Colors.blue},
      {'label': 'Becas', 'icon': Icons.account_balance_wallet_outlined, 'color': Colors.purple},
      {'label': 'Eventos', 'icon': Icons.calendar_today_outlined, 'color': Colors.teal},
      {'label': 'Favoritos', 'icon': Icons.favorite_border, 'color': Colors.red},
      {'label': 'Solicitar Apoyo', 'icon': Icons.support, 'color': Colors.blue},
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 20,
          crossAxisSpacing: 10,
          childAspectRatio: 0.9,
        ),
        itemCount: resources.length,
        itemBuilder: (context, index) {
          final res = resources[index];
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (res['color'] as Color).withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(res['icon'], color: res['color'], size: 24),
              ),
              const SizedBox(height: 8),
              Text(
                res['label'],
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRecommendationsList() {
    return SizedBox(
      height: 200,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _buildRecommendationCard(
            'Ingeniería en Inteligencia\nArtificial',
            '92% compatible',
            ['#Tech', '#Futuro'],
            'https://images.unsplash.com/photo-1550751827-4bd374c3f58b?w=400&q=80',
          ),
          const SizedBox(width: 16),
          _buildRecommendationCard(
            'Diseño de Experiencia de\nUsuario (UX)',
            '88% compatible',
            ['#Creativo', '#Digital'],
            'https://images.unsplash.com/photo-1586717791821-3f44a563eb4c?w=400&q=80',
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard(String title, String compatibility, List<String> tags, String imageUrl) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                  child: Text(compatibility, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
                const Icon(Icons.favorite_border, color: Colors.white, size: 20),
              ],
            ),
            const Spacer(),
            Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 4),
            Row(
              children: tags.map((t) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(t, style: const TextStyle(color: Colors.white70, fontSize: 10)),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextEventCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F3FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.calendar_today, color: Colors.purple, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('PRÓXIMO EVENTO', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.purple)),
                const SizedBox(height: 2),
                const Text('Feria Universitaria 2024', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1D1B4B))),
                Text('Mañana, 09:00 AM • Presencial', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}
