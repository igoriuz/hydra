# Hydra showcase

A small "Bestiary" app built from every Hydra building block. Run it and
resize the window:

```bash
flutter run -d chrome   # or macos, windows, linux
```

| File | What it shows |
|---|---|
| `lib/showcase.dart` | The app: `HydraWidget`, `HydraGrid`, `HydraVisibility`, `HydraBuilder`, `Breakpoint.current` and `context.hydra` |
| `lib/demo_stage.dart` | The stage that resizes the app for the README animation |
| `tool/record_demo.sh` | Renders that animation to `.github/demo.gif` (needs `ffmpeg`) |
