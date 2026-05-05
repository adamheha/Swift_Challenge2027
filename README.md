# Swift Challenge 2027

## Project

BloomMind is a SwiftUI app concept for the Swift Student Challenge 2027.

The project starts with a clear concept document, then grows into a small, polished, reviewable app experience.

## Current Files

- `BloomMind_Concept.md`: product concept, MVP scope, user experience goals, and implementation direction.
- `Package.swift`: SwiftPM package for the local SwiftUI prototype.
- `Sources/BloomMind`: SwiftUI app entry, MVP screens, local state, and mood model.
- `Tests/BloomMindTests`: lightweight behavior checks for the MVP model.

## Current Stage

Stage 3: polish the local SwiftUI MVP flow.

## Implemented MVP Pieces

- SwiftUI app shell with a typed navigation flow.
- Home screen with BloomMind identity, weekly bloom progress, garden preview, and today-completion feedback.
- Check-in screen with mood selection, selected-state checkmark, required reflection input, and a three-step progress indicator.
- Growth action screen with mood-matched suggested actions and a trimmed reflection summary.
- Local-only state for the active check-in, weekly progress, and latest completion time.
- Accessibility polish for mood selection, reflection entry, step progress, and completion actions.
- Unit tests for mood actions, check-in completion, progress floors/capping, accessibility copy, and edge-case step state.

## Run and Verify

This repo is set up as a Swift Package with a macOS SwiftUI executable target.

```sh
swift build
swift test
swift run BloomMind
```

Note: opening/running the app in Xcode requires a full Xcode installation selected with `xcode-select`. Command Line Tools alone can build package code but may not provide the full Xcode app workflow.
