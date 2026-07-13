import 'package:flutter/material.dart';

import '../../../domain/entities/vocational_mini_game_entity.dart';

class MiniGameVisual {
  final String label;
  final IconData icon;
  final Color mainColor;
  final Color neonColor;
  final Color buttonTextColor;
  final List<Color> gradient;
  final String imagePath;

  const MiniGameVisual({
    required this.label,
    required this.icon,
    required this.mainColor,
    required this.neonColor,
    required this.buttonTextColor,
    required this.gradient,
    required this.imagePath,
  });

  static MiniGameVisual fromCategory(VocationalCategory category) {
    return _visuals[category]!;
  }

  static const Map<VocationalCategory, MiniGameVisual> _visuals = {
    VocationalCategory.musical: MiniGameVisual(
      label: 'MÚSICA',
      icon: Icons.music_note,
      mainColor: Color(0xFF7C3AED),
      neonColor: Color(0xFFE9D5FF),
      buttonTextColor: Color(0xFF581C87),
      gradient: [
        Color(0xFF160A3A),
        Color(0xFF7C3AED),
      ],
      imagePath: 'assets/images/musical.jpg',
    ),
    VocationalCategory.biologico: MiniGameVisual(
      label: 'BIOLOGÍA',
      icon: Icons.eco,
      mainColor: Color(0xFF16A34A),
      neonColor: Color(0xFF86EFAC),
      buttonTextColor: Color(0xFF14532D),
      gradient: [
        Color(0xFF052E16),
        Color(0xFF059669),
      ],
      imagePath: 'assets/images/biologico.jpg',
    ),
    VocationalCategory.mecanico: MiniGameVisual(
      label: 'MECÁNICO',
      icon: Icons.build,
      mainColor: Color(0xFF0284C7),
      neonColor: Color(0xFFBAE6FD),
      buttonTextColor: Color(0xFF0C4A6E),
      gradient: [
        Color(0xFF0F172A),
        Color(0xFF0369A1),
      ],
      imagePath: 'assets/images/mecanico.jpg',
    ),
    VocationalCategory.artistico: MiniGameVisual(
      label: 'ARTE',
      icon: Icons.palette,
      mainColor: Color(0xFFF97316),
      neonColor: Color(0xFFFED7AA),
      buttonTextColor: Color(0xFF7C2D12),
      gradient: [
        Color(0xFF7C2D12),
        Color(0xFFF97316),
      ],
      imagePath: 'assets/images/artistico.jpg',
    ),
    VocationalCategory.calculo: MiniGameVisual(
      label: 'LÓGICA',
      icon: Icons.calculate,
      mainColor: Color(0xFF4F46E5),
      neonColor: Color(0xFFC7D2FE),
      buttonTextColor: Color(0xFF312E81),
      gradient: [
        Color(0xFF111827),
        Color(0xFF4338CA),
      ],
      imagePath: 'assets/images/logica.jpg',
    ),
    VocationalCategory.fisico: MiniGameVisual(
      label: 'CIENCIA FÍSICA',
      icon: Icons.auto_awesome,
      mainColor: Color(0xFF6D28D9),
      neonColor: Color(0xFFC4B5FD),
      buttonTextColor: Color(0xFF4C1D95),
      gradient: [
        Color(0xFF10103A),
        Color(0xFF6D28D9),
      ],
      imagePath: 'assets/images/cientifico.jpg',
    ),
    VocationalCategory.social: MiniGameVisual(
      label: 'SERVICIO',
      icon: Icons.volunteer_activism,
      mainColor: Color(0xFFDB2777),
      neonColor: Color(0xFFFBCFE8),
      buttonTextColor: Color(0xFF831843),
      gradient: [
        Color(0xFF831843),
        Color(0xFFDB2777),
      ],
      imagePath: 'assets/images/serviciosocial.jpg',
    ),
    VocationalCategory.literario: MiniGameVisual(
      label: 'LECTURA',
      icon: Icons.menu_book,
      mainColor: Color(0xFFA16207),
      neonColor: Color(0xFFFDE68A),
      buttonTextColor: Color(0xFF713F12),
      gradient: [
        Color(0xFF422006),
        Color(0xFF92400E),
      ],
      imagePath: 'assets/images/literario.jpg',
    ),
    VocationalCategory.persuasivo: MiniGameVisual(
      label: 'LIDERAZGO',
      icon: Icons.campaign,
      mainColor: Color(0xFFF97316),
      neonColor: Color(0xFFFED7AA),
      buttonTextColor: Color(0xFF7C2D12),
      gradient: [
        Color(0xFF7C2D12),
        Color(0xFFEA580C),
      ],
      imagePath: 'assets/images/persuasivo.jpg',
    ),
  };
}