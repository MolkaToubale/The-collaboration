import '../messages.dart';

/// Arabic Messages
class ArabicMessages implements Messages {
  @override
  String prefixAgo() => '';

  @override
  String prefixFromNow() => '';

  @override
  String suffixAgo() => 'مرت';

  @override
  String suffixFromNow() => 'من الان';

  @override
  String secsAgo(int seconds) => '$seconds ثواني';

  @override
  String minAgo(int minutes) => 'دقيقة';

  @override
  String minsAgo(int minutes) => '$minutes دقائق';

  @override
  String hourAgo(int minutes) => 'ساعة';

  @override
  String hoursAgo(int hours) => '$hours ساعات';

  @override
  String dayAgo(int hours) => 'يوم';

  @override
  String daysAgo(int days) => '$days أيام';

  @override
  String wordSeparator() => ' ';
}
