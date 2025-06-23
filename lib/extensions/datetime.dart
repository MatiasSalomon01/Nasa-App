extension DatetimeExtensions on DateTime {
  String toDateQuery() {
    return toString().split(' ').first;
  }
}
