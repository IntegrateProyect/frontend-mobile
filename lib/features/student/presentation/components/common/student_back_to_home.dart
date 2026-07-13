import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:orientate/core/routes/AppRoutes.dart';

class StudentBackToHome extends StatelessWidget {
  final Widget child;

  const StudentBackToHome({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted) {
            return;
          }

          context.go(AppRoutes.home.path);
        });
      },
      child: child,
    );
  }
}