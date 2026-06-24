import 'package:flutter/material.dart';
import '../components/onboarding_item.dart';
import '../../domain/entities/onboarding_entity.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingEntity> _items = [
    OnboardingEntity(
      title: 'Chatbot Vocacional',
      description:
      'Resuelve tus dudas sobre carreras, becas y universidades con ayuda inmediata y personalizada.',
      image: 'assets/images/onboarding1.png',
    ),
    OnboardingEntity(
      title: 'Carreras y Universidades',
      description:
      'Recibe recomendaciones según tus intereses y descubre opciones que sí van contigo.',
      image: 'assets/images/onboarding2.png',
    ),
    OnboardingEntity(
      title: 'Acompañamiento del Orientador',
      description:
      'No estás solo: recibe apoyo y seguimiento durante todo tu proceso vocacional.',
      image: 'assets/images/onboarding3.png',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToLogin() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _nextPage() {
    if (_currentPage < _items.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _goToLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryPurple = Color(0xFF311B92);
    const Color darkText = Color(0xFF1D1B4B);
    const Color inactiveDot = Color(0xFFD1D5DB);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Parte superior
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _goToLogin,
                    child: const Text(
                      'Saltar',
                      style: TextStyle(
                        color: darkText,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                  ),

                  Row(
                    children: List.generate(
                      _items.length,
                          (index) {
                        final bool isActive = _currentPage == index;

                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 8,
                          width: isActive ? 28 : 8,
                          decoration: BoxDecoration(
                            color: isActive ? primaryPurple : inactiveDot,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(width: 70),
                ],
              ),
            ),

            // Contenido del onboarding
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _items.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return OnboardingItem(
                    item: _items[index],
                  );
                },
              ),
            ),

            // Botón inferior
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryPurple,
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shadowColor: primaryPurple.withOpacity(0.35),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _currentPage < _items.length - 1
                            ? 'Continuar'
                            : 'Comenzar',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(
                        _currentPage < _items.length - 1
                            ? Icons.arrow_forward_ios
                            : Icons.check,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}