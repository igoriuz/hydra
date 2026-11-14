import 'package:flutter/widgets.dart';
import 'package:hydra/src/breakpoint.dart';
import 'package:hydra/src/hydra_behaviour.dart';
import 'package:hydra/src/hydra_resolver.dart';
import 'package:hydra/src/hydra_scope.dart';

/// [HydraGrid] is a grid whose column count depends on the current
/// breakpoint.
///
/// At least one of [mini], [small], [medium], or [large] must be provided.
/// A breakpoint without a column count falls back to the nearest one that
/// has, like `HydraWidget` does.
///
/// ```dart
/// HydraGrid(
///   mini: 1,
///   small: 2,
///   medium: 3,
///   large: 4,
///   children: items,
/// )
/// ```
///
/// The grid is a [GridView]; the layout parameters are passed through. Use
/// [HydraGrid.builder] to build the children lazily.
class HydraGrid extends StatelessWidget {
  /// Creates a [HydraGrid] with a column count per breakpoint.
  const HydraGrid({
    required this.children,
    this.mini,
    this.small,
    this.medium,
    this.large,
    this.behaviour,
    this.mainAxisSpacing = 0,
    this.crossAxisSpacing = 0,
    this.childAspectRatio = 1,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
    super.key,
  })  : itemBuilder = null,
        itemCount = null,
        assert(
          mini != null || small != null || medium != null || large != null,
          'At least one column count is needed',
        );

  /// Creates a [HydraGrid] that builds its children on demand, for long or
  /// infinite grids. See [GridView.builder].
  const HydraGrid.builder({
    required NullableIndexedWidgetBuilder this.itemBuilder,
    this.itemCount,
    this.mini,
    this.small,
    this.medium,
    this.large,
    this.behaviour,
    this.mainAxisSpacing = 0,
    this.crossAxisSpacing = 0,
    this.childAspectRatio = 1,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
    super.key,
  })  : children = const [],
        assert(
          mini != null || small != null || medium != null || large != null,
          'At least one column count is needed',
        );

  /// The widgets to lay out in the grid. Empty for [HydraGrid.builder].
  final List<Widget> children;

  /// Builds the children on demand. Only set by [HydraGrid.builder].
  final NullableIndexedWidgetBuilder? itemBuilder;

  /// The number of children of [HydraGrid.builder]; `null` for an infinite
  /// grid.
  final int? itemCount;

  /// Number of columns at the mini breakpoint.
  final int? mini;

  /// Number of columns at the small breakpoint.
  final int? small;

  /// Number of columns at the medium breakpoint.
  final int? medium;

  /// Number of columns at the large breakpoint.
  final int? large;

  /// {@macro hydra_behaviour}
  ///
  /// When `null`, the behaviour of the nearest [HydraScope] is used.
  final HydraBehaviour? behaviour;

  /// The space between rows. See [GridView.count].
  final double mainAxisSpacing;

  /// The space between columns. See [GridView.count].
  final double crossAxisSpacing;

  /// The ratio of width to height of each child. See [GridView.count].
  final double childAspectRatio;

  /// The space around the grid. See [GridView.count].
  final EdgeInsetsGeometry? padding;

  /// Whether the grid takes only the height of its content. See
  /// [GridView.count].
  final bool shrinkWrap;

  /// How the grid responds to scrolling. See [GridView.count].
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    final resolver = HydraResolver.of(context, behaviour: behaviour);
    final columns = resolver.resolveValueAt<int>(
      Breakpoint.current(context, behaviour: behaviour),
      mini: mini,
      small: small,
      medium: medium,
      large: large,
    );

    final gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: columns,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      childAspectRatio: childAspectRatio,
    );
    final itemBuilder = this.itemBuilder;

    return GridView.custom(
      gridDelegate: gridDelegate,
      padding: padding,
      shrinkWrap: shrinkWrap,
      physics: physics,
      childrenDelegate: itemBuilder == null
          ? SliverChildListDelegate(children)
          : SliverChildBuilderDelegate(itemBuilder, childCount: itemCount),
    );
  }
}
