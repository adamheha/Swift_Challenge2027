# BloomMind 2.0 Stage 4 Review

Stage 4 status: complete from the local engineering and review-prep side.

## What Stage 4 Finished

- Home now has an evaluator-ready payoff: the storm hero, garden, week memory, Preview Demo Week, and weekly review summary all connect into one visible story.
- Home adapts to the review surface: compact windows stay single-column, while iPad/Mac review widths use a two-column storm-and-garden composition.
- The Mac app window now prefers a wider review size so the first launch is closer to the intended evaluator view.
- Xcode previews now cover the main review surfaces:
  - `Home - iPad Review`
  - `Check-In - iPad Review`
  - `Growth Action - iPad Review`
- The final review checklist is written around the actual one-minute path and the complete Preview Demo Week payoff.

## Local Verification

Run before handing the branch to a device or Xcode review:

```sh
swift test
swift build
git diff --check
```

Expected local result at Stage 4 completion:

- `swift test` passes with 33 tests.
- `swift build` passes when Swift/Clang cache permissions are available.
- `git diff --check` reports no whitespace errors.
- Static source scan shows no network, analytics, telemetry, CloudKit, HealthKit, or CoreLocation APIs in `Sources`, `Tests`, or `Package.swift`.

Note: this environment is using Command Line Tools, not a full selected Xcode app. `xcodebuild -version` cannot run until a full Xcode installation is selected with `xcode-select`.

## Review Script

Use this script for the final evaluator rehearsal:

1. Open BloomMind.
2. Confirm Home shows the pressure storm and the garden path clearly.
3. Tap Enter the Storm.
4. Select Stressed.
5. Type: `I have a project due today and feel pressure to finish everything.`
6. Tap Continue.
7. Confirm the pressure-themed Growth Action appears.
8. Move fragments between Now, Later, and Let go by tapping or dragging.
9. Tap Plant This Seed.
10. Return to Today and confirm the newest plant, Storm planted banner, Week memory, and weekly review card are visible.
11. Tap Preview Demo Week and confirm the full-week payoff reads as a complete transformed week without changing real check-ins.

## Stage 5 Handoff

Stage 5 should focus on items that need either the final submission environment or the applicant's real story:

- Open the package in full Xcode and/or Swift Playgrounds.
- Smoke check on an actual iPad or iPad-sized simulator.
- Create the final `BloomMind.swiftpm` package and ZIP.
- Confirm the final ZIP is under 25 MB.
- Refresh the official Apple rules before submission.
- Replace the personal motivation scaffold with one true applicant-specific moment.

## Personal Story Input Needed

Before submission, collect one specific student-life moment from the applicant:

- What was the real pressure moment?
- What made it feel like "everything is too much"?
- What was the one small step that helped?

The final essay should keep that story specific, but the app itself should continue avoiding diagnosis, treatment language, accounts, analytics, and network features.
