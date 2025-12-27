
import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const CustomProgressIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        bool isCompleted = index < currentStep;
        bool isActive = index == currentStep;

        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 4,
                  color: isCompleted ? Colors.amber : Colors.grey.shade300,
                ),
              ),
              CircleAvatar(
                radius: 12,
                backgroundColor: isCompleted || isActive
                    ? Colors.amber
                    : Colors.grey.shade300,
                child: isCompleted
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : isActive
                        ? const CircleAvatar(
                            radius: 6,
                            backgroundColor: Colors.white,
                          )
                        : null,
              ),
            ],
          ),
        );
      }),
    );
  }
}
