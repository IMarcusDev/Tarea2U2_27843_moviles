import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tarea2u2_app/src/presentation/viewmodels/driving_viewmodel.dart';

class GyroscopeView extends StatelessWidget {
  const GyroscopeView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DrivingProvider>();

    Color speedColor = Colors.cyanAccent;
    if (provider.speed.abs() > 120) speedColor = Colors.redAccent;
    else if (provider.speed.abs() > 80) speedColor = Colors.amberAccent;

    TextStyle digitalStyle = TextStyle(
      color: speedColor,
      fontWeight: FontWeight.w900,
      fontFamily: 'Courier',
      shadows: [BoxShadow(color: speedColor.withOpacity(0.6), blurRadius: 20, spreadRadius: 5)]
    );

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
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: const BoxDecoration(border: Border(right: BorderSide(color: Colors.white10))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  provider.gearStatus.toUpperCase(),
                                  style: const TextStyle(color: Colors.white54, fontSize: 18, letterSpacing: 3, fontWeight: FontWeight.bold)
                                ),
                                const Spacer(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildTurnSignal(Icons.arrow_left, provider.leftSignal),
                                    const SizedBox(width: 10),
                                    Flexible(
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          provider.speed.abs().toStringAsFixed(0),
                                          style: digitalStyle.copyWith(fontSize: 120)
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    _buildTurnSignal(Icons.arrow_right, provider.rightSignal),
                                  ],
                                ),
                                Text('KM/H', style: TextStyle(color: speedColor, fontSize: 20, fontWeight: FontWeight.bold)),
                                const Spacer(),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: Transform.rotate(
                              angle: provider.steeringAngle,
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 50, spreadRadius: 5)]
                                ),
                                child: Image.asset('assets/steering_wheel.png', fit: BoxFit.contain, width: 250, height: 250),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    color: Colors.black45,
                    child: Row(
                      children: [
                        const Text("PWR", style: TextStyle(color: Colors.white30, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 15),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: ShaderMask(
                              shaderCallback: (Rect bounds) {
                                return const LinearGradient(
                                  colors: [Colors.green, Colors.yellow, Colors.red],
                                  stops: [0.0, 0.7, 1.0],
                                ).createShader(bounds);
                              },
                              child: LinearProgressIndicator(
                                value: (provider.speed.abs() / 160).clamp(0.0, 1.0),
                                minHeight: 10,
                                backgroundColor: Colors.grey[900],
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        const Text("SPORT", style: TextStyle(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 20,
                right: 20,
                child: IconButton(
                  onPressed: () {
                    context.read<DrivingProvider>().calibrateSensors();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Calibrado"), duration: Duration(milliseconds: 500)));
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

  Widget _buildTurnSignal(IconData icon, bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.green.withOpacity(0.2) : Colors.transparent,
        boxShadow: isActive ? [BoxShadow(color: Colors.greenAccent.withOpacity(0.6), blurRadius: 15)] : [],
      ),
      child: Icon(icon, color: isActive ? Colors.greenAccent : Colors.white10, size: 50),
    );
  }
}