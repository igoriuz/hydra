import 'package:flutter/material.dart';

import 'breakpoint.dart';

class HydraNeck<T> {
  final T object;

  final Breakpoint breakpoint;

  HydraNeck._(this.object, this.breakpoint, {Key key});

  factory HydraNeck.mini(T widgetBehaviour) =>
      HydraNeck._(widgetBehaviour, Breakpoint.mini);

  factory HydraNeck.small(T widgetBehaviour) =>
      HydraNeck._(widgetBehaviour, Breakpoint.small);

  factory HydraNeck.medium(T widgetBehaviour) =>
      HydraNeck._(widgetBehaviour, Breakpoint.medium);

  factory HydraNeck.large(T widgetBehaviour) =>
      HydraNeck._(widgetBehaviour, Breakpoint.large);
}
