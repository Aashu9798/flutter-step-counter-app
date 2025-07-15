import 'dart:async';
import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

import 'storage_service.dart';

class StepTracker with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final _storage = StorageService();
  final Health _health = Health();
  int? _initialStepCount;

  String? _lastUpdated;
  String get lastUpdatedFormatted =>
      _lastUpdated != null ? _lastUpdated!.split("T").join(" ") : "N/A";

  int _steps = 0;
  String _source = "Unknown";

  int get steps => _steps;
  String get source => _source;

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    await _health.configure();
    _lastUpdated = await _storage.getLastUpdated(_dateKey());

    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);

    try {
      bool isAvailable = await _health.isHealthConnectAvailable();
      if (!isAvailable) {
        print("Health Connect not available.");
        _fallbackToPedometer();
        return;
      }

      final granted = await _health.requestAuthorization([HealthDataType.STEPS]);
      if (granted) {
        final count = await _health.getTotalStepsInInterval(start, now);
        _steps = count ?? 0;
        _source = "Health Connect";
        await _storage.saveStepData(_dateKey(), _steps);
        _lastUpdated = DateTime.now().toUtc().toIso8601String();
        notifyListeners();
        return;
      } else {
        print("Health Connect permission denied");
      }
    } catch (e) {
      print("Health Connect error: $e");
    }

    _fallbackToPedometer();
  }

  void _fallbackToPedometer() async {
    _source = "Pedometer";

    final status = await Permission.activityRecognition.request();
    if (status.isGranted) {
      _startPedometer();
    } else {
      print("Activity Recognition permission denied.");
      _isLoading = false;
      notifyListeners();
    }
  }

  void _startPedometer() async {
    print("Pedometer started...");

    Pedometer.stepCountStream.listen((StepCount event) async {
      print("Pedometer event: ${event.steps}");

      if (_initialStepCount == null) {
        _initialStepCount = await _storage.getInitialStepCount(_dateKey()) ?? event.steps;
        await _storage.saveInitialStepCount(_dateKey(), _initialStepCount!);
        print("Initial step count baseline: $_initialStepCount");
      }

      _steps = (event.steps - _initialStepCount!).clamp(0, double.infinity).toInt();
      print("Current session steps: $_steps");

      await _storage.saveStepData(_dateKey(), _steps);
      _lastUpdated = DateTime.now().toUtc().toIso8601String();

      _isLoading = false;
      notifyListeners();
    }).onError((error) {
      print("Pedometer error: $error");
      _isLoading = false;
      notifyListeners();
    });
  }

  String _dateKey() {
    final now = DateTime.now();
    return "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }
}
