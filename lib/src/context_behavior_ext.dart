//import 'package:flutter/widgets.dart';
//import 'package:hydra/src/breakpoint.dart';
//import 'package:hydra/src/hydra_head.dart';
//import 'package:hydra/src/hydra_neck.dart';
//import 'package:provider/provider.dart';
//
//extension BreakpointExtension on BuildContext {
//  Breakpoint breakpoint() {
//    return Provider.of<Breakpoint>(this);
//  }
//
////  T whenBreakPoint<T>({T mini, T small, T medium, T large}) {
////    assert(mini != null || small != null || medium != null || large != null);
////
////    return Provider.of<Breakpoint>(this);
////  }
//
//  T onBreakpoint<T>({T mini, T small, T medium, T large}) {
//    assert(mini != null || small != null || medium != null || large != null);
//
//    var foundWidget =
//        (dependOnInheritedWidgetOfExactType(aspect: HydraHead) as HydraHead);
//
//    assert(foundWidget != null);
//
//    var currentBreakpoint = foundWidget.breakpoint;
//    HydraNeck nextPossible;
//    var distance = Breakpoint.values.length;
//
//    var widgets = <HydraNeck>[];
//
//    if (mini != null) {
//      widgets.add(HydraNeck.mini(mini));
//    }
//    if (small != null) {
//      widgets.add(HydraNeck.small(small));
//    }
//    if (medium != null) {
//      widgets.add(HydraNeck.medium(medium));
//    }
//    if (large != null) {
//      widgets.add(HydraNeck.large(large));
//    }
//
//    // collect possible alternatives
//    var alternatives = <HydraNeck>[
//      ...widgets.where(
//        (element) =>
//            (element.breakpoint.index <= currentBreakpoint.index) ||
//            (element.breakpoint.index >= currentBreakpoint.index),
//      )
//    ]..reversed;
//
//    // choose the widget with shortest distance to nearest breakpoint
//    for (var hydraHead in alternatives) {
//      var current =
//          (currentBreakpoint.index - hydraHead.breakpoint.index).abs();
//
//      if (current < distance) {
//        nextPossible = hydraHead;
//        distance = current;
//      }
//    }
//
//    return nextPossible.object;
//  }
//}
