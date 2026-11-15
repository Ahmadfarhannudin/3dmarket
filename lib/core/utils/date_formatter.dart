class DateFormatter {
  static const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];

  static String shortDate(DateTime date) {
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
