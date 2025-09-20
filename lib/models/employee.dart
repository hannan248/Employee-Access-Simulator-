class Employee {
  final String id;
  final int accessLevel;
  final String requestTime;
  final String room;

  const Employee({
    required this.id,
    required this.accessLevel,
    required this.requestTime,
    required this.room,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] as String,
      accessLevel: json['access_level'] as int,
      requestTime: json['request_time'] as String,
      room: json['room'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'access_level': accessLevel,
      'request_time': requestTime,
      'room': room,
    };
  }

  @override
  String toString() {
    return 'Employee{id: $id, accessLevel: $accessLevel, requestTime: $requestTime, room: $room}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Employee &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              accessLevel == other.accessLevel &&
              requestTime == other.requestTime &&
              room == other.room;

  @override
  int get hashCode =>
      id.hashCode ^ accessLevel.hashCode ^ requestTime.hashCode ^ room.hashCode;
}