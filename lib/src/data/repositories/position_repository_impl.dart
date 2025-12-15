import 'package:tarea2u2_app/src/data/datasources/gyroscope_data_source.dart';
import 'package:tarea2u2_app/src/domain/entities/position.dart';
import 'package:tarea2u2_app/src/domain/repositories/position_repository.dart';

class PositionRepositoryImpl extends PositionRepository {
  GyroscopeDataSource datasource = GyroscopeDataSource();

  @override
  Position? getPosition() {
    return datasource.getPosition();
  }

  Stream<Position> get positionStream => datasource.positionStream;

  @override
  void cancelSubscriptions() {
    datasource.dispose();
  }
}
