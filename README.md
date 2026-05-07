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
- `BloomMind_SubmissionPackage.md`: final demo path, submission response drafts, rules check, and packaging checklist.

## Current Stage

Stage 9: research-informed upgrade - in progress.

Active branch: `codex/bloommind-stage-9`

Stage 0 research, Stage 1 concept, Stage 2 SwiftUI MVP, Stage 4 product repositioning, Stage 5 interactive emotion garden, Stage 6 local action engine, Stage 7 accessibility/submission polish, and Stage 8 final submission packaging are complete. Stage 3 MVP polish is mostly complete.

## Implemented MVP Pieces

- SwiftUI app shell with a typed navigation flow.
- Home screen with BloomMind identity, weekly bloom progress, an interactive emotion garden, and today-completion feedback.
- Check-in screen with mood selection, selected-state checkmark, required reflection input, and a three-step progress indicator.
- Growth action screen with local mood-and-theme suggested actions and a private theme explanation.
- Mood-specific SwiftUI plant visuals that grow from completed local check-ins.
- Local-only reflection theme detection for school, friendship, rest, pressure, and uncertainty.
- Local-only state for the active check-in, weekly progress, latest completion time, and garden mood history.
- NaturalLanguage-assisted local theme detection with transparent keyword fallback.
- Emotional literacy micro-explanations that teach one small idea during the Growth Action step.
- Tappable garden plants that reveal private mood-based revisit notes without showing reflection text.
- Accessibility polish for Dynamic Type, Reduce Motion, VoiceOver labels and values, mood selection, reflection entry, step progress, garden state, and completion actions.
- Light/dark adaptive app backgrounds, panels, cards, and mood selection contrast.
- Submission-safe product boundaries: no accounts, no analytics, no network calls, no medical claims, and no diagnostic language in the app flow.
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
- Stage 7: Accessibility, polish, and submission safety - complete.
- Stage 8: Final demo and submission package - complete.
- Stage 9: Research-informed upgrade - in progress.

## Stage 9 Target

Stage 9 applies patterns from strong public Swift Student Challenge projects. The target is to make BloomMind feel more like a small interactive learning experience: add emotional literacy micro-explanations, use Apple's NaturalLanguage framework locally with transparent fallback rules, make the garden more interactive, improve iPad and Swift Playgrounds readiness, tighten light/dark contrast, and strengthen the personal-story submission draft.

Progress so far:

- NaturalLanguage-assisted local theme detection and emotional literacy micro-explanations are implemented.
- Grown garden plants are tappable and reveal private mood-based revisit notes.
- The package declares iOS support and uses a unified SwiftUI vertical reflection field for reliable typing across review environments.
- The app has a light/dark contrast pass for backgrounds, panels, cards, and mood selection.

Remaining:

- Replace the personal-story scaffold with the applicant's real motivation.
- Smoke check the final `.swiftpm` app playground in the actual review environment.

## Final Demo And Submission Review

Use `BloomMind_SubmissionPackage.md` as the final review guide. The recommended one-minute demo path is:

1. Open BloomMind on the Today screen.
2. Start a check-in.
3. Select Stressed.
4. Enter: `I have a project due today and feel pressure to finish everything.`
5. Continue to the Growth Action screen.
6. Confirm the local pressure-themed action appears.
7. Complete the check-in and confirm the emotion garden grows.

Latest official rules check: on May 6, 2026, Apple had not published Swift Student Challenge 2027 rules yet. The final package is aligned with the latest official 2026 requirements: `.swiftpm` ZIP, offline behavior, 25 MB ZIP limit, Swift Playgrounds 4.6 or Xcode 26 or later, English content, individual work, and disclosed AI assistance.

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
- Large text sizes keep the main flow scrollable, the garden wraps when needed, and VoiceOver labels describe progress without exposing reflection text.

Note: opening/running the app in Xcode requires a full Xcode installation selected with `xcode-select`. Command Line Tools alone can build package code but may not provide the full Xcode app workflow.

Final packaging check:

```sh
git archive --format=zip -o /tmp/BloomMind-source.zip HEAD
du -h /tmp/BloomMind-source.zip
```

For the actual Apple submission, create and ZIP an app playground directory named `BloomMind.swiftpm`, then verify the ZIP is under 25 MB and opens offline in Swift Playgrounds 4.6 or Xcode 26, or later.
