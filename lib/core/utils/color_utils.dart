import 'package:flutter/material.dart';

/// Parses a `#RRGGBB` / `RRGGBB` hex string into a [Color].
/// Returns [fallback] when the value is null or unparseable.
Color parseHexColor(String? hex, {Color fallback = Colors.grey}) {
  if (hex == null || hex.trim().isEmpty) return fallback;
  var value = hex.trim().replaceFirst('#', '');
  if (value.length == 6) value = 'ff$value';
  if (value.length != 8) return fallback;
  final parsed = int.tryParse(value, radix: 16);
  return parsed == null ? fallback : Color(parsed);
}

/// Picks a readable foreground colour (black/white) for a given background.
Color onColorFor(Color background) =>
    background.computeLuminance() > 0.5 ? Colors.black87 : Colors.white;
