import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

import '../providers/games_provider.dart';
import 'game_detail_screen.dart';

class GamesListScreen extends StatefulWidget {
  const GamesListScreen({super.key});

  @override
  State<GamesListScreen> createState() => _GamesListScreenState();
}

class _GamesListScreenState extends State<GamesListScreen> {
  static const Color primaryColor = Color(0xFF311B92);
  static const Color darkText = Color(0xFF1D1B4B);

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<GamesProvider>().fetchGames();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GamesProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Minijuegos vocacionales',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontSize: 18,
          ),
        ),
      ),
      body: RefreshIndicator(
        color: primaryColor,
        onRefresh: provider.fetchGames,
        child: provider.isLoading || provider.isLoadingQuestions
            ? const Center(child: CircularProgressIndicator(color: primaryColor))
            : provider.miniGames.isEmpty
            ? _buildEmpty(provider)
            : ListView(
          padding: const EdgeInsets.all(22),
          children: [
            const Text(
              'Elige tu aventura vocacional',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w900,
                color: darkText,
              ),
            ).animate().fadeIn().slideX(begin: -0.15),
            const SizedBox(height: 8),
            Text(
              'Cada área se juega diferente según el tipo de interés.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.35,
              ),
            ).animate().fadeIn(delay: 150.ms),
            const SizedBox(height: 24),
            ...provider.miniGames.asMap().entries.map(
                  (entry) => _buildMiniGameCard(
                provider,
                entry.value,
                entry.key,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty(GamesProvider provider) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 160),
        const Icon(Icons.sports_esports_outlined, size: 70, color: Colors.grey),
        const SizedBox(height: 16),
        const Center(
          child: Text(
            'No hay minijuegos disponibles.',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: provider.fetchGames,
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
          ),
          child: const Text('Reintentar'),
        ),
      ],
    );
  }

  Widget _buildMiniGameCard(
      GamesProvider provider,
      VocationalMiniGame miniGame,
      int index,
      ) {
    final data = _gameVisual(miniGame.category);
    final activeGame = provider.activeGame;
    final progress = (miniGame.questions.length / 10).clamp(0.1, 1.0);

    return GestureDetector(
      onTap: () {
        if (activeGame == null) return;

        provider.selectMiniGame(miniGame);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => GameDetailScreen(game: activeGame),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: data.gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: data.mainColor.withOpacity(0.25),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Hero(
                  tag: 'game_${miniGame.title}',
                  child: Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.92),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Icon(
                      data.icon,
                      color: data.mainColor,
                      size: 38,
                    ),
                  )
                      .animate(onPlay: (controller) => controller.repeat())
                      .shimmer(duration: 2600.ms),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.label,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        miniGame.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        miniGame.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.88),
                          fontSize: 13,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                CircularPercentIndicator(
                  radius: 29,
                  lineWidth: 7,
                  percent: progress.toDouble(),
                  progressColor: Colors.white,
                  backgroundColor: Colors.white.withOpacity(0.25),
                  center: Text(
                    '${miniGame.questions.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    '${miniGame.questions.length} retos disponibles',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    'Jugar',
                    style: TextStyle(
                      color: data.mainColor,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      )
          .animate()
          .fadeIn(delay: (index * 90).ms)
          .slideY(begin: 0.18, curve: Curves.easeOutBack),
    );
  }

  _GameVisual _gameVisual(VocationalCategory category) {
    switch (category) {
      case VocationalCategory.calculo:
        return _GameVisual(
          label: 'LÓGICA',
          icon: Icons.calculate_outlined,
          mainColor: const Color(0xFF3949AB),
          gradient: const [Color(0xFF667EEA), Color(0xFF311B92)],
        );
      case VocationalCategory.fisico:
        return _GameVisual(
          label: 'CIENCIA FÍSICA',
          icon: Icons.auto_awesome_outlined,
          mainColor: const Color(0xFF4527A0),
          gradient: const [Color(0xFF1D1B4B), Color(0xFF7E57C2)],
        );
      case VocationalCategory.biologico:
        return _GameVisual(
          label: 'BIOLOGÍA',
          icon: Icons.biotech_outlined,
          mainColor: const Color(0xFF2E7D32),
          gradient: const [Color(0xFF43A047), Color(0xFF00ACC1)],
        );
      case VocationalCategory.mecanico:
        return _GameVisual(
          label: 'MECÁNICO',
          icon: Icons.build_circle_outlined,
          mainColor: const Color(0xFF546E7A),
          gradient: const [Color(0xFF546E7A), Color(0xFF263238)],
        );
      case VocationalCategory.social:
        return _GameVisual(
          label: 'SERVICIO',
          icon: Icons.volunteer_activism_outlined,
          mainColor: const Color(0xFFD81B60),
          gradient: const [Color(0xFFF06292), Color(0xFFC2185B)],
        );
      case VocationalCategory.literario:
        return _GameVisual(
          label: 'LECTURA',
          icon: Icons.menu_book_outlined,
          mainColor: const Color(0xFF6D4C41),
          gradient: const [Color(0xFF8D6E63), Color(0xFF4E342E)],
        );
      case VocationalCategory.persuasivo:
        return _GameVisual(
          label: 'LIDERAZGO',
          icon: Icons.campaign_outlined,
          mainColor: const Color(0xFFF57C00),
          gradient: const [Color(0xFFFF9800), Color(0xFFE65100)],
        );
      case VocationalCategory.artistico:
        return _GameVisual(
          label: 'ARTE',
          icon: Icons.palette_outlined,
          mainColor: const Color(0xFF8E24AA),
          gradient: const [Color(0xFFAB47BC), Color(0xFF5E35B1)],
        );
      case VocationalCategory.musical:
        return _GameVisual(
          label: 'MÚSICA',
          icon: Icons.music_note_outlined,
          mainColor: const Color(0xFF00897B),
          gradient: const [Color(0xFF26A69A), Color(0xFF00695C)],
        );
    }
  }
}

class _GameVisual {
  final String label;
  final IconData icon;
  final Color mainColor;
  final List<Color> gradient;

  _GameVisual({
    required this.label,
    required this.icon,
    required this.mainColor,
    required this.gradient,
  });
}