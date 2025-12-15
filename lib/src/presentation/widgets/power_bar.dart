import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tarea2u2_app/src/presentation/viewmodels/driving_viewmodel.dart';

class PowerBar extends StatelessWidget {
  const PowerBar({super.key});

  @override
  Widget build(BuildContext context) {

    final speed = context.select((DrivingProvider p) => p.speed);
    final percentage = (speed.abs() / 160).clamp(0.0, 1.0);

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
      color: Colors.black45,
      child: Row(
        children: [
          const Text("PWR",
              style: TextStyle(color: Colors.white30, fontWeight: FontWeight.bold)),
          const SizedBox(width: 15),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    colors: [Colors.green, Colors.yellow, Colors.red],
                    stops: [0.0, 0.7, 1.0],
                  ).createShader(bounds);
                },
                child: LinearProgressIndicator(
                  value: percentage,
                  minHeight: 10,
                  backgroundColor: Colors.grey[900],
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          const Text("SPORT",
              style: TextStyle(
                  color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}