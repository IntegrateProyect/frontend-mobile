import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../domain/entities/game_question_entity.dart';

typedef InteractiveAnswerCallback = void Function(
    GameQuestionOptionEntity option,
    Map<String, dynamic> interactionData,
    );

enum _InteractiveLayout {
  scale2D,
  board3D,
}

class InteractiveQuestionGame extends StatelessWidget {
  final GameQuestionEntity question;
  final String miniGameKey;
  final bool disabled;
  final InteractiveAnswerCallback onSelected;

  const InteractiveQuestionGame({
    super.key,
    required this.question,
    required this.miniGameKey,
    required this.disabled,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (question.options.isEmpty) {
      return const Center(
        child: Text(
          'Esta actividad no tiene respuestas disponibles.',
          textAlign: TextAlign.center,
        ),
      );
    }

    final theme = _InteractiveTheme.fromKey(
      miniGameKey,
    );

    switch (theme.layout) {
      case _InteractiveLayout.scale2D:
        return _InterestScaleGame(
          question: question,
          theme: theme,
          disabled: disabled,
          onSelected: onSelected,
        );

      case _InteractiveLayout.board3D:
        return _PerspectiveBoardGame(
          question: question,
          theme: theme,
          disabled: disabled,
          onSelected: onSelected,
        );
    }
  }
}

// ============================================================
// JUEGO 2D: MEDIDOR DE INTERÉS
// ============================================================

class _InterestScaleGame extends StatelessWidget {
  final GameQuestionEntity question;
  final _InteractiveTheme theme;
  final bool disabled;
  final InteractiveAnswerCallback onSelected;

  const _InterestScaleGame({
    required this.question,
    required this.theme,
    required this.disabled,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _MissionHeader(theme: theme),
        const SizedBox(height: 10),
        _DraggableToken(
          theme: theme,
          disabled: disabled,
        ),
        const SizedBox(height: 10),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: List.generate(
                  question.options.length,
                      (index) {
                    final option =
                    question.options[index];

                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom:
                          index ==
                              question.options.length -
                                  1
                              ? 0
                              : 6,
                        ),
                        child: DragTarget<String>(
                          onWillAccept: (_) => !disabled,
                          onAccept: (_) {
                            HapticFeedback.mediumImpact();

                            onSelected(
                              option,
                              {
                                'interactionType':
                                theme.interactionType,
                                'inputMethod': 'drag_drop',
                                'category': theme.category,
                                'interestLevel': index + 1,
                                'layout': '2D',
                              },
                            );
                          },
                          builder: (
                              context,
                              candidateData,
                              rejectedData,
                              ) {
                            final hovering =
                                candidateData.isNotEmpty;

                            return AnimatedContainer(
                              duration: const Duration(
                                milliseconds: 180,
                              ),
                              width: double.infinity,
                              padding:
                              const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                gradient: hovering
                                    ? LinearGradient(
                                  colors:
                                  theme.gradient,
                                )
                                    : const LinearGradient(
                                  colors: [
                                    Colors.white,
                                    Color(0xFFF8F7FF),
                                  ],
                                ),
                                borderRadius:
                                BorderRadius.circular(17),
                                border: Border.all(
                                  color: hovering
                                      ? theme.primaryColor
                                      : const Color(
                                    0xFFDDD8F2,
                                  ),
                                  width: hovering ? 3 : 1.4,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: theme.primaryColor
                                        .withOpacity(
                                      hovering ? 0.25 : 0.07,
                                    ),
                                    blurRadius:
                                    hovering ? 16 : 6,
                                    offset:
                                    const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  AnimatedContainer(
                                    duration:
                                    const Duration(
                                      milliseconds: 180,
                                    ),
                                    width: hovering ? 41 : 37,
                                    height: hovering ? 41 : 37,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: hovering
                                          ? Colors.white24
                                          : theme.primaryColor
                                          .withOpacity(
                                        0.11,
                                      ),
                                    ),
                                    child: Icon(
                                      _interestIcon(index),
                                      color: hovering
                                          ? Colors.white
                                          : theme.primaryColor,
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      option.text,
                                      maxLines: 2,
                                      overflow:
                                      TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: hovering
                                            ? Colors.white
                                            : const Color(
                                          0xFF1D1B4B,
                                        ),
                                        fontSize: 13,
                                        height: 1.1,
                                        fontWeight:
                                        FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    width: 27,
                                    height: 27,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: hovering
                                          ? Colors.white24
                                          : const Color(
                                        0xFFEDE9FE,
                                      ),
                                    ),
                                    child: Text(
                                      '${index + 1}',
                                      style: TextStyle(
                                        color: hovering
                                            ? Colors.white
                                            : theme.primaryColor,
                                        fontSize: 12,
                                        fontWeight:
                                        FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ============================================================
// JUEGO 2.5D: TABLERO CON PERSPECTIVA
// ============================================================

class _PerspectiveBoardGame extends StatelessWidget {
  final GameQuestionEntity question;
  final _InteractiveTheme theme;
  final bool disabled;
  final InteractiveAnswerCallback onSelected;

  const _PerspectiveBoardGame({
    required this.question,
    required this.theme,
    required this.disabled,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _MissionHeader(theme: theme),
        const SizedBox(height: 9),
        _DraggableToken(
          theme: theme,
          disabled: disabled,
        ),
        const SizedBox(height: 9),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final itemCount =
                  question.options.length;

              const columns = 2;
              final rows =
              (itemCount / columns).ceil();

              const horizontalGap = 8.0;
              const verticalGap = 8.0;

              final itemWidth =
                  (constraints.maxWidth -
                      horizontalGap) /
                      columns;

              final itemHeight =
                  (constraints.maxHeight -
                      ((rows - 1) * verticalGap)) /
                      rows;

              final ratio = itemHeight <= 0
                  ? 1.3
                  : itemWidth / itemHeight;

              return GridView.builder(
                padding: EdgeInsets.zero,
                physics:
                const NeverScrollableScrollPhysics(),
                itemCount: itemCount,
                gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: horizontalGap,
                  mainAxisSpacing: verticalGap,
                  childAspectRatio: ratio,
                ),
                itemBuilder: (context, index) {
                  final option =
                  question.options[index];

                  return DragTarget<String>(
                    onWillAccept: (_) => !disabled,
                    onAccept: (_) {
                      HapticFeedback.mediumImpact();

                      onSelected(
                        option,
                        {
                          'interactionType':
                          theme.interactionType,
                          'inputMethod': 'drag_drop',
                          'category': theme.category,
                          'interestLevel': index + 1,
                          'targetIndex': index,
                          'layout': '2.5D',
                        },
                      );
                    },
                    builder: (
                        context,
                        candidateData,
                        rejectedData,
                        ) {
                      final hovering =
                          candidateData.isNotEmpty;

                      final rotation =
                      index.isEven ? -0.045 : 0.045;

                      return AnimatedScale(
                        scale: hovering ? 1.035 : 1,
                        duration: const Duration(
                          milliseconds: 180,
                        ),
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.0015)
                            ..rotateX(
                              hovering ? 0 : -0.025,
                            )
                            ..rotateY(
                              hovering ? 0 : rotation,
                            ),
                          child: AnimatedContainer(
                            duration: const Duration(
                              milliseconds: 180,
                            ),
                            padding:
                            const EdgeInsets.all(9),
                            decoration: BoxDecoration(
                              gradient: hovering
                                  ? LinearGradient(
                                colors:
                                theme.gradient,
                                begin:
                                Alignment.topLeft,
                                end: Alignment
                                    .bottomRight,
                              )
                                  : const LinearGradient(
                                colors: [
                                  Colors.white,
                                  Color(0xFFF8F7FF),
                                ],
                              ),
                              borderRadius:
                              BorderRadius.circular(18),
                              border: Border.all(
                                color: hovering
                                    ? theme.primaryColor
                                    : const Color(
                                  0xFFDDD8F2,
                                ),
                                width: hovering ? 3 : 1.3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: theme.primaryColor
                                      .withOpacity(
                                    hovering ? 0.3 : 0.09,
                                  ),
                                  blurRadius:
                                  hovering ? 17 : 8,
                                  offset:
                                  const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 39,
                                  height: 39,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: hovering
                                        ? Colors.white24
                                        : theme.primaryColor
                                        .withOpacity(
                                      0.11,
                                    ),
                                  ),
                                  child: Icon(
                                    _interestIcon(index),
                                    color: hovering
                                        ? Colors.white
                                        : theme.primaryColor,
                                    size: 23,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Flexible(
                                  child: Text(
                                    option.text,
                                    textAlign:
                                    TextAlign.center,
                                    maxLines: 3,
                                    overflow:
                                    TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: hovering
                                          ? Colors.white
                                          : const Color(
                                        0xFF1D1B4B,
                                      ),
                                      fontSize: 11,
                                      height: 1.08,
                                      fontWeight:
                                      FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

// ============================================================
// COMPONENTES COMPARTIDOS
// ============================================================

class _MissionHeader extends StatelessWidget {
  final _InteractiveTheme theme;

  const _MissionHeader({
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.primaryColor.withOpacity(0.13),
            theme.secondaryColor.withOpacity(0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: theme.primaryColor.withOpacity(0.16),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 47,
            height: 47,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: theme.gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Icon(
              theme.icon,
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  theme.title,
                  style: const TextStyle(
                    color: Color(0xFF1D1B4B),
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  theme.instruction,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 11,
                    height: 1.15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DraggableToken extends StatelessWidget {
  final _InteractiveTheme theme;
  final bool disabled;

  const _DraggableToken({
    required this.theme,
    required this.disabled,
  });

  @override
  Widget build(BuildContext context) {
    final token = _token(
      size: 58,
      dragging: false,
    );

    if (disabled) {
      return Opacity(
        opacity: 0.4,
        child: token,
      );
    }

    return Draggable<String>(
      data: 'interest_token',
      feedback: Material(
        color: Colors.transparent,
        child: _token(
          size: 70,
          dragging: true,
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.2,
        child: token,
      ),
      child: token,
    );
  }

  Widget _token({
    required double size,
    required bool dragging,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedScale(
          scale: dragging ? 1.1 : 1,
          duration: const Duration(
            milliseconds: 180,
          ),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: theme.gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: Colors.white,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color:
                  theme.primaryColor.withOpacity(0.3),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(
              theme.tokenIcon,
              color: Colors.white,
              size: size * 0.48,
            ),
          ),
        ),
        if (!dragging) ...[
          const SizedBox(height: 3),
          Text(
            theme.tokenLabel,
            style: TextStyle(
              color: theme.primaryColor,
              fontSize: 10,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ],
    );
  }
}

IconData _interestIcon(int index) {
  const icons = [
    Icons.sentiment_very_dissatisfied_rounded,
    Icons.sentiment_dissatisfied_rounded,
    Icons.sentiment_neutral_rounded,
    Icons.sentiment_satisfied_rounded,
    Icons.sentiment_very_satisfied_rounded,
  ];

  return icons[index.clamp(0, icons.length - 1)];
}

// ============================================================
// CONFIGURACIÓN SEGÚN CATEGORÍA
// ============================================================

class _InteractiveTheme {
  final String category;
  final String title;
  final String instruction;
  final String interactionType;
  final String tokenLabel;

  final IconData icon;
  final IconData tokenIcon;

  final Color primaryColor;
  final Color secondaryColor;

  final List<Color> gradient;
  final _InteractiveLayout layout;

  const _InteractiveTheme({
    required this.category,
    required this.title,
    required this.instruction,
    required this.interactionType,
    required this.tokenLabel,
    required this.icon,
    required this.tokenIcon,
    required this.primaryColor,
    required this.secondaryColor,
    required this.gradient,
    required this.layout,
  });

  static _InteractiveTheme fromKey(
      String rawKey,
      ) {
    final key = rawKey.toLowerCase().trim();

    switch (key) {
      case 'calculo':
        return const _InteractiveTheme(
          category: 'calculo',
          title: 'Regla de interés matemático',
          instruction:
          'Arrastra el cursor al nivel que represente cuánto te atrae esta actividad.',
          interactionType: 'CALCULATION_SCALE_2D',
          tokenLabel: 'Cursor',
          icon: Icons.straighten_rounded,
          tokenIcon: Icons.calculate_rounded,
          primaryColor: Color(0xFF4338CA),
          secondaryColor: Color(0xFF2563EB),
          gradient: [
            Color(0xFF4F46E5),
            Color(0xFF2563EB),
          ],
          layout: _InteractiveLayout.scale2D,
        );

      case 'fisico':
        return const _InteractiveTheme(
          category: 'fisico',
          title: 'Explorador científico',
          instruction:
          'Arrastra tu energía hacia el nivel de interés que represente tu elección.',
          interactionType: 'PHYSICS_BOARD_3D',
          tokenLabel: 'Energía',
          icon: Icons.auto_awesome_rounded,
          tokenIcon: Icons.rocket_launch_rounded,
          primaryColor: Color(0xFF6D28D9),
          secondaryColor: Color(0xFF4338CA),
          gradient: [
            Color(0xFF7C3AED),
            Color(0xFF4338CA),
          ],
          layout: _InteractiveLayout.board3D,
        );

      case 'biologico':
        return const _InteractiveTheme(
          category: 'biologico',
          title: 'Cultiva tu interés',
          instruction:
          'Arrastra la semilla hacia el nivel que mejor represente tu interés.',
          interactionType: 'BIOLOGY_BOARD_3D',
          tokenLabel: 'Semilla',
          icon: Icons.biotech_rounded,
          tokenIcon: Icons.eco_rounded,
          primaryColor: Color(0xFF15803D),
          secondaryColor: Color(0xFF059669),
          gradient: [
            Color(0xFF16A34A),
            Color(0xFF059669),
          ],
          layout: _InteractiveLayout.board3D,
        );

      case 'mecanico':
        return const _InteractiveTheme(
          category: 'mecanico',
          title: 'Activa el mecanismo',
          instruction:
          'Arrastra el engrane al nivel que represente cuánto te interesa la actividad.',
          interactionType: 'MECHANICAL_SCALE_2D',
          tokenLabel: 'Engrane',
          icon: Icons.build_rounded,
          tokenIcon: Icons.settings_rounded,
          primaryColor: Color(0xFF0369A1),
          secondaryColor: Color(0xFF0284C7),
          gradient: [
            Color(0xFF0284C7),
            Color(0xFF0369A1),
          ],
          layout: _InteractiveLayout.scale2D,
        );

      case 'social':
        return const _InteractiveTheme(
          category: 'social',
          title: 'Conecta con las personas',
          instruction:
          'Arrastra el corazón hacia el nivel que represente tu interés.',
          interactionType: 'SOCIAL_BOARD_3D',
          tokenLabel: 'Conexión',
          icon: Icons.groups_rounded,
          tokenIcon: Icons.favorite_rounded,
          primaryColor: Color(0xFFBE185D),
          secondaryColor: Color(0xFFDB2777),
          gradient: [
            Color(0xFFDB2777),
            Color(0xFFBE185D),
          ],
          layout: _InteractiveLayout.board3D,
        );

      case 'literario':
        return const _InteractiveTheme(
          category: 'literario',
          title: 'Marca tu interés',
          instruction:
          'Arrastra el marcador al nivel que mejor represente tu gusto por la actividad.',
          interactionType: 'LITERARY_SCALE_2D',
          tokenLabel: 'Marcador',
          icon: Icons.menu_book_rounded,
          tokenIcon: Icons.bookmark_rounded,
          primaryColor: Color(0xFF92400E),
          secondaryColor: Color(0xFFA16207),
          gradient: [
            Color(0xFFA16207),
            Color(0xFF92400E),
          ],
          layout: _InteractiveLayout.scale2D,
        );

      case 'persuasivo':
        return const _InteractiveTheme(
          category: 'persuasivo',
          title: 'Potencia tu voz',
          instruction:
          'Arrastra el megáfono al nivel que represente tu interés por la actividad.',
          interactionType: 'PERSUASIVE_SCALE_2D',
          tokenLabel: 'Tu voz',
          icon: Icons.campaign_rounded,
          tokenIcon: Icons.record_voice_over_rounded,
          primaryColor: Color(0xFFEA580C),
          secondaryColor: Color(0xFFF97316),
          gradient: [
            Color(0xFFF97316),
            Color(0xFFEA580C),
          ],
          layout: _InteractiveLayout.scale2D,
        );

      case 'artistico':
        return const _InteractiveTheme(
          category: 'artistico',
          title: 'Explora tu creatividad',
          instruction:
          'Arrastra el pincel hacia el nivel que represente cuánto disfrutas la actividad.',
          interactionType: 'ART_BOARD_3D',
          tokenLabel: 'Pincel',
          icon: Icons.palette_rounded,
          tokenIcon: Icons.brush_rounded,
          primaryColor: Color(0xFFC2410C),
          secondaryColor: Color(0xFFF97316),
          gradient: [
            Color(0xFFF97316),
            Color(0xFFDB2777),
          ],
          layout: _InteractiveLayout.board3D,
        );

      case 'musical':
        return const _InteractiveTheme(
          category: 'musical',
          title: 'Ajusta tu nivel musical',
          instruction:
          'Arrastra la nota al nivel que represente cuánto te interesa esta actividad.',
          interactionType: 'MUSIC_SCALE_2D',
          tokenLabel: 'Nota',
          icon: Icons.graphic_eq_rounded,
          tokenIcon: Icons.music_note_rounded,
          primaryColor: Color(0xFF6D28D9),
          secondaryColor: Color(0xFF7C3AED),
          gradient: [
            Color(0xFF7C3AED),
            Color(0xFF9333EA),
          ],
          layout: _InteractiveLayout.scale2D,
        );

      default:
        return const _InteractiveTheme(
          category: 'general',
          title: 'Mide tu nivel de interés',
          instruction:
          'Arrastra la ficha hacia la respuesta que mejor represente tu elección.',
          interactionType: 'GENERAL_INTERACTIVE_2D',
          tokenLabel: 'Tu ficha',
          icon: Icons.sports_esports_rounded,
          tokenIcon: Icons.touch_app_rounded,
          primaryColor: Color(0xFF4F46E5),
          secondaryColor: Color(0xFF7C3AED),
          gradient: [
            Color(0xFF4F46E5),
            Color(0xFF7C3AED),
          ],
          layout: _InteractiveLayout.scale2D,
        );
    }
  }
}