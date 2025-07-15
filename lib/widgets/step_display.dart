import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/step_tracker.dart';

class StepDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tracker = Provider.of<StepTracker>(context);
    final isLoading = tracker.isLoading;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade100, Colors.green.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: isLoading
            ? CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 4,
        )
            : Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: Colors.white.withOpacity(0.85),
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.directions_walk,
                    size: 60, color: Colors.green.shade700),
                SizedBox(height: 16),
                Text("Steps Today",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.green.shade800,
                    )),
                SizedBox(height: 10),
                Text(
                  "${tracker.steps}",
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Source: ${tracker.source}",
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                SizedBox(height: 6),
                Text(
                  "Last Updated: ${tracker.lastUpdatedFormatted}",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
