import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tarea2u2_app/src/domain/repositories/position_repository.dart';
import 'package:tarea2u2_app/src/data/repositories/position_repository_impl.dart';
import 'package:vibration/vibration.dart';

class DrivingProvider extends ChangeNotifier {
  final PositionRepository _repository = PositionRepositoryImpl();

  double steeringAngle = 0.0;
  double speed = 0.0;
  String gearStatus = 'Neutro';

  double _rawThrottle = 0.0;
  double _throttleOffset = 0.0;
  bool leftSignal = false;
  bool rightSignal = false;

  StreamSubscription? _sensorSub;
  Timer? _physicsTimer;
  Timer? _hapticTimer;

  DrivingProvider() {
    _initSensors();
  }

  void _initSensors() {
    _sensorSub = _repository.drivingStream.listen((state) {

      steeringAngle += state.steeringDelta * 0.05;
      steeringAngle = steeringAngle.clamp(-2.5, 2.5);

      _rawThrottle = state.throttleTilt;

      bool newLeft = steeringAngle < -0.5;
      bool newRight = steeringAngle > 0.5;

      if ((newLeft && !leftSignal) || (newRight && !rightSignal)) {
        Vibration.vibrate(duration: 50, amplitude: 255);
      }

      leftSignal = newLeft;
      rightSignal = newRight;

      notifyListeners();
    });

    _physicsTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      _calculatePhysics();
      notifyListeners(); 
    });

    _hapticTimer = Timer.periodic(const Duration(milliseconds: 450), (_) {
      if (leftSignal || rightSignal) {
        Vibration.vibrate(duration: 30, amplitude: 100);
      }
    });
  }

  void _calculatePhysics() {
    double calibratedThrottle = _rawThrottle - _throttleOffset;

    if (calibratedThrottle < -2.0) {
      gearStatus = 'Acelerando';
      speed += 0.8;
      if (speed > 150) Vibration.vibrate(duration: 40, amplitude: 30);
    } else if (calibratedThrottle > 2.0) {
      gearStatus = 'Frenando';
      speed -= 1.2;
    } else {
      gearStatus = 'Neutro';
      speed *= 0.96;
    }
    speed = speed.clamp(-20.0, 160.0);
  }

  Future<void> calibrateSensors() async {
    _throttleOffset = _rawThrottle;
    steeringAngle = 0.0;
    
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(pattern: [0, 50, 50, 50]);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _sensorSub?.cancel();
    _physicsTimer?.cancel();
    _hapticTimer?.cancel();
    _repository.cancelSubscriptions();
    super.dispose();
  }
}