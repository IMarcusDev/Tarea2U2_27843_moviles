import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tarea2u2_app/src/presentation/viewmodels/driving_viewmodel.dart';

class DashboardPanel extends StatelessWidget {
  const DashboardPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final speed = context.select((DrivingProvider p) => p.speed);
    final gear = context.select((DrivingProvider p) => p.gearStatus);
    final leftSignal = context.select((DrivingProvider p) => p.leftSignal);
    final rightSignal = context.select((DrivingProvider p) => p.rightSignal);

    Color speedColor = Colors.cyanAccent;
    if (speed.abs() > 120) speedColor = Colors.redAccent;
    else if (speed.abs() > 80) speedColor = Colors.amberAccent;

    TextStyle digitalStyle = TextStyle(
      color: speedColor,
      fontWeight: FontWeight.w900,
      fontFamily: 'Courier',
      shadows: [
        BoxShadow(color: speedColor.withOpacity(0.6), blurRadius: 20, spreadRadius: 5)
      ],
    );

    return Container(
      decoration: const BoxDecoration(
        border: Border(right: BorderSide(color: Colors.white10)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // MARCHA
          Text(
            gear.toUpperCase(),
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 18,
              letterSpacing: 3,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _TurnSignal(icon: Icons.arrow_left, isActive: leftSignal),
              const SizedBox(width: 10),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    speed.abs().toStringAsFixed(0),
                    style: digitalStyle.copyWith(fontSize: 120),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              _TurnSignal(icon: Icons.arrow_right, isActive: rightSignal),
            ],
          ),

          Text(
            'KM/H',
            style: TextStyle(color: speedColor, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _TurnSignal extends StatelessWidget {
  final IconData icon;
  final bool isActive;

  const _TurnSignal({required this.icon, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.green.withOpacity(0.2) : Colors.transparent,
        boxShadow: isActive
            ? [BoxShadow(color: Colors.greenAccent.withOpacity(0.6), blurRadius: 15)]
            : [],
      ),
      child: Icon(icon, color: isActive ? Colors.greenAccent : Colors.white10, size: 50),
    );
  }
}