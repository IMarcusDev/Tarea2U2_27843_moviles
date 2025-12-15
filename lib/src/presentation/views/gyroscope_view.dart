// EL dispositivo debe controlarse horizontalmente
// La idea es que, al girarlo (rotar en Z), se vea como si fuese un volante, aunque
// no estoy seguro de cómo representar eso
// Si se acuesta el dispositivo (rotar en X), se cambian marchas
// No vamos a hacer algo al rotar en Y, ya que debería utilizarse de forma vertical
// y, en esa posición, acostar el dispositivo

// El giroscopio funciona con velocidad, no es solamente acostarlo y se ponen todas
// las marchas, etc.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tarea2u2_app/src/data/repositories/position_repository_impl.dart';

class GyroscopeView extends StatefulWidget {
  const GyroscopeView({super.key});

  @override
  State<GyroscopeView> createState() => _GyroscopeViewState();
}

class _GyroscopeViewState extends State<GyroscopeView> {
  final PositionRepositoryImpl repository = PositionRepositoryImpl();

  double _steeringAngle = 0.0;
  String _gear = 'Neutral';
  late StreamSubscription _positionSub;

  @override
  void initState() {
    super.initState();

    // Escuchar el stream de posiciones desde el repositorio
    _positionSub = repository.positionStream.listen((position) {
      print('X: ${position.X.toStringAsFixed(5)}, Y: ${position.Y.toStringAsFixed(5)}, Z: ${position.Z.toStringAsFixed(5)}');

      setState(() {
        // Integrar la velocidad en Z para volante
        _steeringAngle += position.Z * 0.05;

        // Cambiar marchas según X
        if (position.X > 5) {
          _gear = 'Forward';
        } else if (position.X < -5) {
          _gear = 'Reverse';
        } else {
          _gear = 'Neutral';
        }
      });
    });
  }

  @override
  void dispose() {
    _positionSub.cancel();
    repository.cancelSubscriptions();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Control de Volante')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Marcha: $_gear', style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 50),
          Center(
            child: Transform.rotate(
              angle: _steeringAngle,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[300],
                  border: Border.all(width: 5, color: Colors.black),
                ),
                child: const Center(child: Icon(Icons.drive_eta, size: 50)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

