import 'package:example/showcase.dart';
import 'package:material_ui/material_ui.dart';

void main() => runApp(const ShowcaseApp());

/// Resize the window to see every Hydra building block react.
class ShowcaseApp extends StatelessWidget {
  const ShowcaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hydra Showcase',
      debugShowCheckedModeBanner: false,
      theme: showcaseTheme,
      home: const ShowcasePage(),
    );
  }
}
