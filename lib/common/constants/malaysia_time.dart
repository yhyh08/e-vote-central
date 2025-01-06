class MalaysiaTime {
  static DateTime now() {
    return DateTime.now().toUtc().add(const Duration(hours: 8));
  }

  static DateTime fromDateTime(DateTime dateTime) {
    return dateTime.toUtc().add(const Duration(hours: 8));
  }
}
