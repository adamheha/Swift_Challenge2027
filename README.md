# Swift Challenge 2027

## Project

BloomMind is a SwiftUI app concept for the Swift Student Challenge 2027.

The 4.0 direction is bolder: BloomMind turns overwhelming school pressure into a visible inner weather system, helps the student sort that storm into Now, Later, and Let go, then transforms the week into a living garden, emotional landscape, and private artifact.

## Current Files

- `BloomMind_Concept.md`: product concept, MVP scope, user experience goals, and implementation direction.
- `BloomMind_2_Concept.md`: BloomMind 2.0 pressure-storm concept, stage plan, and award-level product direction.
- `BloomMind_2_Goals.md`: BloomMind 2.0 north star, required proof points, stage map, and Stage 5 scope.
- `BloomMind_Roadmap.md`: stage plan, current status, and remaining work.
- `BloomMind_Stage4Review.md`: Stage 4 final review snapshot, demo rehearsal script, and Stage 5 handoff.
- `BloomMind_Stage5Packaging.md`: Stage 5 official rules refresh, packaging command, and generated ZIP verification.
- `BloomMind_Stage5DeviceReview.md`: Stage 5 full Xcode, Swift Playgrounds, and iPad smoke-check plan.
- `BloomMind_Stage6WeeklyBloom.md`: Stage 6 weekly bloom payoff, living garden, and 7/7 reveal notes.
- `BloomMind_Stage7InnerGardenWorld.md`: BloomMind 3.0 live storm, inner garden world, and richer weekly ending notes.
- `BloomMind_Stage8DirectTransformation.md`: BloomMind 3.1 direct storm sorting, drag-to-plant, garden map, time-lapse, and artifact notes.
- `BloomMind_Stage9EmotionalPhysics.md`: BloomMind 3.2 emotional physics, privacy ritual, garden X-Ray, focus sprout, and museum shelf notes.
- `BloomMind_Stage10WeatherObservatory.md`: BloomMind 4.0 Weather Observatory, Storm Surgery, Week Shape, artifact crafting, and demo theatre notes.
- `Packaging/BloomMindSubmissionPackage.swift`: submission-only Swift package manifest.
- `Scripts/create_submission_package.sh`: repeatable `.swiftpm` ZIP packaging script.
- `Scripts/verify_submission_package.sh`: repeatable submission ZIP verification script.
- `Scripts/collect_review_environment.sh`: local environment and package status report for device review.
- `Package.swift`: SwiftPM package for the local SwiftUI prototype.
- `Sources/BloomMind`: SwiftUI app entry, MVP screens, local state, and mood model.
- `Tests/BloomMindTests`: lightweight behavior checks for the MVP model.
- `BloomMind_SubmissionPackage.md`: final demo path, submission response drafts, rules check, and packaging checklist.

## Current Stage

BloomMind 4.0 Stage 10: Weather Observatory - complete.

Active branch: `codex/bloommind-4-weather-observatory`

Stage 0 research through Stage 9 are now treated as the stable 1.x foundation. BloomMind 2.0 starts from that foundation and pushes the app toward a more memorable Swift Student Challenge experience.

## Implemented MVP Pieces

- SwiftUI app shell with a typed navigation flow.
- Home screen with a moving Weather Observatory hero, weekly bloom progress, an interactive emotion garden, and today-completion feedback.
- Weather Observatory model that reads the week as pressure layers, inner sky, lens line, dominant mood, and dominant lane.
- Check-in screen with mood selection, selected-state checkmark, a live storm preview, optional reflection input, and a three-step progress indicator.
- Live Storm Typing that changes storm intensity, theme color, and visible keywords as the user writes a reflection.
- Reflection Privacy Ritual that turns the written moment into safe storm fragments and states that BloomMind remembers the shape, not the private words.
- Growth action screen with local mood-and-theme suggested actions, Direct Storm Sorting, live reflection words, Now / Later / Let go lanes, seed commitment, and a private theme explanation.
- Direct Storm Sorting that turns typed storm keywords into draggable fragments alongside generated action fragments.
- Storm Surgery table that visualizes the storm core, orbiting fragments, and Now / Later / Let go consequence wells.
- Emotional Physics sorting where Now fragments feel rooted, Later fragments hover as buds, and Let go fragments lighten into air.
- Focus Sprout for Now choices, giving the student one tiny non-punitive minute where beginning counts.
- A drag-to-plant seed ritual that lets the student pull the seed into soil, with tap and accessibility fallbacks.
- Mood-specific SwiftUI plant visuals that grow from completed local check-ins.
- Local-only reflection theme detection for school, friendship, rest, pressure, and uncertainty.
- Local-only state for the active check-in, weekly progress, latest completion time, and garden mood history.
- NaturalLanguage-assisted local theme detection with transparent keyword fallback.
- Emotional literacy micro-explanations that teach one small idea during the Growth Action step.
- Tappable garden plants that reveal private mood-based revisit notes without showing reflection text.
- A Storm planted garden payoff banner connected to the newest mood and weekly seed count.
- Week memory and Preview Award Demo affordances for reviewing a sample complete transformed week quickly without changing real check-ins.
- A weekly review payoff card that summarizes the garden's current emotional pattern.
- Garden seeds now remember mood, local theme, and the user's Now / Later / Let go choice.
- The living garden changes copy, plant detail, atmosphere, and accessibility values based on those seed consequences.
- Inner Garden World scene with mood weather, roots, buds, open air, and world plants.
- Garden X-Ray mode that reveals underground roots, waiting buds, wind trails, and center-bloom links.
- Garden Map zones for Underground Roots, Waiting Path, Open Sky, and Center Bloom.
- Week Shape landscape that turns the seven days into an emotional terrain line with mood points, lane marks, and day landmarks.
- Seed evolution states for just planted, sprouting, blooming, resting, and archived bloom.
- A 7/7 Weekly Bloom payoff unlocks with a constellation reveal, week story, local emotional insight, closing ritual, next-week seed, and privacy note.
- Weekly Bloom time-lapse phases plus a true animated storm-to-seeds-to-world-to-bloom scene, emotional literacy unlocks, a return-tomorrow hook, artifact crafting, and a week artifact/private museum shelf.
- Award Demo Theatre that shows the evaluator path through observatory, live storm, surgery table, planting ritual, X-Ray, week shape, and artifact.
- A stronger first-five-seconds hero that frames Today as an inner weather observatory.
- Adaptive Home layout that uses a two-column storm-and-garden composition on iPad/Mac review widths.
- Wider Mac review window sizing and iPad review previews for the main flow.
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
- BloomMind 2.0 Stage 3: Cinematic Garden Payoff - complete.
- BloomMind 2.0 Stage 4: Final Review Polish - complete.
- BloomMind 2.0 Stage 5: Submission Packaging and Device Review - complete locally, pending real Xcode/iPad smoke check.
- BloomMind 2.0 Stage 6: Weekly Bloom Payoff and Living Garden - complete.
- BloomMind 3.0 Stage 7: Inner Garden World - complete.
- BloomMind 3.1 Stage 8: Direct Transformation - complete.
- BloomMind 3.2 Stage 9: Emotional Physics - complete.
- BloomMind 4.0 Stage 10: Weather Observatory - complete.

## BloomMind 2.0 Goal

BloomMind 2.0 turns the original gentle reflection garden into a complete Swift Student Challenge experience: a visible pressure storm, a tactile Now / Later / Let go transformation, a seed-planting payoff, and a private garden that remembers growth without exposing reflection text.

The whole 2.0 target is to prove visual impact, meaningful interaction, a clear emotional story, Apple-native technical execution, privacy/safety, accessibility, and final `.swiftpm` submission readiness. The most important product upgrade is that a completed seven-seed week now resolves into a Weekly Bloom story instead of ending as a plain counter.

## BloomMind 2.0 Stage 1 Target

Stage 1 of BloomMind 2.0 changes the feeling of the app. The target is to make the first screen visually memorable, frame the user journey as "turn the storm into a seed," and make Growth Action deeper through Now / Later / Let go sorting.

Progress so far:

- Added a native SwiftUI pressure storm scene using `Canvas` and `TimelineView`.
- Added orbit trails and high-contrast text shading to the storm scenes.
- Rebuilt Home around a high-contrast storm-to-seed hero.
- Added a live storm preview to Check-In.
- Replaced the reflection input with a multiline `TextField` to make typing reliable.
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

Completed by Stage 3:

- Added the visual collapse from sorted fragments into the planted seed.

## BloomMind 2.0 Stage 3 Target

Stage 3 makes the return to the garden feel like a payoff, not just a saved state.

Progress so far:

- Added a Storm planted payoff banner to the garden.
- Connected the banner to the newest mood plant and weekly seed count.
- Added a subtle animated garden atmosphere layer based on the week's mood plants.
- Added a sorted-fragments-to-seed collapse animation before planting.
- Added a Week memory strip for the transformed storm sequence.
- Added Preview Demo Week as a one-minute review/demo path.
- Preserved Reduce Motion by disabling the glow pulse when requested.

Carried forward:

- Stage 4 should focus on final review polish, iPad/Xcode smoke checks, packaging, and the applicant's personal story.

## BloomMind 2.0 Stage 4 Target

Stage 4 turns the finished flow into a stronger evaluator experience. The goal is for the final minute to feel complete: the storm is named, sorted, planted, remembered, and summarized.

Progress so far:

- Added a weekly review payoff card on Home.
- The review card summarizes empty, partial, and complete garden states.
- The complete `Preview Demo Week` path now ends with a full-week line: seven storms became seeds, with the clearest weekly pattern called out.
- Added a wide Home layout so iPad/Mac review windows show the storm and garden payoff side by side.
- Added iPad review previews for Home, Check-In, and Growth Action.
- Tuned the Mac app window toward the intended review size.
- Added `BloomMind_Stage4Review.md` with a local verification snapshot and Stage 5 handoff.
- Added unit tests for weekly review state.

Stage 5 handoff:

- Smoke check in a full selected Xcode app and/or Swift Playgrounds.
- Smoke check on an actual iPad or iPad-sized simulator.
- Replace the personal story scaffold with the applicant's true specific moment.
- Create and verify the final `.swiftpm` ZIP package.

## BloomMind 2.0 Stage 6 Target

Stage 6 makes the end of the weekly loop emotionally complete. After seven seeds, BloomMind should answer the user's implicit question: "What did this week become?"

Progress so far:

- Added `GardenSeed` so each planted seed stores mood, detected local theme, and the selected Now / Later / Let go lane.
- Saved the selected sorting lane and detected theme when planting a seed.
- Updated the garden so Now creates root language, Later creates bud language, and Let go creates open-air language.
- Added a living garden line that turns the week's dominant mood and lane into a readable emotional ecology.
- Added a 7/7 Weekly Bloom payoff with a constellation reveal, week story, local insight, closing ritual, next-week seed, and privacy note.
- Updated Preview Demo Week so the full award path shows mood, theme, lane consequences, and the Weekly Bloom ending without changing real check-ins.
- Added tests for seed consequence storage, Weekly Bloom unlock, privacy-preserving payoff copy, demo-week payoff, and garden accessibility values.

## BloomMind 3.0 Stage 7 Target

Stage 7 makes BloomMind feel like a living world instead of a completed checklist.

Progress so far:

- Added Live Storm Typing so reflection text changes storm keywords, theme color, intensity, and accessibility feedback.
- Added a seed-to-soil planting ritual with lane-specific roots, buds, or open-air visuals.
- Added an Inner Garden World scene with mood weather, spatial roots/buds/wind, and world plants.
- Expanded seed detail into a private memory card with mood, theme, tiny action, world change, and no private reflection text.
- Added Weekly Bloom time-lapse phases: Storm, Seeds, World, Bloom.
- Added Emotional Literacy Unlocks, Return Tomorrow prompt, personal origin line, and Past Bloom archive preview.
- Reframed Preview Award Demo as the guided evaluator path.
- Added tests for live storm profiles, seed memory summaries, literacy unlocks, and return-tomorrow prompts.

## BloomMind 3.1 Stage 8 Target

Stage 8 makes the transformation direct. The student should not only read that pressure became growth; they should pull the storm apart, drag the seed into soil, explore the consequence map, and see the week leave a memorable artifact.

Progress so far:

- Added Direct Storm Sorting so typed live storm words become draggable fragments.
- Added Drag-to-Plant with release-to-plant feedback, tap fallback, and VoiceOver action.
- Added Garden Map zones for Underground Roots, Waiting Path, Open Sky, and Center Bloom.
- Added Seed Evolution states for Just planted, Sprouting, Blooming, Resting, and Archived bloom.
- Added a true Weekly Bloom transformation animation from storm to seeds to world to center bloom.
- Added Week Artifact generation and upgraded the archive preview into a named emotional artifact.
- Added tests for seed evolution and artifact selection.
- Refreshed and verified the `.swiftpm` package; current ZIP size is 49,747 bytes.

## BloomMind 3.2 Stage 9 Target

Stage 9 makes the interactions feel physical and trustworthy. The goal is for the student to feel the difference between carrying, parking, and letting go.

Progress so far:

- Added `ReflectionPrivacyRitual` so the Growth Action screen shows that words become weather fragments, while private reflection text is not repeated.
- Added emotional physics copy and behavior for Now, Later, and Let go.
- Updated storm fragment chips so Now feels heavier, Later floats, and Let go feels lighter.
- Added Focus Sprout for Now choices: a one-minute local start ritual where beginning counts and nothing is punished.
- Added Garden X-Ray mode with roots, waiting buds, wind trails, and 7/7 center-bloom links.
- Strengthened the Home hero with an inner weather observatory cue.
- Upgraded Weekly Bloom archive into a private museum shelf with future artifact slots.
- Added tests for privacy ritual and lane physics copy.
- Refreshed the `.swiftpm` ZIP; current ZIP size is 54,258 bytes.
- `swift test` passes with 43 tests. `swift build` and standalone package build are blocked in this sandbox by Swift module-cache permissions after the external approval path hit a usage-limit rejection.

## BloomMind 4.0 Stage 10 Target

Stage 10 makes BloomMind feel like entering a private emotional universe, not using a wellness checklist.

Progress so far:

- Rebuilt the Home hero around a Weather Observatory lens with moving seed orbits, pressure layers, sky line, and lens line.
- Added local Weather Observatory and Week Shape models so the visual world is driven by mood, theme, lane, and weekly progress.
- Added Storm Surgery in Growth Action: fragments orbit a storm core and visibly connect to Now roots, Later suspension, or Let go wind.
- Added Week Shape in the garden so the week becomes an emotional landscape with terrain, mood points, lane marks, and day landmarks.
- Added Artifact Crafting in Weekly Bloom so the user chooses Press, Release, or Connect before the artifact enters the private museum shelf.
- Added Award Demo Theatre to Preview Award Demo so an evaluator can see the complete 90-second path without wandering.
- Added tests for observatory snapshots, pressure layers, week shape privacy, and artifact crafting gestures.

Definition of done:

- `swift test` passes.
- Preview Award Demo shows the Weather Observatory, Storm Surgery, Week Shape, Artifact Crafting, and Weekly Bloom payoff.
- The app still preserves private reflection text and uses local-only interpretation.

## Final Demo And Submission Review

Use `BloomMind_SubmissionPackage.md` as the final review guide. The recommended one-minute demo path is:

1. Open BloomMind on the Today screen.
2. Notice the Weather Observatory hero and inner weather lens.
3. Tap Enter the Storm.
4. Select Stressed.
5. Enter: `I have a project deadline and too much to finish.`
6. Continue to the Growth Action screen.
7. Confirm the local pressure-themed action appears with Now, Later, and Let go.
8. Drag live storm fragments into Now, Later, and Let go, then confirm the Storm Surgery table and emotional physics change.
9. Select Now and start the Focus Sprout, or continue directly.
10. Drag the seed into the soil, or tap it as the fallback, and confirm the chosen lane changes the ritual.
11. Return to Today and inspect the Inner Garden World, Week Shape, Garden X-Ray, Garden Map zones, seed evolution state, and seed memory card.
12. Tap Preview Award Demo.
13. Confirm the Award Demo Theatre and seven-seed Weekly Bloom payoff appear with the animated time-lapse, artifact crafting, emotional literacy unlock, closing ritual, next-week seed, and private museum shelf.

Latest official rules check: on May 8, 2026, Apple's official pages still showed the 2026 challenge and 2026 terms. No 2027-specific official rules page was published during this check. The final package is aligned with the latest official 2026 requirements: `.swiftpm` ZIP, offline behavior, 25 MB ZIP limit, Swift Playgrounds 4.6 or Xcode 26 or later, English content, individual work, and disclosed AI assistance.

## Submission Package

Create a fresh local submission ZIP:

```sh
bash Scripts/create_submission_package.sh
```

The generated package lives at:

```text
SubmissionBuild/BloomMind.swiftpm.zip
```

Current Stage 10 package refresh:

- ZIP size: 62,089 bytes.
- ZIP contents: `BloomMind.swiftpm/Package.swift` plus `BloomMind.swiftpm/Sources/`.
- The ZIP excludes `.DS_Store` and `__MACOSX`.
- The generated package includes the Weather Observatory source updates.
- ZIP contents, source safety checks, and standalone package build passed in `bash Scripts/verify_submission_package.sh`.

Verify the generated package with:

```sh
bash Scripts/verify_submission_package.sh
```

The verification script checks ZIP size, required files, forbidden generated files, forbidden network/telemetry-related API references, and standalone package build.

Collect the current review environment status with:

```sh
bash Scripts/collect_review_environment.sh
```

This repository currently builds under Command Line Tools, but the final Xcode/Swift Playgrounds/iPad smoke check needs a full selected Xcode app or Swift Playgrounds environment.

## Run and Verify

This repo is set up as a Swift Package with a macOS SwiftUI executable target.

```sh
swift build
swift test
swift run BloomMind
open Package.swift
```

Manual smoke check:

- Home shows the Weather Observatory hero, weekly bloom progress, the interactive emotion garden, and today's status.
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
