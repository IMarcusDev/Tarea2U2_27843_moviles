import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:tarea2u2_app/src/data/models/position_model.dart';
import 'package:tarea2u2_app/src/domain/entities/position.dart';

class GyroscopeDataSource {
  final StreamController<DrivingState> _controller = StreamController<DrivingState>.broadcast();
  
  double _lastSteering = 0.0;
  double _lastThrottle = 0.0;

  StreamSubscription? _gyroSub;
  StreamSubscription? _accelSub;

  GyroscopeDataSource() {
    _gyroSub = gyroscopeEventStream().listen((GyroscopeEvent event) {
      _lastSteering = event.z;
      _emitState();
    });

    _accelSub = accelerometerEventStream().listen((AccelerometerEvent event) {
      _lastThrottle = event.x; 
      _emitState();
    });
  }

  void _emitState() {
    if (!_controller.isClosed) {
      _controller.add(PositionModel(
        steeringDelta: _lastSteering, 
        throttleTilt: _lastThrottle
      ));
    }
  }

  void dispose() {
    _gyroSub?.cancel();
    _accelSub?.cancel();
    _controller.close();
  }

  Stream<DrivingState> get stream => _controller.stream;
}