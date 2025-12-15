import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tarea2u2_app/src/presentation/viewmodels/driving_viewmodel.dart';

class SteeringWheelDisplay extends StatelessWidget {
  const SteeringWheelDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final angle = context.select((DrivingProvider p) => p.steeringAngle);

    return Center(
      child: Transform.rotate(
        angle: angle,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 50,
                spreadRadius: 5,
              )
            ],
          ),
          child: Image.asset(
            'assets/steering_wheel.png',
            fit: BoxFit.contain,
            width: 250,
            height: 250,
          ),
        ),
      ),
    );
  }
}