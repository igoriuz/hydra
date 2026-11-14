import 'package:material_ui/material_ui.dart';

/// How a [ReflowGrid] lays out its children.
@immutable
class GridSpec {
  const GridSpec({
    required this.columns,
    required this.aspectRatio,
    required this.inset,
  });

  static const double _gap = 16;

  final int columns;
  final double aspectRatio;
  final double inset;

  /// The rectangle of the child at [index] in a grid of the given [width].
  Rect rectOf(int index, double width) {
    final cellWidth = (width - 2 * inset - _gap * (columns - 1)) / columns;
    final cellHeight = cellWidth / aspectRatio;
    return Rect.fromLTWH(
      inset + (index % columns) * (cellWidth + _gap),
      inset + (index ~/ columns) * (cellHeight + _gap),
      cellWidth,
      cellHeight,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GridSpec &&
        other.columns == columns &&
        other.aspectRatio == aspectRatio &&
        other.inset == inset;
  }

  @override
  int get hashCode => Object.hash(columns, aspectRatio, inset);
}

/// A scrollable grid whose children glide to their new place when the
/// [spec] changes, instead of jumping there.
///
/// Hydra decides *what* the layout is per breakpoint; this widget only
/// animates from the previous layout to the next one.
class ReflowGrid extends StatefulWidget {
  const ReflowGrid({required this.spec, required this.children, super.key});

  final GridSpec spec;
  final List<Widget> children;

  @override
  State<ReflowGrid> createState() => _ReflowGridState();
}

class _ReflowGridState extends State<ReflowGrid>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 450),
    value: 1,
  );
  late GridSpec _from = widget.spec;
  late GridSpec _to = widget.spec;

  /// Where the children were when a running animation was interrupted.
  /// The next one starts there instead of at the layout of [_from].
  List<Rect>? _interruptedAt;
  List<Rect> _current = const [];

  @override
  void didUpdateWidget(ReflowGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.spec != _to) {
      _interruptedAt = _controller.isAnimating ? _current : null;
      _from = _to;
      _to = widget.spec;
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final t = Curves.easeInOutCubic.transform(_controller.value);
            // Both layouts use the current width, so resizing within a
            // breakpoint follows the window without any lag.
            final interruptedAt = _interruptedAt;
            final rects = [
              for (var i = 0; i < widget.children.length; i++)
                Rect.lerp(
                  interruptedAt != null && i < interruptedAt.length
                      ? interruptedAt[i]
                      : _from.rectOf(i, width),
                  _to.rectOf(i, width),
                  t,
                )!,
            ];
            _current = rects;
            final height = rects.isEmpty ? 0.0 : rects.last.bottom;

            return SingleChildScrollView(
              child: SizedBox(
                height: height + _to.inset,
                child: Stack(
                  children: [
                    for (final (i, child) in widget.children.indexed)
                      Positioned.fromRect(rect: rects[i], child: child),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
