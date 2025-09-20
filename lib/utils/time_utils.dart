class TimeUtils {
  /// Convert time string (HH:MM) to minutes since midnight
  static int timeToMinutes(String timeStr) {
    try {
      final List<String> parts = timeStr.split(':');
      if (parts.length != 2) {
        throw const FormatException('Invalid time format. Expected HH:MM');
      }

      final int hours = int.parse(parts[0]);
      final int minutes = int.parse(parts[1]);

      if (hours < 0 || hours > 23) {
        throw const FormatException('Invalid hour value. Must be between 0-23');
      }

      if (minutes < 0 || minutes > 59) {
        throw const FormatException('Invalid minute value. Must be between 0-59');
      }

      return hours * 60 + minutes;
    } catch (e) {
      throw FormatException('Failed to parse time "$timeStr": $e');
    }
  }

  /// Convert minutes since midnight back to time string (HH:MM)
  static String minutesToTime(int minutes) {
    if (minutes < 0 || minutes >= 1440) { // 1440 = 24 * 60
      throw ArgumentError('Minutes must be between 0 and 1439');
    }

    final int hours = minutes ~/ 60;
    final int mins = minutes % 60;

    return '${hours.toString().padLeft(2, '0')}:${mins.toString().padLeft(2, '0')}';
  }

  /// Calculate time difference in minutes between two time strings
  static int timeDifference(String time1, String time2) {
    final int minutes1 = timeToMinutes(time1);
    final int minutes2 = timeToMinutes(time2);

    return (minutes2 - minutes1).abs();
  }

  /// Check if a time is between two other times
  static bool isTimeBetween(String checkTime, String startTime, String endTime) {
    final int checkMinutes = timeToMinutes(checkTime);
    final int startMinutes = timeToMinutes(startTime);
    final int endMinutes = timeToMinutes(endTime);

    return checkMinutes >= startMinutes && checkMinutes <= endMinutes;
  }

  /// Format time string to be more readable
  static String formatTimeDisplay(String timeStr) {
    try {
      final List<String> parts = timeStr.split(':');
      final int hours = int.parse(parts[0]);
      final int minutes = int.parse(parts[1]);

      String period = hours >= 12 ? 'PM' : 'AM';
      int displayHours = hours > 12 ? hours - 12 : (hours == 0 ? 12 : hours);

      return '${displayHours.toString()}:${minutes.toString().padLeft(2, '0')} $period';
    } catch (e) {
      return timeStr; // Return original if parsing fails
    }
  }

  /// Validate time string format
  static bool isValidTimeFormat(String timeStr) {
    try {
      timeToMinutes(timeStr);
      return true;
    } catch (e) {
      return false;
    }
  }
}