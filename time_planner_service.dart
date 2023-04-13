import 'package:intl/intl.dart';
import 'package:time_planner/time_planner.dart';

/* -------------------------------------------------------------------------- */
/*                            Time Planner Service                            */
/* -------------------------------------------------------------------------- */

class TimePlannerService {
  late final DateTime _startDay;
  late final DateTime _endDay;
  late final DateFormat _titleFormat;
  late final DateFormat _dateFormat;
  late final TimePlannerStyle _style;
  late final bool _currentTimeAnimation;
  late final List<TimePlannerTitle> _headers;

  TimePlannerService(
      {required DateTime startDay,
      required DateTime endDay,
      DateFormat? titleFormat,
      DateFormat? dateFormat,
      TimePlannerStyle? style,
      bool? currentTimeAnimation}) {
    _startDay = startDay;
    _endDay = endDay;
    _titleFormat = _isNull(DateFormat.EEEE('fr_FR'), titleFormat);
    _dateFormat = _isNull(DateFormat.yMd('fr_FR'), dateFormat);
    _style = _isNull(TimePlannerStyle(showScrollBar: true), style);
    _currentTimeAnimation = _isNull(false, currentTimeAnimation);
    _headers = _setHeaders();
  }

  /* --------------------------- Méthodes Publiques --------------------------- */

  /// Retourne un TimePlannerDateTime.
  dynamic getTimePlannerDateTime(DateTime date) {
    final String dateFormat = _dateFormat.format(date);
    for (TimePlannerTitle header in _headers) {
      if (dateFormat == header.date) {
        final int day = _headers.indexOf(header);
        return TimePlannerDateTime(
            day: day, hour: date.hour, minutes: date.minute);
      }
    }
    return false;
  }

  /// Retourne un TimePlanner.
  TimePlanner getTimePlanner(List<TimePlannerTask> tasks) {
    return TimePlanner(
      startHour: _startDay.hour,
      endHour: _endDay.hour,
      headers: _headers,
      tasks: tasks,
      style: _style,
      currentTimeAnimation: _currentTimeAnimation,
    );
  }

  /* ---------------------------- Méthodes Privées ---------------------------- */

  /// Retourne une liste de TimePlannerTitle.
  List<TimePlannerTitle> _setHeaders() {
    final List<TimePlannerTitle> headers = [];
    for (DateTime i = _startDay;
        i.isBefore(_endDay);
        i = i.add(const Duration(days: 1))) {
      String title = _titleFormat.format(i);
      String date = _dateFormat.format(i);
      TimePlannerTitle header = TimePlannerTitle(title: title, date: date);
      headers.add(header);
    }
    return headers;
  }

  /// Retourne une valeur par défaut si la valeur est nulle.
  dynamic _isNull(dynamic defaultValue, dynamic value) =>
      (value == null) ? defaultValue : value;
}
