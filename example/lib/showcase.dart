import 'package:material_ui/material_ui.dart';
import 'package:example/reflow_grid.dart';
import 'package:hydra/hydra.dart';

final ThemeData showcaseTheme = ThemeData(
  fontFamily: 'Roboto',
  colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF008FDB)),
);

const _ink = Color(0xFF0B2A3A);
const _muted = Color(0xFF6B8494);
const _surface = Color(0xFFF3F7FA);
const _motion = Duration(milliseconds: 450);

/// One accent colour per breakpoint, shared by the page and the demo stage.
Color breakpointColor(Breakpoint breakpoint) {
  return switch (breakpoint) {
    Breakpoint.mini => const Color(0xFF12CDB5),
    Breakpoint.small => const Color(0xFF1FA8F2),
    Breakpoint.medium => const Color(0xFF8672FF),
    Breakpoint.large => const Color(0xFFFF7353),
  };
}

class _Creature {
  const _Creature(this.name, this.origin, this.icon, this.colors);

  final String name;
  final String origin;
  final IconData icon;
  final List<Color> colors;
}

const _creatures = [
  _Creature('Hydra', 'Lake Lerna', Icons.water, [
    Color(0xFF00C2B2),
    Color(0xFF008FDB),
  ]),
  _Creature('Phoenix', 'Heliopolis', Icons.local_fire_department, [
    Color(0xFFFFA63D),
    Color(0xFFFF5E62),
  ]),
  _Creature('Pegasus', 'Mount Helicon', Icons.flight, [
    Color(0xFF8E9BFF),
    Color(0xFF5B5FE9),
  ]),
  _Creature('Cerberus', 'The Underworld', Icons.pets, [
    Color(0xFF4B5D79),
    Color(0xFF1F2A44),
  ]),
  _Creature('Kraken', 'The North Sea', Icons.tsunami, [
    Color(0xFF2ED3E6),
    Color(0xFF1368D8),
  ]),
  _Creature('Griffin', 'Scythia', Icons.bolt, [
    Color(0xFFFFCB45),
    Color(0xFFF08A1C),
  ]),
  _Creature('Sphinx', 'Thebes', Icons.visibility, [
    Color(0xFFE38BD3),
    Color(0xFF9B4DE0),
  ]),
  _Creature('Minotaur', 'Crete', Icons.castle, [
    Color(0xFF58D68D),
    Color(0xFF1E9E6A),
  ]),
];

const _destinations = [
  (Icons.grid_view_rounded, 'Bestiary'),
  (Icons.map_outlined, 'Atlas'),
  (Icons.bookmark_outline, 'Saved'),
  (Icons.person_outline, 'Profile'),
];

/// A small app built from every Hydra building block.
class ShowcasePage extends StatelessWidget {
  const ShowcasePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _surface,
      child: Row(
        children: [
          // The side navigation only exists from `medium` on and slides in
          // from the left edge.
          const HydraVisibility(
            visibleFrom: Breakpoint.medium,
            transition: HydraTransition.size(
              duration: _motion,
              curve: Curves.easeInOutCubic,
              alignment: Alignment.centerLeft,
            ),
            child: _SideNavigation(),
          ),
          Expanded(
            child: Column(
              children: [
                // The search field fades in once there is room for it.
                HydraWidget(
                  transition: const HydraTransition.fade(duration: _motion),
                  mini: const _Header(showSearch: false),
                  medium: const _Header(showSearch: true),
                ),
                // One to four columns. The cards glide to their new place.
                Expanded(
                  child: ReflowGrid(
                    spec: GridSpec(
                      columns: context.hydra<int>(
                        mini: 1,
                        small: 2,
                        medium: 3,
                        large: 4,
                      ),
                      aspectRatio: context.hydra<double>(
                        mini: 2.55,
                        small: 1.45,
                        medium: 1.2,
                        large: 1.12,
                      ),
                      inset: context.hydra<double>(
                        mini: 16,
                        small: 20,
                        large: 28,
                      ),
                    ),
                    children: [
                      for (final creature in _creatures)
                        _CreatureCard(creature),
                    ],
                  ),
                ),
                // Phones and small tablets navigate at the bottom instead.
                const HydraVisibility(
                  visibleUntil: Breakpoint.small,
                  transition: HydraTransition.size(
                    axis: Axis.vertical,
                    duration: _motion,
                    curve: Curves.easeInOutCubic,
                    alignment: Alignment.topCenter,
                  ),
                  child: _BottomNavigation(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.showSearch});

  final bool showSearch;

  @override
  Widget build(BuildContext context) {
    final inset = context.hydra<double>(mini: 16, small: 20, large: 28);

    return AnimatedPadding(
      duration: _motion,
      curve: Curves.easeInOutCubic,
      padding: EdgeInsets.fromLTRB(inset, 22, inset, 4),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bestiary',
                  style: TextStyle(
                    color: _ink,
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.3,
                    height: 1.1,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Eight creatures, one widget tree',
                  style: TextStyle(color: _muted, fontSize: 15),
                ),
              ],
            ),
          ),
          if (showSearch) ...[const _SearchField(), const SizedBox(width: 14)],
          HydraBuilder(
            builder: (context, breakpoint) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: breakpointColor(breakpoint),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  breakpoint.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: const Color(0xFFDCE6EC)),
      ),
      child: const Row(
        children: [
          Icon(Icons.search, color: _muted, size: 22),
          SizedBox(width: 8),
          Text(
            'Search creatures',
            style: TextStyle(color: _muted, fontSize: 15),
          ),
        ],
      ),
    );
  }
}

class _CreatureCard extends StatelessWidget {
  const _CreatureCard(this.creature);

  final _Creature creature;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: creature.colors,
        ),
        boxShadow: [
          BoxShadow(
            color: creature.colors.last.withValues(alpha: 0.28),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            Positioned(
              right: -18,
              bottom: -22,
              child: Icon(
                creature.icon,
                size: 132,
                color: Colors.white.withValues(alpha: 0.16),
              ),
            ),
            // Pinned to the corners rather than stacked in a column, so a
            // card that is briefly short mid-transition cannot overflow.
            Positioned(
              left: 18,
              top: 18,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(creature.icon, color: Colors.white, size: 22),
              ),
            ),
            Positioned(
              left: 18,
              right: 18,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    creature.name,
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    creature.origin,
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.82),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SideNavigation extends StatelessWidget {
  const _SideNavigation();

  @override
  Widget build(BuildContext context) {
    // Icons only at `medium`, icons with labels at `large`.
    final extended = Breakpoint.current(context) == Breakpoint.large;

    return AnimatedContainer(
      duration: _motion,
      curve: Curves.easeInOutCubic,
      width: extended ? 232 : 84,
      color: _ink,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: _Labelled(
              icon: const Icon(Icons.water, color: Color(0xFF12CDB5), size: 30),
              label: extended ? 'HYDRA' : null,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.w900,
                letterSpacing: 3,
              ),
            ),
          ),
          const SizedBox(height: 26),
          for (final (index, (icon, label)) in _destinations.indexed)
            _SideItem(
              icon: icon,
              label: extended ? label : null,
              selected: index == 0,
            ),
        ],
      ),
    );
  }
}

class _SideItem extends StatelessWidget {
  const _SideItem({required this.icon, required this.selected, this.label});

  final IconData icon;
  final String? label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final color = selected ? Colors.white : const Color(0xFF8FB0C2);

    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 13),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF008FDB) : null,
        borderRadius: BorderRadius.circular(14),
      ),
      child: _Labelled(
        icon: Icon(icon, color: color, size: 24),
        label: label,
        style: TextStyle(
          color: color,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// An icon with a label that fades out at the edge while the navigation
/// animates its width.
class _Labelled extends StatelessWidget {
  const _Labelled({required this.icon, required this.style, this.label});

  final Widget icon;
  final String? label;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final label = this.label;

    return Row(
      children: [
        icon,
        if (label != null)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(
                label,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.fade,
                style: style,
              ),
            ),
          ),
      ],
    );
  }
}

class _BottomNavigation extends StatelessWidget {
  const _BottomNavigation();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Color(0x14000000), blurRadius: 16)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (final (index, (icon, _)) in _destinations.indexed)
            Icon(
              icon,
              size: 28,
              color: index == 0 ? const Color(0xFF008FDB) : _muted,
            ),
        ],
      ),
    );
  }
}
