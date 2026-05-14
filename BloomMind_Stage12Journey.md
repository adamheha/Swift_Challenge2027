# BloomMind 5.1 Stage 12 - The BloomMind Journey

## Goal

Stage 12 turns BloomMind from a feature-rich emotional garden into a complete journey: an origin scene, a guided evaluator path, a no-typing check-in option, deeper storm surgery, a weekly film, and a stronger ending ritual.

## What Changed

- Added an Opening Origin Scene before Today.
- Added `JourneySystems.swift` for origin beats, guided demo steps, wordless storm signals, layer peeling, carry seed choices, and archive museum display.
- Added `OriginJourneyView.swift` for the skippable cinematic entrance.
- Added Wordless Mode to Check-In so users can press, drag, or release a storm signal instead of typing.
- Upgraded Preview Award Demo into an Award Demo Director with play/pause, next/back, demo reflection, and eight spotlight beats.
- Added Layer Peeling 2.0 to Storm Surgery: Task, Social, Body, and Future layers shrink the storm core and reveal the seed.
- Added Play Week Film to Weekly Bloom.
- Added a carry-forward ritual where one sentence becomes the next seed.
- Upgraded the private museum ending with a season, rare blooms, crafted artifact line, and carry seed.

## Why It Matters

BloomMind now has a clearer emotional arc:

1. The student sees why the app exists.
2. They can express pressure with or without words.
3. They physically peel and sort the storm.
4. They plant the seed.
5. A full week replays as a film.
6. The ending becomes an artifact and a next seed, not a dead stop.

This makes the project easier to understand in a 60-90 second Swift Student Challenge review while still feeling personal and privacy-first.

## Verification

- `swift test` passes with 52 tests.
- `bash Scripts/verify_submission_package.sh` passes after regenerating `SubmissionBuild/BloomMind.swiftpm.zip`.
- Stage 12 ZIP size is 80,300 bytes.
- Added Journey-specific tests for origin/demo arc, wordless signal flow, storm layer peeling, carry seed ritual, and archive museum display.
- Full Xcode / Swift Playgrounds and iPad smoke checks still need to happen in the final review environment.

## Remaining

- Replace the placeholder origin line with the applicant's true story.
- Rehearse the Award Demo Director path in Xcode and on iPad-sized layouts.
- Refresh official Apple rules close to the 2027 submission window.
- Recreate and verify the `.swiftpm` ZIP after any future source changes.
