import 'package:flutter/widgets.dart';

class NotifierProvider<T extends Listenable> extends InheritedNotifier<T> {
  const NotifierProvider({
    super.key,
    required T notifier,
    required Widget child,
  }) : super(notifier: notifier, child: child);

  static T of<T extends Listenable>(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<NotifierProvider<T>>();
    assert(widget != null, 'NotifierProvider<$T> not found in context');
    return widget!.notifier!;
  }
}
