class AvailabilitySlotEntity {
  final int dayOfWeek; // 0 (Domingo) a 6 (Sábado)
  final String startTime; // Formato "HH:mm"
  final String endTime; // Formato "HH:mm"

  AvailabilitySlotEntity({
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
  });

  factory AvailabilitySlotEntity.fromJson(Map<String, dynamic> json) {
    return AvailabilitySlotEntity(
      dayOfWeek: json['dayOfWeek'] ?? json['day_of_week'] ?? 0,
      startTime: json['startTime'] ?? json['start_time'] ?? '',
      endTime: json['endTime'] ?? json['end_time'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dayOfWeek': dayOfWeek,
      'startTime': startTime,
      'endTime': endTime,
    };
  }
}
