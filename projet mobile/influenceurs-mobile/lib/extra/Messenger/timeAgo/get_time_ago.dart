import 'package:intl/intl.dart';

import 'messages/languages/fr_msg.dart';
import 'messages/messages.dart';

class GetTimeAgo {
  static String _default = 'fr';

  static final Map<String, Messages> _message_Map = {
    'fr': FrenchMessages(),
  };


  static void setDefaultLocale(String locale) {
    assert(_message_Map.containsKey(locale), '[locale] doit être une locale valide');
    _default = locale;
  }

  //Cette fonction prend une date et une heure, calcule le temps écoulé par rapport à la date et l'heure actuelles, et génère un message relatif au temps écoulé dans un format spécifique.
  static List<dynamic> parseWithSeconds(DateTime dateTime, {String? localeT}) {
    final locale = localeT ?? _default;
    final message_ = _message_Map[locale] ?? FrenchMessages();
    final date = DateFormat("dd MMM, yyyy hh:mm aa").format(dateTime);
    var elapsed =
        DateTime.now().millisecondsSinceEpoch - dateTime.millisecondsSinceEpoch; // le temps écoulé en millisecondes entre dateTime et maintenant.

    var prefix_ = message_.prefixAgo();
    var suffix_ = message_.suffixAgo();

  
   //Temps écoulé en secondes, minutes, heures et jours
    final num seconds = elapsed / 1000;
    final num minutes = seconds / 60;
    final num hours = minutes / 60;
    final num days = hours / 24;

    String msg;
    String result;
    if (seconds < 59) {
      msg = message_.secsAgo(seconds.round());
      result = [prefix_, msg, suffix_]
          .where((res) => res.isNotEmpty)
          .join(message_.wordSeparator());
    } else if (seconds < 119) {
      msg = message_.minAgo(minutes.round());
      result = [prefix_, msg, suffix_]
          .where((res) => res.isNotEmpty)
          .join(message_.wordSeparator());
    } else if (minutes < 59) {
      msg = message_.minsAgo(minutes.round());
      result = [prefix_, msg, suffix_]
          .where((res) => res.isNotEmpty)
          .join(message_.wordSeparator());
    } else if (minutes < 119) {
      msg = message_.hourAgo(hours.round());
      result = [prefix_, msg, suffix_]
          .where((res) => res.isNotEmpty)
          .join(message_.wordSeparator());
    } else if (hours < 24) {
      msg = message_.hoursAgo(hours.round());
      result = [prefix_, msg, suffix_]
          .where((res) => res.isNotEmpty)
          .join(message_.wordSeparator());
    } else if (hours < 48) {
      msg = message_.dayAgo(hours.round());
      result = [prefix_, msg, suffix_]
          .where((res) => res.isNotEmpty)
          .join(message_.wordSeparator());
    } else if (days < 8) {
      msg = message_.daysAgo(days.round());
      result = [prefix_, msg, suffix_]
          .where((res) => res.isNotEmpty)
          .join(message_.wordSeparator());
    } else {
      msg = date;
      result = date;
    }

    return [result, seconds]; // result (la représentation du temps écoulé) et seconds (le nombre de secondes écoulées depuis dateTime)
  }

  static String parse(DateTime dateTime, {String? localeT}) {
    final locale_ = localeT ?? _default;
    final message_ = _message_Map[locale_] ?? FrenchMessages();
    final date = DateFormat("dd MMM, yyyy hh:mm aa").format(dateTime);
    var elapsed =
        DateTime.now().millisecondsSinceEpoch - dateTime.millisecondsSinceEpoch;

    var prefix_ = message_.prefixAgo();
    var suffix_ = message_.suffixAgo();

   
    final num seconds = elapsed / 1000;
    final num minutes = seconds / 60;
    final num hours = minutes / 60;
    final num days = hours / 24;

    String msg;
    String result;
    if (seconds < 59) {
      msg = message_.secsAgo(seconds.round());
      result = [prefix_, msg, suffix_]
          .where((res) => res.isNotEmpty)
          .join(message_.wordSeparator());
    } else if (seconds < 119) {
      msg = message_.minAgo(minutes.round());
      result = [prefix_, msg, suffix_]
          .where((res) => res.isNotEmpty)
          .join(message_.wordSeparator());
    } else if (minutes < 59) {
      msg = message_.minsAgo(minutes.round());
      result = [prefix_, msg, suffix_]
          .where((res) => res.isNotEmpty)
          .join(message_.wordSeparator());
    } else if (minutes < 119) {
      msg = message_.hourAgo(hours.round());
      result = [prefix_, msg, suffix_]
          .where((res) => res.isNotEmpty)
          .join(message_.wordSeparator());
    } else if (hours < 24) {
      msg = message_.hoursAgo(hours.round());
      result = [prefix_, msg, suffix_]
          .where((res) => res.isNotEmpty)
          .join(message_.wordSeparator());
    } else if (hours < 48) {
      msg = message_.dayAgo(hours.round());
      result = [prefix_, msg, suffix_]
          .where((res) => res.isNotEmpty)
          .join(message_.wordSeparator());
    } else if (days < 8) {
      msg = message_.daysAgo(days.round());
      result = [prefix_, msg, suffix_]
          .where((res) => res.isNotEmpty)
          .join(message_.wordSeparator());
    } else {
      msg = date;
      result = date;
    }

    return result;
  }

  static String getTimeAgo(DateTime? date) {
    if (date == null) {
      return "";
    } else if (DateTime.now().difference(date).inSeconds < 10) {
      return "Maintenant";
    } else if (DateTime.now().difference(date).inDays < 1) {
      return parseWithSeconds(date)[0];
    } else if (DateTime.now().difference(date).inDays < 7) {
      return DateFormat('EEE à HH:mm').format(date).toUpperCase();
    } else if (DateTime.now().difference(date).inDays < 365) {
      return DateFormat('MMM, dd à HH:mm').format(date).toUpperCase();
    } else {
      return DateFormat('MMM, dd yyyy à HH:mm').format(date).toUpperCase();
    }
  }

  static String getTimeAgoInMessage(DateTime? date) {
    if (date == null) {
      return "";
    } else {
      return DateFormat('dd.MM.yyyy  HH:mm').format(date);
    }
  }

  static String getTimeAgoShort(DateTime? date) {
    if (date == null) {
      return "";
    } else if (DateTime.now().difference(date).inDays < 1) {
      return DateFormat('HH:mm').format(date);
    } else if (DateTime.now().difference(date).inDays < 7) {
      return DateFormat('EEE').format(date);
    } else if (DateTime.now().difference(date).inDays < 365) {
      return DateFormat('MMM, dd').format(date);
    } else {
      return DateFormat('MMM, dd yyyy').format(date);
    }
  }
}
