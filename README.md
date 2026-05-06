# Swift Challenge 2027

## Project

BloomMind is a SwiftUI app concept for the Swift Student Challenge 2027.

The project starts with a clear concept document, then grows into a small, polished, reviewable app experience. The award-level direction is a privacy-first interactive reflection garden that helps students turn overwhelming school emotions into one tiny, doable next step.

## Current Files

- `BloomMind_Concept.md`: product concept, MVP scope, user experience goals, and implementation direction.
- `BloomMind_Roadmap.md`: stage plan, current status, and remaining work.
- `Package.swift`: SwiftPM package for the local SwiftUI prototype.
- `Sources/BloomMind`: SwiftUI app entry, MVP screens, local state, and mood model.
- `Tests/BloomMindTests`: lightweight behavior checks for the MVP model.

## Current Stage

Stage 6: local action engine - complete.

Active branch: `codex/bloommind-stage-6`

Stage 0 research, Stage 1 concept, Stage 2 SwiftUI MVP, Stage 4 product repositioning, Stage 5 interactive emotion garden, and Stage 6 local action engine are complete. Stage 3 MVP polish is mostly complete. The next stage is Stage 7, accessibility, polish, and submission safety.

## Implemented MVP Pieces

- SwiftUI app shell with a typed navigation flow.
- Home screen with BloomMind identity, weekly bloom progress, an interactive emotion garden, and today-completion feedback.
- Check-in screen with mood selection, selected-state checkmark, required reflection input, and a three-step progress indicator.
- Growth action screen with local mood-and-theme suggested actions and a private theme explanation.
- Mood-specific SwiftUI plant visuals that grow from completed local check-ins.
- Local-only reflection theme detection for school, friendship, rest, pressure, and uncertainty.
- Local-only state for the active check-in, weekly progress, latest completion time, and garden mood history.
- Accessibility polish for mood selection, reflection entry, step progress, garden state, and completion actions.
- Xcode previews for key empty, selected, completed, full-garden, and summary states.
- Unit tests for mood actions, check-in completion, garden mood state, progress floors/capping, accessibility copy, and edge-case step state.

## Award-Level Direction

BloomMind should become more than a mood tracker. The strongest version should demonstrate:

- A memorable interactive emotion garden.
- Mood-specific plant visuals and completion animation.
- Local-only reflection theme detection.
- Tiny growth actions generated from mood plus theme.
- Accessibility and privacy as core product features.
- Non-clinical, student-centered language.

## Stage Roadmap

- Stage 0: Award research - complete.
- Stage 1: Original concept - complete.
- Stage 2: SwiftUI MVP - complete.
- Stage 3: MVP polish - mostly complete.
- Stage 4: Award-level product repositioning - complete.
- Stage 5: Interactive emotion garden - complete.
- Stage 6: Local action engine - complete.
- Stage 7: Accessibility, polish, and submission safety - not started.
- Stage 8: Final demo and submission package - not started.

## Run and Verify

This repo is set up as a Swift Package with a macOS SwiftUI executable target.

```sh
swift build
swift test
swift run BloomMind
open Package.swift
```

Manual smoke check:

- Home shows weekly bloom progress, the interactive emotion garden, and today's status.
- Home previews include a full-garden state for checking the completed weekly garden.
- Check-In lets a mood be selected and shows the selected-state checkmark.
- Growth Action shows the locally generated mood-and-theme action without repeating the private reflection text, then completes back to Home where the newest plant visibly grows.

Note: opening/running the app in Xcode requires a full Xcode installation selected with `xcode-select`. Command Line Tools alone can build package code but may not provide the full Xcode app workflow.
