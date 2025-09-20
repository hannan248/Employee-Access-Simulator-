class RoomRule {
  final int minAccessLevel;
  final String openTime;
  final String closeTime;
  final int cooldownMinutes;

  const RoomRule({
    required this.minAccessLevel,
    required this.openTime,
    required this.closeTime,
    required this.cooldownMinutes,
  });

  factory RoomRule.fromJson(Map<String, dynamic> json) {
    return RoomRule(
      minAccessLevel: json['min_access_level'] as int,
      openTime: json['open_time'] as String,
      closeTime: json['close_time'] as String,
      cooldownMinutes: json['cooldown_minutes'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'min_access_level': minAccessLevel,
      'open_time': openTime,
      'close_time': closeTime,
      'cooldown_minutes': cooldownMinutes,
    };
  }

  @override
  String toString() {
    return 'RoomRule{minAccessLevel: $minAccessLevel, openTime: $openTime, closeTime: $closeTime, cooldownMinutes: $cooldownMinutes}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is RoomRule &&
              runtimeType == other.runtimeType &&
              minAccessLevel == other.minAccessLevel &&
              openTime == other.openTime &&
              closeTime == other.closeTime &&
              cooldownMinutes == other.cooldownMinutes;

  @override
  int get hashCode =>
      minAccessLevel.hashCode ^
      openTime.hashCode ^
      closeTime.hashCode ^
      cooldownMinutes.hashCode;
}