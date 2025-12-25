class AppConstants {
  AppConstants._();

  // App strings
  static const String appTitle = 'Advanced Counter App';
  static const String counterLabel = 'Current Count';
  static const String resetButtonLabel = 'Reset Counter';

  // Counter configuration
  static const int initialCounterValue = 0;
  static const int minCounterValue = 0;
  static const int maxCounterValue = 999999;
  static const int incrementStep = 1;
  static const int defaultGoal = 100;

  // Animation durations
  static const int counterAnimationDuration = 300;
  static const int buttonPressAnimationDuration = 150;
  static const int confettiDuration = 3000;

  // UI configuration
  static const double counterFontSize = 72.0;
  static const double buttonSpacing = 16.0;
  static const double cardPadding = 32.0;

  // History
  static const int maxHistoryItems = 50;
  static const int displayHistoryItems = 5;
}
