import 'package:tarea2u2_app/src/domain/entities/position.dart';

abstract class PositionRepository {
  Position? getPosition();
  void cancelSubscriptions();
}
