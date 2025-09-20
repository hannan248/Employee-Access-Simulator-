import 'package:flutter/services.dart';
import 'dart:convert';
import '../models/employee.dart';
import '../models/room_rule.dart';
import '../models/access_result.dart';
import '../utils/time_utils.dart';

class DataService {
  static const String _employeeDataPath = 'assets/data/employees.json';

  // Room rules configuration - could also be loaded from JSON
  static final Map<String, RoomRule> roomRules = {
    'ServerRoom': const RoomRule(
      minAccessLevel: 2,
      openTime: '09:00',
      closeTime: '11:00',
      cooldownMinutes: 15,
    ),
    'Vault': const RoomRule(
      minAccessLevel: 3,
      openTime: '09:00',
      closeTime: '10:00',
      cooldownMinutes: 30,
    ),
    'R&D Lab': const RoomRule(
      minAccessLevel: 1,
      openTime: '08:00',
      closeTime: '12:00',
      cooldownMinutes: 10,
    ),
  };

  /// Load employee data from JSON file
  static Future<List<Employee>> loadEmployeeData() async {
    try {
      final String jsonString = await rootBundle.loadString(_employeeDataPath);
      final List<dynamic> jsonData = json.decode(jsonString);

      return jsonData.map((json) => Employee.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load employee data: $e');
    }
  }

  /// Get room rule for a specific room
  static RoomRule? getRoomRule(String roomName) {
    return roomRules[roomName];
  }

  /// Get all room names
  static List<String> getRoomNames() {
    return roomRules.keys.toList();
  }

  /// Check if request time is within room operating hours
  static bool isWithinOperatingHours(String requestTime, String roomName) {
    final RoomRule? rule = getRoomRule(roomName);
    if (rule == null) return false;

    final int requestMinutes = TimeUtils.timeToMinutes(requestTime);
    final int openMinutes = TimeUtils.timeToMinutes(rule.openTime);
    final int closeMinutes = TimeUtils.timeToMinutes(rule.closeTime);

    return requestMinutes >= openMinutes && requestMinutes <= closeMinutes;
  }

  /// Check if cooldown period is violated
  static bool isCooldownViolated(
      Employee currentRequest,
      List<AccessResult> previousAccesses,
      String roomName,
      ) {
    final RoomRule? rule = getRoomRule(roomName);
    if (rule == null) return false;

    final int currentMinutes = TimeUtils.timeToMinutes(currentRequest.requestTime);

    // Find previous granted accesses by the same employee to the same room
    final List<AccessResult> employeeRoomAccesses = previousAccesses
        .where((access) =>
    access.employee.id == currentRequest.id &&
        access.employee.room == roomName &&
        access.granted)
        .toList();

    // Check if any previous access violates cooldown
    return employeeRoomAccesses.any((access) {
      final int previousMinutes = TimeUtils.timeToMinutes(access.employee.requestTime);
      final int timeDiff = (currentMinutes - previousMinutes).abs();
      return timeDiff < rule.cooldownMinutes;
    });
  }

  /// Main simulation logic
  static List<AccessResult> simulateEmployeeAccess(List<Employee> employees) {
    if (employees.isEmpty) return [];

    final List<AccessResult> results = [];
    final List<AccessResult> processedAccesses = [];

    // Sort requests by time to process chronologically
    final List<Employee> sortedEmployees = List<Employee>.from(employees);
    sortedEmployees.sort((a, b) =>
        TimeUtils.timeToMinutes(a.requestTime)
            .compareTo(TimeUtils.timeToMinutes(b.requestTime)));

    for (int i = 0; i < sortedEmployees.length; i++) {
      final Employee employee = sortedEmployees[i];
      final String roomName = employee.room;
      final RoomRule? rule = getRoomRule(roomName);
      final int processOrder = i + 1;

      AccessResult result;

      // Check if room exists
      if (rule == null) {
        result = AccessResult.denied(
          employee: employee,
          reason: 'Unknown room: $roomName',
          processOrder: processOrder,
        );
      }
      // Check access level
      else if (employee.accessLevel < rule.minAccessLevel) {
        result = AccessResult.denied(
          employee: employee,
          reason: 'Access level ${employee.accessLevel} below required level ${rule.minAccessLevel}',
          processOrder: processOrder,
        );
      }
      // Check operating hours
      else if (!isWithinOperatingHours(employee.requestTime, roomName)) {
        result = AccessResult.denied(
          employee: employee,
          reason: '$roomName closed at ${employee.requestTime} (Open: ${rule.openTime}-${rule.closeTime})',
          processOrder: processOrder,
        );
      }
      // Check cooldown
      else if (isCooldownViolated(employee, processedAccesses, roomName)) {
        result = AccessResult.denied(
          employee: employee,
          reason: 'Cooldown violation (${rule.cooldownMinutes} min required)',
          processOrder: processOrder,
        );
      }
      // Grant access
      else {
        result = AccessResult.granted(
          employee: employee,
          room: roomName,
          processOrder: processOrder,
        );
      }

      results.add(result);
      processedAccesses.add(result);
    }

    return results;
  }
}