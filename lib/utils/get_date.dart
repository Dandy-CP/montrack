class GetDate {
  static Map<String, DateTime> thisWeek({
    void Function(Map<String, DateTime>)? onSelected,
  }) {
    DateTime now = DateTime.now();
    // Calculate the first day of the week (e.g., Monday or Sunday)
    // DateTime.monday has a value of 1, DateTime.sunday has a value of 7.
    // Adjust 'firstDayOfWeek' based on your desired start of the week.
    int firstDayOfWeek = DateTime.monday;

    // Calculate the difference in days to reach the first day of the current week
    int daysToSubtract = (now.weekday - firstDayOfWeek + 7) % 7;

    DateTime startOfWeek = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: daysToSubtract));

    // Calculate the last day of the week
    DateTime endOfWeek = startOfWeek.add(Duration(days: 6));

    if (onSelected != null) {
      onSelected({'startDate': startOfWeek, 'endDate': endOfWeek});
    }

    return {'startDate': startOfWeek, 'endDate': endOfWeek};
  }

  static Map<String, DateTime> thisMonth({
    void Function(Map<String, DateTime>)? onSelected,
  }) {
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    if (onSelected != null) {
      onSelected({'startDate': firstDayOfMonth, 'endDate': lastDayOfMonth});
    }

    return {'startDate': firstDayOfMonth, 'endDate': lastDayOfMonth};
  }
}
