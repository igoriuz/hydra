// Renders the frames of the README animation. Run via tool/record_demo.sh.
import 'dart:io';
import 'dart:ui' as ui;

import 'package:example/demo_stage.dart';
import 'package:example/showcase.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const _fps = 20;
const _pixelRatio = 1.5;

/// (seconds, window width) - the width eases from one entry to the next.
const _timeline = <(double, double)>[
  (0, 390),
  (0.9, 390),
  (2.1, 740),
  (2.9, 740),
  (4.1, 1050),
  (4.9, 1050),
  (6.1, 1320),
  (7.4, 1320),
  (9, 390),
];

double _widthAt(double seconds) {
  for (var i = 1; i < _timeline.length; i++) {
    final (start, from) = _timeline[i - 1];
    final (end, to) = _timeline[i];
    if (seconds <= end) {
      final t =
          Curves.easeInOutCubic.transform((seconds - start) / (end - start));
      return from + (to - from) * t;
    }
  }
  return _timeline.last.$2;
}

Future<void> _loadFonts() async {
  final flutterRoot = Platform.environment['FLUTTER_ROOT'];
  if (flutterRoot == null) {
    throw StateError('FLUTTER_ROOT is not set; run this via `flutter test`.');
  }
  final fonts = Directory('$flutterRoot/bin/cache/artifacts/material_fonts');
  Future<ByteData> read(String name) async {
    final bytes = await File('${fonts.path}/$name').readAsBytes();
    return ByteData.sublistView(bytes);
  }

  final roboto = FontLoader('Roboto');
  for (final weight in ['Regular', 'Medium', 'Bold', 'Black']) {
    roboto.addFont(read('Roboto-$weight.ttf'));
  }
  await roboto.load();
  final icons = FontLoader('MaterialIcons')
    ..addFont(read('MaterialIcons-Regular.otf'));
  await icons.load();
}

void main() {
  testWidgets('record demo frames', (tester) async {
    final output = Directory(Platform.environment['FRAMES_DIR']!)
      ..createSync(recursive: true);
    debugDisableShadows = false;
    await tester.runAsync(_loadFonts);
    tester.view
      ..physicalSize = DemoStage.size * _pixelRatio
      ..devicePixelRatio = _pixelRatio;

    final width = ValueNotifier(_timeline.first.$2);
    final boundary = GlobalKey();
    await tester.pumpWidget(
      RepaintBoundary(
        key: boundary,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: showcaseTheme,
          home: ValueListenableBuilder(
            valueListenable: width,
            builder: (context, value, _) => DemoStage(width: value),
          ),
        ),
      ),
    );

    final frames = (_timeline.last.$1 * _fps).round();
    for (var frame = 0; frame < frames; frame++) {
      width.value = _widthAt(frame / _fps);
      await tester.pump(const Duration(milliseconds: 1000 ~/ _fps));
      await tester.runAsync(() async {
        final render = boundary.currentContext!.findRenderObject()!
            as RenderRepaintBoundary;
        final image = await render.toImage(pixelRatio: _pixelRatio);
        final png = await image.toByteData(format: ui.ImageByteFormat.png);
        image.dispose();
        final name = 'frame_${frame.toString().padLeft(4, '0')}.png';
        File('${output.path}/$name')
            .writeAsBytesSync(png!.buffer.asUint8List());
      });
    }

    debugDisableShadows = true;
  });
}
