# Swift Challenge 2027

## Project

BloomMind is a SwiftUI app concept for the Swift Student Challenge 2027.

The 2.0 direction is bolder: BloomMind turns overwhelming school pressure into a visible storm, helps the student sort that storm into Now, Later, and Let go, then transforms the feeling into a growing emotional garden.

## Current Files

- `BloomMind_Concept.md`: product concept, MVP scope, user experience goals, and implementation direction.
- `BloomMind_2_Concept.md`: BloomMind 2.0 pressure-storm concept, stage plan, and award-level product direction.
- `BloomMind_Roadmap.md`: stage plan, current status, and remaining work.
- `Package.swift`: SwiftPM package for the local SwiftUI prototype.
- `Sources/BloomMind`: SwiftUI app entry, MVP screens, local state, and mood model.
- `Tests/BloomMindTests`: lightweight behavior checks for the MVP model.
- `BloomMind_SubmissionPackage.md`: final demo path, submission response drafts, rules check, and packaging checklist.

## Current Stage

BloomMind 2.0 Stage 3: Cinematic Garden Payoff - in progress.

Active branch: `codex/bloommind-2-stage-3`

Stage 0 research through Stage 9 are now treated as the stable 1.x foundation. BloomMind 2.0 starts from that foundation and pushes the app toward a more memorable Swift Student Challenge experience.

## Implemented MVP Pieces

- SwiftUI app shell with a typed navigation flow.
- Home screen with a moving pressure-storm hero, weekly bloom progress, an interactive emotion garden, and today-completion feedback.
- Check-in screen with mood selection, selected-state checkmark, a live storm preview, optional reflection input, and a three-step progress indicator.
- Growth action screen with local mood-and-theme suggested actions, tappable thought-fragment sorting, Now / Later / Let go lanes, seed commitment, and a private theme explanation.
- Mood-specific SwiftUI plant visuals that grow from completed local check-ins.
- Local-only reflection theme detection for school, friendship, rest, pressure, and uncertainty.
- Local-only state for the active check-in, weekly progress, latest completion time, and garden mood history.
- NaturalLanguage-assisted local theme detection with transparent keyword fallback.
- Emotional literacy micro-explanations that teach one small idea during the Growth Action step.
- Tappable garden plants that reveal private mood-based revisit notes without showing reflection text.
- A Storm planted garden payoff banner connected to the newest mood and weekly seed count.
- Native SwiftUI `Canvas` pressure-storm visuals with orbit trails, high-contrast overlays, Reduce Motion support, and VoiceOver summaries.
- Accessibility polish for Dynamic Type, Reduce Motion, VoiceOver labels and values, mood selection, reflection entry, step progress, garden state, and completion actions.
- Light/dark adaptive app backgrounds, panels, cards, and mood selection contrast.
- Submission-safe product boundaries: no accounts, no analytics, no network calls, no medical claims, and no diagnostic language in the app flow.
- Xcode previews for key empty, selected, completed, full-garden, and summary states.
- Unit tests for mood actions, check-in completion, garden mood state, progress floors/capping, accessibility copy, and edge-case step state.

## Award-Level Direction

BloomMind should become more than a mood tracker. The strongest 2.0 version should demonstrate:

- A memorable pressure-storm-to-seed transformation.
- A tactile Now / Later / Let go interaction.
- A living emotion garden with a cinematic completion payoff.
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
- Stage 9: Research-informed upgrade - superseded by 2.0.
- BloomMind 2.0 Stage 1: Pressure Storm Pivot - complete.
- BloomMind 2.0 Stage 2: Interactive Sorting - complete.
- BloomMind 2.0 Stage 3: Cinematic Garden Payoff - in progress.

## BloomMind 2.0 Stage 1 Target

Stage 1 of BloomMind 2.0 changes the feeling of the app. The target is to make the first screen visually memorable, frame the user journey as "turn the storm into a seed," and make Growth Action deeper through Now / Later / Let go sorting.

Progress so far:

- Added a native SwiftUI pressure storm scene using `Canvas` and `TimelineView`.
- Added orbit trails and high-contrast text shading to the storm scenes.
- Rebuilt Home around a high-contrast storm-to-seed hero.
- Added a live storm preview to Check-In.
- Replaced the reflection input with a focused `TextEditor` to make typing reliable.
- Added tappable Now / Later / Let go outputs to the local action engine and Growth Action screen.
- Added a seed commitment summary that changes with the selected lane before planting.
- Renamed the final completion action to Plant This Seed.
- Removed the old circular progress dashboard from Home so the first screen stays story-driven.
- Updated tests for the 2.0 copy and action outputs.

Carried forward:

- Smoke check the app in Xcode and iPad-sized previews before final submission.
- Expand tappable sorting into a richer Stage 2 interaction.

## BloomMind 2.0 Stage 2 Target

Stage 2 makes sorting tactile. The current version converts the Growth Action result into thought fragments, groups those fragments into Now, Later, and Let go, and lets the user move fragments between lanes by tapping or dragging them.

Progress so far:

- Added a tap-to-sort fragment board in Growth Action.
- Added drag-and-drop lane movement while keeping tap-to-move as the fallback.
- Added spring movement as fragments change lanes.
- Generated fragments from mood, detected theme, now-step, later-boundary, and release-pressure copy.
- Kept lane selection connected to the seed commitment summary.
- Added a brief Planting Seed completion state before returning to the garden.
- Respect Reduce Motion for sorting and planting animations.

Carried forward:

- Add a stronger visual collapse from the sorted board into the planted seed during Stage 3.

## BloomMind 2.0 Stage 3 Target

Stage 3 makes the return to the garden feel like a payoff, not just a saved state.

Progress so far:

- Added a Storm planted payoff banner to the garden.
- Connected the banner to the newest mood plant and weekly seed count.
- Added a subtle animated garden atmosphere layer based on the week's mood plants.
- Added a sorted-fragments-to-seed collapse animation before planting.
- Preserved Reduce Motion by disabling the glow pulse when requested.

Next:

- Make the weekly garden feel more like a living memory of storms transformed.

## Final Demo And Submission Review

Use `BloomMind_SubmissionPackage.md` as the final review guide. The recommended one-minute demo path is:

1. Open BloomMind on the Today screen.
2. Notice the pressure-storm hero.
3. Tap Enter the Storm.
4. Select Stressed.
5. Enter: `I have a project due today and feel pressure to finish everything.`
6. Continue to the Growth Action screen.
7. Confirm the local pressure-themed action appears with Now, Later, and Let go.
8. Complete the check-in and confirm the emotion garden grows.

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

- Home shows the pressure-storm hero, weekly bloom progress, the interactive emotion garden, and today's status.
- Home previews include a full-garden state for checking the completed weekly garden.
- Check-In lets a mood be selected, shows the selected-state checkmark, and allows typing inside the large reflection editor.
- Growth Action shows the locally generated mood-and-theme action, Now / Later / Let go sorting, and no repeated private reflection text, then completes back to Home where the newest plant visibly grows.
- Large text sizes keep the main flow scrollable, the garden wraps when needed, and VoiceOver labels describe progress without exposing reflection text.

Note: opening/running the app in Xcode requires a full Xcode installation selected with `xcode-select`. Command Line Tools alone can build package code but may not provide the full Xcode app workflow.

Final packaging check:

```sh
git archive --format=zip -o /tmp/BloomMind-source.zip HEAD
du -h /tmp/BloomMind-source.zip
```

For the actual Apple submission, create and ZIP an app playground directory named `BloomMind.swiftpm`, then verify the ZIP is under 25 MB and opens offline in Swift Playgrounds 4.6 or Xcode 26, or later.
