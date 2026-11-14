import 'package:example/showcase.dart';
import 'package:material_ui/material_ui.dart';
import 'package:hydra/hydra.dart';

/// Presents [ShowcasePage] in a window of the given logical [width] above a
/// ruler of the breakpoints. The README animation is recorded from it, see
/// `tool/record_demo.sh`.
class DemoStage extends StatelessWidget {
  const DemoStage({required this.width, super.key});

  /// Size of the stage itself.
  static const Size size = Size(1280, 720);

  /// Widest window the stage can show.
  static const double maxWidth = 1320;

  static const double _appHeight = 620;
  static const double _scale = 0.74;
  static const double _left = (1280 - maxWidth * _scale) / 2;
  static const double _windowTop = 132;
  static const double _chromeHeight = 30;
  static const double _rulerTop =
      _windowTop + _chromeHeight + _appHeight * _scale + 14;

  /// Logical width of the showcased app.
  final double width;

  @override
  Widget build(BuildContext context) {
    const behaviour = HydraBehaviour();
    final current = const HydraResolver().resolveBreakpoint(width);
    final accent = breakpointColor(current);
    final starts = <double>[
      0,
      behaviour.breakpointSmall,
      behaviour.breakpointMedium,
      behaviour.breakpointLarge,
      maxWidth,
    ];

    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0A3145), Color(0xFF04141D)],
        ),
      ),
      child: DefaultTextStyle(
        style: const TextStyle(fontFamily: 'Roboto', color: Colors.white),
        child: Stack(
          children: [
            const Positioned(left: _left, top: 38, child: _Title()),
            Positioned(
              right: _left,
              top: 46,
              child: _Readout(width: width, current: current, accent: accent),
            ),
            for (final start in starts.sublist(1, 4))
              Positioned(
                left: _left + start * _scale,
                top: _windowTop - 14,
                height: _rulerTop - _windowTop + 22,
                child: Container(width: 1.5, color: const Color(0x33FFFFFF)),
              ),
            for (final breakpoint in Breakpoint.values)
              Positioned(
                left: _left + starts[breakpoint.index] * _scale,
                width:
                    (starts[breakpoint.index + 1] - starts[breakpoint.index]) *
                    _scale,
                top: _rulerTop,
                child: _Segment(
                  breakpoint: breakpoint,
                  start: starts[breakpoint.index],
                  end: starts[breakpoint.index + 1],
                  active: breakpoint == current,
                ),
              ),
            Positioned(
              left: _left,
              top: _windowTop,
              child: _Window(
                width: width,
                appHeight: _appHeight,
                scale: _scale,
                chromeHeight: _chromeHeight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'HYDRA',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w900,
            letterSpacing: 9,
            height: 1,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'One widget tree. Every screen size.',
          style: TextStyle(fontSize: 18, color: Color(0xFF9CC3D6)),
        ),
      ],
    );
  }
}

class _Readout extends StatelessWidget {
  const _Readout({
    required this.width,
    required this.current,
    required this.accent,
  });

  final double width;
  final Breakpoint current;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '${width.round()} px',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            fontFeatures: [FontFeature.tabularFigures()],
          ),
        ),
        const SizedBox(width: 16),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: accent,
            borderRadius: BorderRadius.circular(99),
          ),
          child: Text(
            'Breakpoint.${current.name}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.breakpoint,
    required this.start,
    required this.end,
    required this.active,
  });

  final Breakpoint breakpoint;
  final double start;
  final double end;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = breakpointColor(breakpoint);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 6,
          margin: const EdgeInsets.only(right: 4),
          decoration: BoxDecoration(
            color: active ? color : color.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(height: 10),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 300),
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: active ? Colors.white : const Color(0xFF5E8296),
          ),
          child: Text(breakpoint.name),
        ),
        Text(
          start > 0 ? '≥ ${start.round()} px' : '< ${end.round()} px',
          style: const TextStyle(fontSize: 14, color: Color(0xFF5E8296)),
        ),
      ],
    );
  }
}

class _Window extends StatelessWidget {
  const _Window({
    required this.width,
    required this.appHeight,
    required this.scale,
    required this.chromeHeight,
  });

  final double width;
  final double appHeight;
  final double scale;
  final double chromeHeight;

  @override
  Widget build(BuildContext context) {
    final appSize = Size(width, appHeight);

    return Container(
      width: width * scale,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 40,
            offset: Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: chromeHeight,
            color: const Color(0xFF16465D),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                for (final color in const [
                  Color(0xFFFF6159),
                  Color(0xFFFFBD2E),
                  Color(0xFF28C941),
                ])
                  Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(
            width: width * scale,
            height: appHeight * scale,
            child: FittedBox(
              fit: BoxFit.fill,
              child: SizedBox.fromSize(
                size: appSize,
                // Hydra reads the screen size from MediaQuery, so the window
                // only has to report its own size to make the app respond.
                child: MediaQuery(
                  data: MediaQuery.of(context).copyWith(size: appSize),
                  child: const ShowcasePage(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
