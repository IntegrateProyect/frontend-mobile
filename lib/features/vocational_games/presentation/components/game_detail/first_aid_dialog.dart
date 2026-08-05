import 'package:flutter/material.dart';

class FirstAidDialog extends StatelessWidget {
  final VoidCallback onContinue;

  const FirstAidDialog({super.key, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 22),
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 430),
            padding: const EdgeInsets.fromLTRB(18, 26, 18, 20),
            decoration: BoxDecoration(
              color: const Color(0xFF123450),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: const Color(0xFFFFC857),
                width: 3,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x55000000),
                  blurRadius: 22,
                  offset: Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '¡Felicidades!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFFFC857),
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Image.asset(
                        'assets/images/first_aid_girl.png',
                        height: 245,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) {
                          return const SizedBox(
                            height: 220,
                            child: Center(
                              child: Icon(
                                Icons.medical_services_rounded,
                                color: Color(0xFFFFC857),
                                size: 100,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      flex: 6,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '¡Excelente trabajo!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Curaste correctamente el brazo y completaste la actividad de primeros auxilios.',
                            style: TextStyle(
                              color: Color(0xFFE8F4FF),
                              fontSize: 15,
                              height: 1.35,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Tu ayuda hizo sentir mucho mejor al paciente.',
                            style: TextStyle(
                              color: Color(0xFF48DDE4),
                              fontSize: 14,
                              height: 1.3,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: FilledButton(
                    onPressed: onContinue,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFFFC857),
                      foregroundColor: const Color(0xFF08233B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: const Text(
                      'Continuar',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
