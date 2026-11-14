# Hydra showcase

A small "Bestiary" app built from the Hydra building blocks. Run it and
resize the window - nothing jumps, everything animates to its new place:

```bash
flutter run -d chrome   # or macos, windows, linux
```

Needs Flutter 3.47 or newer (the app uses `package:material_ui`).

| File | What it shows |
|---|---|
| `lib/showcase.dart` | The app: `HydraWidget` and `HydraVisibility` with transitions, `HydraBuilder`, `Breakpoint.current` and `context.hydra` |
| `lib/reflow_grid.dart` | A grid that animates between the column counts Hydra resolves |
| `lib/demo_stage.dart` | The stage that resizes the app for the README animation |
| `tool/record_demo.sh` | Renders that animation to `.github/demo.gif` (needs `ffmpeg`) |
