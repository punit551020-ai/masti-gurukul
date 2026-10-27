/// Small formatting helpers shared by the Tests tab, the runner, the result
/// screen and the Progress tab, so numbers always look the same everywhere.
library;

/// 4.0 -> "4", 3.75 -> "3.75", -0.5 -> "-0.5".
String formatMarks(double value) {
  if (value == value.roundToDouble() && value.abs() < 1e15) {
    return value.toInt().toString();
  }
  var text = value.toStringAsFixed(2);
  while (text.endsWith('0')) {
    text = text.substring(0, text.length - 1);
  }
  if (text.endsWith('.')) text = text.substring(0, text.length - 1);
  return text;
}

/// 95 -> "01:35", 300 -> "05:00". Above one hour it switches to h:mm.
String formatClock(int totalSeconds) {
  final seconds = totalSeconds < 0 ? 0 : totalSeconds;
  if (seconds >= 3600) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    return '$hours:\$${minutes.toString().padLeft(2, '0')}';
  }
  final minutes = seconds ~/ 60;
  final rest = seconds % 60;
  return '${minutes.toString().padLeft(2, '0')}:${rest.toString().padLeft(2, '0')}';
}

/// Percentage of obtained marks, guarding against a zero-total test.
int? scorePercent(double score, double totalMarks) {
  if (totalMarks <= 0) return null;
  return (score / totalMarks * 100).round();
}
