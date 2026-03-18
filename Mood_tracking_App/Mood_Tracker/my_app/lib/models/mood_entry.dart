class MoodEntry {
  String? moodOwnerName;
  String? moodOwnerNickname;
  String? moodOwnerAge;
  String? moodEmotion;
  double? moodIntensity;
  String? moodWeather;
  bool? didExercise;
  DateTime moodTimestamp; //make non-nullable

  MoodEntry({
    required this.moodOwnerName,
    required this.moodOwnerNickname,
    required this.moodOwnerAge,
    required this.moodEmotion,
    required this.moodIntensity,
    required this.moodWeather,
    required this.didExercise,
    DateTime? moodTimestamp,
  }) : moodTimestamp = moodTimestamp ?? DateTime.now(); //default: now
}
