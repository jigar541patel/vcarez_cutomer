enum ThemeType {
  light,
  dark,
  systemDefault,
}

extension ThemeTypeExtension on ThemeType {
  int get value {
    switch (this) {
      case ThemeType.light:
        return 1;
      case ThemeType.dark:
        return 2;
      case ThemeType.systemDefault:
        return 0;
      default:
        return 0;
    }
  }
}
