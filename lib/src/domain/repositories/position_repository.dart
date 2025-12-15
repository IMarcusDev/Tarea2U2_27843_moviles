import 'package:tarea2u2_app/src/domain/entities/position.dart';

abstract class PositionRepository {
  Stream<DrivingState> get drivingStream;

  void cancelSubscriptions();
}