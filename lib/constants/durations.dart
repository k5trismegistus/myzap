class Duration {
  final int durationSeconds;
  final String icon;

  Duration(this.durationSeconds, this.icon);
}

final List Durations = [
  Duration(60 * 10, 'assets/images/duration_10min.png'),
  Duration(60 * 30, 'assets/images/duration_30min.png'),
  Duration(60 * 60, 'assets/images/duration_1hour.png'),
  Duration(60 * 60 * 8, 'assets/images/duration_1day.png'),
];