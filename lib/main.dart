import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/step_tracker.dart';
import 'widgets/step_display.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => StepTracker()..init(),
      child: const StepApp(),
    ),
  );
}

class StepApp extends StatelessWidget {
  const StepApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Step Tracker',
      theme: ThemeData(primarySwatch: Colors.green),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Step Counter"),
          centerTitle: true,
          backgroundColor: Colors.green.shade700.withOpacity(0.9),
          elevation: 0,
        ),
        body: StepDisplay(),
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.read<StepTracker>().init(),
          tooltip: 'Refresh Step Count',
          backgroundColor: Colors.green.shade800,
          child: Icon(Icons.refresh, color: Colors.white),
        ),
      ),
    );
  }
}
