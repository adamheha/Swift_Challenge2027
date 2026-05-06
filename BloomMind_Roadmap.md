# BloomMind Roadmap

This roadmap keeps the project organized around stage-sized work. Each stage should stay small enough to review, test, commit, and push.

## Current Status

Current stage: Stage 6 - Local Action Engine Complete

Current branch: `codex/bloommind-stage-6`

Stage boundary rule: when a stage is complete, start the next stage in a new chat/thread so planning, commits, and decisions stay easy to review.

Next stage: Stage 7 - Accessibility, Polish, and Submission Safety

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

Status: Not Started

Goal: Raise the project to submission quality.

Planned work:

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

Status: Not Started

Goal: Prepare the final version for Apple submission.

Planned work:

- Create the final one-minute demo path.
- Finalize written responses.
- Update README with final run and review instructions.
- Verify package size and resource requirements against the latest official rules.
- Run final tests.

Definition of done:

- The app can be opened, understood, and completed quickly.
- The written response clearly connects personal motivation, creativity, and technical work.
- The final branch is committed and pushed.
