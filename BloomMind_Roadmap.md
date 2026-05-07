# BloomMind Roadmap

This roadmap keeps the project organized around stage-sized work. For BloomMind 2.0, stages can be bolder and larger, but each stage still needs a clear branch, verification pass, commit, and push.

## Current Status

Current stage: BloomMind 2.0 Stage 2 - Interactive Sorting In Progress

Current branch: `codex/bloommind-2-stage-2`

Stage boundary rule: when a stage is complete, start the next stage in a new chat/thread so planning, commits, and decisions stay easy to review.

Next stage: BloomMind 2.0 Stage 3 - Cinematic Garden Payoff

## Version 1.x Baseline

Status: Preserved as foundation

Stage 0 through Stage 9 built the original BloomMind: a local, accessible, privacy-first reflection garden with mood selection, short reflection, NaturalLanguage-assisted local theme detection, tiny actions, tappable plants, iOS/macOS package readiness, and tests.

Decision:

- Stage 9 is no longer the main creative direction.
- The Stage 9 work remains valuable as the stable model, tests, privacy boundary, accessibility base, and local action engine.
- BloomMind 2.0 now pushes the project from "nice mood tracker" to "memorable interactive story."

## BloomMind 2.0 Stage 1 - Pressure Storm Pivot

Status: Complete

Goal: Make the first minute feel surprising, visual, and emotionally specific.

Core idea:

- The app opens on a moving pressure storm made from student-life fragments such as deadlines, grades, messages, and "too much."
- A check-in is framed as transforming the storm into a seed.
- Growth Action no longer gives only one suggestion; it sorts pressure into Now, Later, and Let go.

Completed in this branch:

- Added a native SwiftUI `PressureStormView` using `TimelineView` and `Canvas`.
- Added orbit trails and high-contrast text shading so the storm reads as a dramatic scene without sacrificing legibility.
- Rebuilt Home around a high-contrast storm-to-seed hero scene.
- Added a live storm preview to Check-In.
- Changed the reflection input to a focused `TextEditor` so typing works reliably in the reflection area.
- Reframed the step flow as Name, Sort, Grow.
- Added Now / Later / Let go outputs to the local action engine and Growth Action screen.
- Made the Now / Later / Let go lanes tappable so the user can focus one part of the sorted storm.
- Added a seed commitment summary that changes with the selected lane before the user plants the seed.
- Renamed the final action to Plant This Seed to make the story loop explicit.
- Removed the forced light appearance so the app can use the system color scheme.
- Updated unit tests for the new 2.0 copy and action outputs.
- Removed the unused old circular progress dashboard from Home.

Carried forward:

- Smoke check the new flow in Xcode's app window and an iPad-sized preview before final submission.
- Tune the storm labels and particles after seeing it on actual device sizes.
- Expand the tappable lanes into a richer interactive sorting experience in Stage 2.

Definition of done:

- `swift test` passes.
- The Home screen immediately feels like a visual story, not a dashboard.
- Reflection typing works by clicking/tapping inside the large reflection area.
- The Growth Action screen clearly teaches "Now / Later / Let go."
- Changes are committed and pushed to GitHub.

## BloomMind 2.0 Stage 2 - Interactive Sorting

Status: In Progress

Goal: Make the storm transformation interactive instead of only visual.

Completed in this branch:

- Turn mood, theme, now-step, later-boundary, and release-pressure copy into tappable thought fragments.
- Group fragments into Now, Later, and Let go columns.
- Let the user move a fragment to the next lane by tapping it.
- Let the user drag a fragment into a different lane, while preserving tap-to-move as the fallback.
- Animate fragment movement between lanes with spring motion.
- Keep the selected lane connected to the seed commitment summary.
- Add a short Planting Seed state before returning to the garden.

Next:

- Add a stronger visual collapse from the sorted board into the planted seed.
- Preserve Reduce Motion and VoiceOver alternatives.

## BloomMind 2.0 Stage 3 - Cinematic Garden Payoff

Status: Planned

Goal: Make completion feel award-level.

Possible scope:

- Add a stronger seed-to-plant transition.
- Make the weekly garden feel like a living memory of storms transformed.
- Add a one-minute demo mode with a polished reviewer path.

## Stage 0 - Award Research

Status: Complete

Goal: Understand what recent Swift Student Challenge winners have in common.

Completed:

- Reviewed Apple's public judging language and recent winner stories.
- Identified repeated winner qualities: personal story, focused impact, creative interaction, accessible design, and technical execution.
- Decided that BloomMind needs a stronger memory point than a normal mood tracker.

## Stage 1 - Original Concept

Status: Complete

Goal: Define a small student-centered app idea.

Completed:

- Chose BloomMind as a gentle reflection app for students.
- Defined the mood selection, short reflection, growth action, and weekly bloom progress loop.
- Kept the first version local-only and non-clinical.

## Stage 2 - SwiftUI MVP

Status: Complete

Goal: Build a working local app prototype.

Completed:

- Created the Swift Package structure.
- Added the SwiftUI app shell.
- Built Home, Check-In, and Growth Action screens.
- Added local state with `CheckInState`.
- Added the first `Mood` model.

## Stage 3 - MVP Polish

Status: Mostly Complete

Goal: Make the first prototype stable, readable, and testable.

Completed:

- Added typed navigation flow.
- Added selected mood state and disabled continuation until the entry is valid.
- Added reflection character limit and accessibility copy.
- Added weekly progress and garden preview states.
- Added Xcode previews and unit tests for core behavior.

Remaining:

- Run regular smoke checks as UI changes continue.
- Keep tightening visual hierarchy as new garden UI is added.

## Stage 4 - Award-Level Product Repositioning

Status: Complete

Goal: Turn BloomMind from a generic wellness MVP into a stronger Swift Challenge project.

Deliverables:

- Updated concept document with a clearer award-level direction.
- Roadmap that separates the rest of the work into reviewable stages.
- Product positioning around a privacy-first interactive reflection garden.
- Clear boundaries: no medical claims, no accounts, no network calls.
- Precise Stage 5 implementation target.

Definition of done:

- README and concept docs clearly describe the new direction.
- Next stage has a precise implementation target.
- Changes are committed and pushed to GitHub.

## Stage 5 - Interactive Emotion Garden

Status: Complete

Goal: Make the garden the memorable core experience.

Completed:

- Replace the simple garden preview with mood-specific plant visuals.
- Add SwiftUI Shape or Canvas-based plants.
- Add completion growth animation.
- Respect Reduce Motion.
- Keep VoiceOver descriptions meaningful.

Definition of done:

- Each mood has a distinct visual identity.
- Completing a check-in visibly changes the garden.
- The home screen feels more like a living reflection garden than a dashboard.

## Stage 6 - Local Action Engine

Status: Complete

Goal: Make growth actions feel personal without using a server.

Completed:

- Add a local reflection theme parser.
- Detect simple themes such as school, friendship, rest, pressure, and uncertainty.
- Generate tiny actions from mood plus theme.
- Add tests for theme detection and action selection.

Definition of done:

- Growth actions are no longer only five fixed strings.
- The logic is transparent, local, and testable.
- The UI explains the action without exposing private reflection text unnecessarily.

## Stage 7 - Accessibility, Polish, and Submission Safety

Status: Complete

Goal: Raise the project to submission quality.

Completed:

- Improve Dynamic Type behavior.
- Verify VoiceOver labels and values.
- Add Reduce Motion handling.
- Check contrast and layout on smaller windows.
- Remove any wording that sounds clinical or diagnostic.
- Confirm all content is local and submission-safe.

Definition of done:

- The app feels polished in the main one-minute flow.
- Accessibility is built into the product experience.
- The submission risk checklist is clean.

## Stage 8 - Final Demo and Submission Package

Status: Complete

Goal: Prepare the final version for Apple submission.

Completed:

- Create the final one-minute demo path.
- Finalize written responses.
- Update README with final run and review instructions.
- Verify package size and resource requirements against the latest official rules.
- Run final tests.
- Add a final demo-path unit test for the local action output.
- Commit and push the final Stage 8 branch.

Definition of done:

- The app can be opened, understood, and completed quickly.
- The written response clearly connects personal motivation, creativity, and technical work.
- The final branch is committed and pushed.

Rules check:

- Checked on May 6, 2026.
- Apple had not published Swift Student Challenge 2027 rules yet.
- The package is aligned with the latest official 2026 requirements: `.swiftpm` ZIP, offline behavior, 25 MB ZIP limit, Swift Playgrounds 4.6 or Xcode 26 or later, English content, individual work, and AI usage disclosure.

## Stage 9 - Research-Informed Upgrade

Status: Superseded by BloomMind 2.0

Goal: Apply the strongest patterns from public Swift Student Challenge projects: a clearer learning loop, one stronger Apple-native local technology choice, a more interactive garden, better iPad readiness, stronger visual safety, and a sharper personal story.

Planned:

- Add emotional literacy micro-explanations to the growth action flow.
- Use Apple's NaturalLanguage framework locally for theme detection, with the current transparent keyword rules as a fallback.
- Make the garden more interactive without exposing private reflection text.
- Improve iPad and Swift Playgrounds readiness.
- Tighten visual contrast so the app stays readable in light and dark appearances.
- Strengthen the personal-story submission draft.

Completed so far:

- Added NaturalLanguage-assisted local theme detection with transparent keyword fallback.
- Added emotional literacy micro-explanations to the Growth Action screen.
- Made grown garden plants tappable with private mood-based revisit notes.
- Added iOS platform readiness and a unified SwiftUI vertical reflection field to keep typing reliable across review environments.
- Improved light and dark appearance contrast for app backgrounds, panels, cards, and the happy mood selection state.

Remaining if continuing the 1.x direction:

- Finalize the personal story with the applicant's own specific school-pressure moment.
- Smoke check the `.swiftpm` app playground format on the actual submission environment when available.

Definition of done:

- The one-minute loop teaches a small emotional literacy idea, not just a mood-tracking step.
- Theme detection remains local, testable, and explainable.
- The garden has at least one meaningful tap or gesture interaction.
- The package direction is clearer for Swift Playgrounds and iPad review.
- Light and dark appearances remain readable.
- The submission draft connects the app to a specific student motivation.
- Changes are committed and pushed to GitHub.
