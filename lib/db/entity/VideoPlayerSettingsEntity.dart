class VideoPlayerSettingsEntity {
  int? id;
  String videoId;
  String videoTitle;
  double skipOpening;
  double skipEnding;
  double volume;
  double brightness;
  int videoFit;
  double playbackRate;
  double longPressRate;
  DateTime updatedAt;

  VideoPlayerSettingsEntity({
    this.id,
    required this.videoId,
    required this.videoTitle,
    this.skipOpening = 0.0,
    this.skipEnding = 0.0,
    this.volume = 1.0,
    this.brightness = 1.0,
    this.videoFit = 0,
    this.playbackRate = 1.0,
    this.longPressRate = 2.0,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'video_id': videoId,
      'video_title': videoTitle,
      'skip_opening': skipOpening,
      'skip_ending': skipEnding,
      'volume': volume,
      'brightness': brightness,
      'video_fit': videoFit,
      'playback_rate': playbackRate,
      'long_press_rate': longPressRate,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory VideoPlayerSettingsEntity.fromMap(Map<String, dynamic> map) {
    return VideoPlayerSettingsEntity(
      id: map['id'],
      videoId: map['video_id'],
      videoTitle: map['video_title'],
      skipOpening: (map['skip_opening'] as num?)?.toDouble() ?? 0.0,
      skipEnding: (map['skip_ending'] as num?)?.toDouble() ?? 0.0,
      volume: (map['volume'] as num?)?.toDouble() ?? 1.0,
      brightness: (map['brightness'] as num?)?.toDouble() ?? 1.0,
      videoFit: (map['video_fit'] as num?)?.toInt() ?? 0,
      playbackRate: (map['playback_rate'] as num?)?.toDouble() ?? 1.0,
      longPressRate: (map['long_press_rate'] as num?)?.toDouble() ?? 2.0,
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  VideoPlayerSettingsEntity copyWith({
    int? id,
    String? videoId,
    String? videoTitle,
    double? skipOpening,
    double? skipEnding,
    double? volume,
    double? brightness,
    int? videoFit,
    double? playbackRate,
    double? longPressRate,
    DateTime? updatedAt,
  }) {
    return VideoPlayerSettingsEntity(
      id: id ?? this.id,
      videoId: videoId ?? this.videoId,
      videoTitle: videoTitle ?? this.videoTitle,
      skipOpening: skipOpening ?? this.skipOpening,
      skipEnding: skipEnding ?? this.skipEnding,
      volume: volume ?? this.volume,
      brightness: brightness ?? this.brightness,
      videoFit: videoFit ?? this.videoFit,
      playbackRate: playbackRate ?? this.playbackRate,
      longPressRate: longPressRate ?? this.longPressRate,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
