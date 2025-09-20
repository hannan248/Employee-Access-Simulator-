// lib/widgets/simulation_button.dart
import 'package:flutter/material.dart';

class SimulationButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isSimulated;

  const SimulationButton({
    Key? key,
    required this.onPressed,
    this.isLoading = false,
    this.isSimulated = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSimulated ? Colors.green : Colors.indigo,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
        ),
        child: isLoading
            ? const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        )
            : Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSimulated ? Icons.refresh : Icons.play_arrow,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              isSimulated ? 'Run New Simulation' : 'Simulate Access',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}