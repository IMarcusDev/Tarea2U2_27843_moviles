import 'dart:async';

import 'package:sensors_plus/sensors_plus.dart';
import 'package:tarea2u2_app/src/data/models/position_model.dart';

class GyroscopeDataSource {
  late StreamSubscription<GyroscopeEvent> _gyroscopeEvent;
  final StreamController<PositionModel> _gyroscopeController = StreamController<PositionModel>.broadcast();
  PositionModel? _currentPosition;

  GyroscopeDataSource() {
    _gyroscopeEvent = gyroscopeEventStream().listen((GyroscopeEvent event) {
      _currentPosition = PositionModel.fromEvent(event);
      _gyroscopeController.add(_currentPosition!);
    });
  }

  void dispose() {
    _gyroscopeEvent.cancel();
    _gyroscopeController.close();
  }

  PositionModel? getPosition() => _currentPosition;
  Stream<PositionModel> get positionStream => _gyroscopeController.stream;
}
