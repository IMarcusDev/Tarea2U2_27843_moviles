import 'package:tarea2u2_app/src/data/datasources/gyroscope_data_source.dart';
import 'package:tarea2u2_app/src/domain/entities/position.dart';
import 'package:tarea2u2_app/src/domain/repositories/position_repository.dart';


class PositionRepositoryImpl implements PositionRepository {
  final GyroscopeDataSource _datasource = GyroscopeDataSource();

  @override
  Stream<DrivingState> get drivingStream => _datasource.stream;

  @override
  void cancelSubscriptions() {
    _datasource.dispose();
  }
}
