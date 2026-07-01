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
              'Elige tu aventura\nvocacional',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: darkText,
                height: 1.1,
              ),
            ).animate().fadeIn().slideX(begin: -0.15),
            const SizedBox(height: 12),
            Text(
              'Cada área se juega diferente según el tipo de interés.',
              style: TextStyle(
                fontSize: 15,
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
    final status = provider.getMiniGameStatus(miniGame.statusKey);
    final progress = (miniGame.questions.length / 20).clamp(0.1, 1.0);

    return GestureDetector(
      onTap: () async {
        if (activeGame == null) return;

        await provider.selectMiniGame(miniGame);

        if (!mounted) return;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => GameDetailScreen(
              game: activeGame,
              miniGameKey: miniGame.statusKey,
            ),
          ),
        );
      },
      child: Container(
        height: 315,
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: data.mainColor.withOpacity(0.38),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  data.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _fallbackGradient(data),
                ),
              ),

              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.62),
                        Colors.black.withOpacity(0.28),
                        Colors.black.withOpacity(0.42),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
              ),

              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.bottomRight,
                      radius: 1.0,
                      colors: [
                        data.mainColor.withOpacity(0.18),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              Positioned(
                left: 20,
                top: 24,
                child: Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: data.mainColor.withOpacity(0.88),
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.45),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: data.neonColor.withOpacity(0.45),
                        blurRadius: 18,
                      ),
                    ],
                  ),
                  child: Icon(
                    data.icon,
                    color: Colors.white,
                    size: 46,
                  ),
                ),
              ),

              Positioned(
                left: 122,
                right: 18,
                top: 24,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _shadowText(
                        data.label,
                        fontSize: 12,
                        letterSpacing: 1.5,
                      ),
                      const SizedBox(height: 6),
                      _shadowText(
                        miniGame.title,
                        fontSize: 23,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 8),
                      _shadowText(
                        miniGame.description,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        maxLines: 2,
                        color: Colors.white.withOpacity(0.94),
                      ),
                    ],
                  ),
                ),
              ),

              Positioned(
                left: 24,
                bottom: 96,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.22),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      CircularPercentIndicator(
                        radius: 37,
                        lineWidth: 8,
                        percent: progress.toDouble(),
                        progressColor: data.neonColor,
                        backgroundColor: Colors.white.withOpacity(0.28),
                        center: Text(
                          '${miniGame.questions.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.w900,
                            shadows: [
                              Shadow(color: Colors.black, blurRadius: 8),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      _shadowText(
                        '${miniGame.questions.length} retos\ndisponibles',
                        fontSize: 18,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ),

              Positioned(
                left: 24,
                right: 24,
                bottom: 22,
                child: Row(
                  children: [
                    Expanded(child: _buildStatusButton(status)),
                    const SizedBox(width: 14),
                    _buildPlayButton(
                      data: data,
                      completed: status == MiniGameStatus.completed,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
          .animate()
          .fadeIn(delay: (index * 90).ms)
          .slideY(begin: 0.18, curve: Curves.easeOutBack),
    );
  }

  Widget _shadowText(
      String text, {
        required double fontSize,
        Color color = Colors.white,
        FontWeight fontWeight = FontWeight.w900,
        double letterSpacing = 0,
        int maxLines = 1,
      }) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
        height: 1.12,
        shadows: const [
          Shadow(
            color: Colors.black,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
    );
  }

  Widget _fallbackGradient(_GameVisual data) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: data.gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  Widget _buildStatusButton(MiniGameStatus status) {
    String text;
    IconData icon;

    switch (status) {
      case MiniGameStatus.completed:
        text = 'Completado';
        icon = Icons.check_circle;
        break;
      case MiniGameStatus.inProgress:
        text = 'En progreso';
        icon = Icons.timelapse;
        break;
      case MiniGameStatus.notStarted:
        text = 'Sin iniciar';
        icon = Icons.radio_button_unchecked;
        break;
    }

    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.28),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.65),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w900,
              shadows: [
                Shadow(color: Colors.black, blurRadius: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayButton({
    required _GameVisual data,
    required bool completed,
  }) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 26),
      decoration: BoxDecoration(
        color: data.neonColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: data.neonColor.withOpacity(0.75),
            blurRadius: 18,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            completed ? 'Ver' : 'Jugar',
            style: TextStyle(
              color: data.buttonTextColor,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.play_arrow_rounded,
            color: data.buttonTextColor,
            size: 24,
          ),
        ],
      ),
    );
  }

  _GameVisual _gameVisual(VocationalCategory category) {
    switch (category) {
      case VocationalCategory.musical:
        return _GameVisual(
          label: 'MÚSICA',
          icon: Icons.music_note,
          mainColor: const Color(0xFF7C3AED),
          neonColor: const Color(0xFFE9D5FF),
          buttonTextColor: const Color(0xFF581C87),
          gradient: const [Color(0xFF160A3A), Color(0xFF7C3AED)],
          imagePath: 'assets/images/musical.jpg',
        );

      case VocationalCategory.biologico:
        return _GameVisual(
          label: 'BIOLOGÍA',
          icon: Icons.eco,
          mainColor: const Color(0xFF16A34A),
          neonColor: const Color(0xFF86EFAC),
          buttonTextColor: const Color(0xFF14532D),
          gradient: const [Color(0xFF052E16), Color(0xFF059669)],
          imagePath: 'assets/images/biologico.jpg',
        );

      case VocationalCategory.mecanico:
        return _GameVisual(
          label: 'MECÁNICO',
          icon: Icons.build,
          mainColor: const Color(0xFF0284C7),
          neonColor: const Color(0xFFBAE6FD),
          buttonTextColor: const Color(0xFF0C4A6E),
          gradient: const [Color(0xFF0F172A), Color(0xFF0369A1)],
          imagePath: 'assets/images/mecanico.jpg',
        );

      case VocationalCategory.artistico:
        return _GameVisual(
          label: 'ARTE',
          icon: Icons.palette,
          mainColor: const Color(0xFFF97316),
          neonColor: const Color(0xFFFED7AA),
          buttonTextColor: const Color(0xFF7C2D12),
          gradient: const [Color(0xFF7C2D12), Color(0xFFF97316)],
          imagePath: 'assets/images/artistico.jpg',
        );

      case VocationalCategory.calculo:
        return _GameVisual(
          label: 'LÓGICA',
          icon: Icons.calculate,
          mainColor: const Color(0xFF4F46E5),
          neonColor: const Color(0xFFC7D2FE),
          buttonTextColor: const Color(0xFF312E81),
          gradient: const [Color(0xFF111827), Color(0xFF4338CA)],
          imagePath: 'assets/images/logica.jpg',
        );

      case VocationalCategory.fisico:
        return _GameVisual(
          label: 'CIENCIA FÍSICA',
          icon: Icons.auto_awesome,
          mainColor: const Color(0xFF6D28D9),
          neonColor: const Color(0xFFC4B5FD),
          buttonTextColor: const Color(0xFF4C1D95),
          gradient: const [Color(0xFF10103A), Color(0xFF6D28D9)],
          imagePath: 'assets/images/cientifico.jpg',
        );

      case VocationalCategory.social:
        return _GameVisual(
          label: 'SERVICIO',
          icon: Icons.volunteer_activism,
          mainColor: const Color(0xFFDB2777),
          neonColor: const Color(0xFFFBCFE8),
          buttonTextColor: const Color(0xFF831843),
          gradient: const [Color(0xFF831843), Color(0xFFDB2777)],
          imagePath: 'assets/images/serviciosocial.jpg',
        );

      case VocationalCategory.literario:
        return _GameVisual(
          label: 'LECTURA',
          icon: Icons.menu_book,
          mainColor: const Color(0xFFA16207),
          neonColor: const Color(0xFFFDE68A),
          buttonTextColor: const Color(0xFF713F12),
          gradient: const [Color(0xFF422006), Color(0xFF92400E)],
          imagePath: 'assets/images/literario.jpg',
        );

      case VocationalCategory.persuasivo:
        return _GameVisual(
          label: 'LIDERAZGO',
          icon: Icons.campaign,
          mainColor: const Color(0xFFF97316),
          neonColor: const Color(0xFFFED7AA),
          buttonTextColor: const Color(0xFF7C2D12),
          gradient: const [Color(0xFF7C2D12), Color(0xFFEA580C)],
          imagePath: 'assets/images/persuasivo.jpg',
        );
    }
  }
}

class _GameVisual {
  final String label;
  final IconData icon;
  final Color mainColor;
  final Color neonColor;
  final Color buttonTextColor;
  final List<Color> gradient;
  final String imagePath;

  _GameVisual({
    required this.label,
    required this.icon,
    required this.mainColor,
    required this.neonColor,
    required this.buttonTextColor,
    required this.gradient,
    required this.imagePath,
  });
}