<img src="https://raw.githubusercontent.com/igoriuz/hydra/master/.github/logo.png" height="120" alt="Hydra Logo" />

# Hydra
Build responsive widgets with ease. Define up to four different looks for the same widget. Every hydra can have different breakpoints which determines when an alternative should appear.

## Motivation
Achieving responsiveness can be a tedious task because of multiple factors like orientation, screen width and so on. Without a clear definition it's difficult to scale apps which heavily rely on responsiveness.

### What does Hydra do?
- Decides which widget it should show depending on your breakpoints
- Automatically show the next matching widget, if there's no suitable alternative for the current breakpoint
- Apply your ruleset (=behaviour) about switching widgets

### What doesn't Hydra do?
- Any "magical" scaling in the background (like font sizes)
- Calculating different sizes/ constraints for your widget

## How to use HydraWidget
| Parameter | Function                                                        |
|-----------|-----------------------------------------------------------------|
| Behaviour | Defining breakpoints for switching between widgets. Awareness of orientation. Preferness when to use either smaller or bigger alternative, when no alternative fits between current breakpoints. |
| mini      | The smallest widget. Size is relative depending on breakpoints. |
| small     | Bigger than mini. Size is relative depending on breakpoints.    |
| medium    | Bigger than small. Size is relative depending on breakpoints.   |
| large     | Bigger than medium. Size is relative depending on breakpoints.  |
