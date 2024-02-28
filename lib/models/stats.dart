class Stats {
  final int total;
  final int confirmed;
  final int correct;

  Stats({
    required this.total,
    required this.correct,
    required this.confirmed,
  });

  double get accuracy {
    return correct / (confirmed / 100);
  }
}
