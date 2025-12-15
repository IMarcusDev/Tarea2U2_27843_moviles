import 'package:sensors_plus/sensors_plus.dart';
import 'package:tarea2u2_app/src/domain/entities/position.dart';

class PositionModel extends Position {
  PositionModel({
    required super.X,
    required super.Y,
    required super.Z,
  });

  factory PositionModel.fromEvent(GyroscopeEvent event) {
    return PositionModel(
      X: event.x,
      Y: event.y,
      Z: event.z,
    );
  }
}
