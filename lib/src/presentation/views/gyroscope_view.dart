import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tarea2u2_app/src/presentation/viewmodels/driving_viewmodel.dart';
import 'package:tarea2u2_app/src/presentation/widgets/dashboard_panel.dart';
import 'package:tarea2u2_app/src/presentation/widgets/steering_wheel_display.dart';
import 'package:tarea2u2_app/src/presentation/widgets/power_bar.dart';

class GyroscopeView extends StatelessWidget {
  const GyroscopeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(-0.3, 0),
            radius: 1.3,
            colors: [Colors.blueGrey[900]!, Colors.black],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    flex: 4,
                    child: Row(
                      children: const [
                        Expanded(flex: 1, child: DashboardPanel()),
                        Expanded(flex: 1, child: SteeringWheelDisplay()),
                      ],
                    ),
                  ),

                  const PowerBar(),
                ],
              ),

              Positioned(
                top: 20,
                right: 20,
                child: IconButton(
                  onPressed: () {
                    context.read<DrivingProvider>().calibrateSensors();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("¡Calibrado!"),
                        duration: Duration(milliseconds: 500),
                      ),
                    );
                  },
                  icon: const Icon(Icons.gps_fixed, color: Colors.white24),
                  tooltip: 'Calibrar Centro',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}