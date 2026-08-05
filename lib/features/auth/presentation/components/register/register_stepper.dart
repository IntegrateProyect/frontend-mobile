import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterStepper extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final Color primaryColor;

  const RegisterStepper({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 18.h,
        horizontal: 42.w,
      ),
      child: Row(
        children: List.generate(
          totalSteps,
          (index) {
            final completed = currentStep > index;
            final active = currentStep == index;

            return Expanded(
              child: Row(
                children: [
                  _stepCircle(
                    icon: index == 0 ? Icons.person : Icons.business,
                    completed: completed,
                    active: active,
                  ),
                  if (index < totalSteps - 1)
                    Expanded(
                      child: Container(
                        height: 2.h,
                        color: completed ? primaryColor : Colors.grey[200],
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _stepCircle({
    required IconData icon,
    required bool completed,
    required bool active,
  }) {
    return Container(
      width: 34.w,
      height: 34.w,
      decoration: BoxDecoration(
        color: completed ? primaryColor : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: active || completed ? primaryColor : Colors.grey[200]!,
          width: 2,
        ),
      ),
      child: Icon(
        completed ? Icons.check : icon,
        size: 17.sp,
        color: completed
            ? Colors.white
            : active
                ? primaryColor
                : Colors.grey[300],
      ),
    );
  }
}
