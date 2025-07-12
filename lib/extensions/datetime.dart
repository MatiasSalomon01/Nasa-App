extension DatetimeExtensions on DateTime {
  String toDateQuery() {
    return toString().split(' ').first;
  }

  String toView() {
    var year = this.year.toString().padLeft(2, '0');
    var month = this.month.toString().padLeft(2, '0');
    var day = this.day.toString().padLeft(2, '0');
    return '$day/$month/$year';
  }
}
