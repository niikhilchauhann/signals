import 'package:flutter/material.dart';

/// Centralized design tokens for the Signals app.
/// All screens must use these constants for visual consistency.
abstract class AppRadius {
  static const double card = 16.0;
  static const double cardLarge = 18.0;
  static const double chip = 12.0;
  static const double button = 12.0;
  static const double input = 14.0;
  static const double pill = 10.0;
}

abstract class AppSpacing {
  static const double screenPadding = 16.0;
  static const double cardPadding = 16.0;
  static const double sectionGap = 20.0;
  static const double itemGap = 12.0;
  static const double chipGap = 10.0;
  static const double innerGap = 8.0;
  static const double tinyGap = 4.0;
}

abstract class AppShadows {
  /// Standard card shadow — subtle, matches IPO/Watchlist screens
  static const List<BoxShadow> card = [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 10,
      offset: Offset(0, 6),
    ),
  ];

  /// Elevated card shadow — for featured/hero cards
  static const List<BoxShadow> elevated = [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 16,
      offset: Offset(0, 10),
    ),
  ];

  /// Subtle shadow — for chips, pills, small elements
  static const List<BoxShadow> subtle = [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> none = [];
}

abstract class AppGradients {
  /// Screen background gradient — matches IPO/Watchlist
  static const LinearGradient screenBackground = LinearGradient(
    colors: [Color(0xFFF7F9FF), Color(0xFFEFF2FF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Card fill gradient — subtle white to light blue
  static const LinearGradient cardFill = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF3F6FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

abstract class AppBorders {
  /// Standard card border color
  static const Color cardBorder = Color(0xFFE3E7F3);

  /// Standard card border side
  static BorderSide get cardBorderSide =>
      const BorderSide(color: cardBorder);

  /// Chip border (unselected)
  static BorderSide get chipBorderSide =>
      const BorderSide(color: cardBorder);
}

abstract class AppDecorations {
  /// Standard card decoration — used across all screens
  static BoxDecoration card({
    bool useGradient = true,
    double radius = AppRadius.card,
    List<BoxShadow> shadow = AppShadows.card,
  }) {
    return BoxDecoration(
      gradient: useGradient ? AppGradients.cardFill : null,
      color: useGradient ? null : Colors.white,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: AppBorders.cardBorder),
      boxShadow: shadow,
    );
  }

  /// Screen background decoration
  static const BoxDecoration screenBackground = BoxDecoration(
    gradient: AppGradients.screenBackground,
  );

  /// Metric / pill chip decoration
  static BoxDecoration metricPill({Color? backgroundColor}) {
    return BoxDecoration(
      color: backgroundColor ?? const Color(0xFFEFF2FB),
      borderRadius: BorderRadius.circular(AppRadius.pill),
    );
  }

  /// Chip decoration for filter/status chips
  static BoxDecoration chip({
    required Color color,
    bool isSelected = false,
  }) {
    return BoxDecoration(
      color: color.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(AppRadius.chip),
      border: Border.all(color: color.withValues(alpha: 0.25)),
    );
  }

  /// Info row / highlight container
  static BoxDecoration infoContainer({double radius = AppRadius.chip}) {
    return BoxDecoration(
      color: const Color(0xFFEFF2FB),
      borderRadius: BorderRadius.circular(radius),
    );
  }

  /// Stat card decoration (used in IPO stats, market metrics)
  static BoxDecoration statCard() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppRadius.input),
      border: Border.all(color: AppBorders.cardBorder),
      boxShadow: AppShadows.subtle,
    );
  }
}
