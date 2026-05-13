# BloomMind Submission Package

## Current 2.0 Direction

BloomMind 3.0 reframes the app around an inner garden world. Instead of opening like a calm tracker, the app opens with a moving storm of student-pressure fragments, then lets the student's reflection change that storm live. The student names a mood, sorts pressure into Now, Later, and Let go, presses a seed into the soil, and watches those choices change a private garden world. A completed seven-seed week unlocks a Weekly Bloom payoff, so the story resolves into a private week shape instead of stopping at a counter.

The old 1.x submission path is preserved as a stable foundation, but the active award-level direction is now the 2.0 pressure-storm experience.

## Latest Rules Check

Checked on May 8, 2026. Apple's official Swift Student Challenge pages currently show the 2026 challenge and 2026 terms. A 2027-specific official rules page was not published during this check, so this package is aligned with the latest official 2026 requirements:

- Submission format: app playground in a `.swiftpm` ZIP file.
- Offline behavior: the app should not rely on a network connection, and resources should be included locally.
- Size limit: ZIP file up to 25 MB.
- Runtime target: Swift Playgrounds 4.6 or Xcode 26, or later.
- Experience length: the app playground should be experienced within 3 minutes.
- Content language: all submission content should be in English.
- Individual work: the app playground should be created by one student, or based on a Swift Playground template modified by one student.
- Required writing: essay answers must be written by the applicant.
- AI disclosure: any AI assistance should be fully disclosed.

Official references:

- https://developer.apple.com/swift-student-challenge/
- https://developer.apple.com/swift-student-challenge/eligibility/
- https://developer.apple.com/swift-student-challenge/policy/

## Current One-Minute Demo Path

Target review time: 60 seconds.

1. Open BloomMind.
2. On the Today screen, notice the moving pressure-storm hero and the prompt to turn the storm into a seed.
3. Tap Enter the Storm.
4. Select Stressed.
5. Enter this short reflection to exercise live storm typing and local theme detection:

   `I have a project deadline and too much to finish.`

6. Confirm the storm responds with pressure keywords, theme color, and a stronger live weather reading.
7. Tap Continue.
8. Review the generated Growth Action and move several thought fragments through Now, Later, and Let go by tapping or dragging them:

   `Make it tiny: choose one thing that can wait, then start only the next tiny step.`

9. Confirm the seed commitment updates when a lane is selected, and note that BloomMind detects a pressure theme locally without sending or saving the private reflection text.
10. Press the seed into the soil and confirm the planting ritual changes based on Now, Later, or Let go.
11. Return to Today and confirm the Inner Garden World shows mood weather, roots, buds, open air, and a mood-specific plant.
12. Tap the newest seed and confirm the memory card shows theme, action, and world change without reflection text.
13. Tap Preview Award Demo to inspect a sample complete-week review garden without changing real check-ins.
14. Confirm the Weekly Bloom payoff appears with a seven-seed reveal, time-lapse, week story, emotional literacy unlock, closing ritual, next-week seed, privacy note, and archive preview.

## Submission Response Drafts

### App Summary

BloomMind is a privacy-first SwiftUI app playground that helps students turn overwhelming school pressure into a living inner garden. The app opens with a moving pressure storm that responds as the student types, guides the student to name a mood, sorts the moment into Now, Later, and Let go, then turns the feeling into a seed planted through a small soil ritual. Each seed changes the garden world as roots, buds, or open air. After seven seeds, the app reveals a Weekly Bloom: a private time-lapse, week story, emotional literacy unlock, closing line, next-week intention, and archive preview that remember growth without resurfacing private reflection text.

### Personal Motivation

Personal-story scaffold to customize before final submission:

`I built BloomMind after noticing how quickly school pressure can turn into a vague "everything is too much" feeling. [Replace this sentence with one specific moment from your own student life: a project, competition, exam week, club responsibility, or moment when you needed one small next step.] I wanted the app to feel like something a student could use in one quiet minute before moving to the next class or assignment. BloomMind does not diagnose the user, collect private data, or ask for an account. It simply helps a student name what is present, learn one small idea about that feeling, and choose a doable next step.`

Do not submit this paragraph unchanged. The strongest version should include one true, specific motivation from the applicant.

Stage 5 personal-story input needed:

- One real school-pressure moment.
- Why that moment felt like "everything is too much."
- The small next step that made it easier to move.

### Creativity And Impact

The main creative idea is that pressure changes form. Instead of showing a generic checklist, BloomMind begins with a storm of student-life fragments such as deadlines, grades, messages, and "too much." As the student writes, the storm surfaces live keywords and theme-colored weather. A check-in sorts that storm into Now, Later, and Let go, then transforms the feeling through a seed-to-soil ritual. Each planted seed remembers the mood, local theme, and sorting choice, so Now becomes roots, Later becomes buds, and Let go becomes open air in the garden world. After seven seeds, the Weekly Bloom reveal turns the whole week into a constellation-style story with a time-lapse, emotional literacy unlock, closing ritual, next-week seed, and archive preview. Calm, happy, tired, stressed, and unsure moods each have a different visual identity, so the garden becomes a private record of pressure transformed into growth.

### Technical Work

BloomMind is built with SwiftUI and local state. The app uses a typed navigation flow, responsive SwiftUI layouts, Dynamic Type support, VoiceOver labels and values, Reduce Motion handling, and unit-tested model logic. The pressure storm, inner garden world, planting ritual, and Weekly Bloom reveal are drawn with native SwiftUI `Canvas`, `TimelineView`, gradients, symbols, and shape drawing. A local action engine uses Apple's NaturalLanguage framework when available to assist local theme detection, with transparent keyword rules as a fallback. It analyzes simple reflection themes such as school, friendship, rest, pressure, and uncertainty, then combines the detected theme with the selected mood to create live storm keywords, thought fragments, one tiny action, animated tap-or-drag Now / Later / Let go sorting, an emotional literacy micro-explanation, and a weekly literacy unlock. The planted seed stores only mood, detected theme, and sorting lane, then the garden and Weekly Bloom use those local values to build the world, memory cards, week story, time-lapse, and next-week intention. The reflection text stays local in the prototype and is not displayed again on the action screen or weekly summary.

### Privacy And Safety

BloomMind is intentionally local-first. It includes no accounts, analytics, tracking, cloud sync, or network calls. The language avoids diagnosis and medical claims, and every suggestion is framed as a small student-centered action rather than treatment or advice. The prototype is meant for personal reflection and growth, not for clinical support.

### Tool Disclosure Draft

AI assistance was used to help brainstorm, organize documentation, and review implementation details. The app idea, product direction, code decisions, and final submission understanding remain my responsibility, and I can explain how the SwiftUI screens, local state, action engine, accessibility behavior, and tests work.

## Final Review Checklist

- Open the app and complete the demo path in under 3 minutes.
- Confirm the one-minute demo path works without any network connection.
- Confirm the Reflection field accepts typed text after clicking or tapping directly inside it.
- Confirm typing reflection text changes the storm's live keywords and theme reading.
- Confirm Continue can also be tapped after selecting a mood when Reflection is empty.
- Confirm the pressure storm stays readable in light and dark appearances.
- Confirm thought fragments appear on Growth Action and can move between Now, Later, and Let go by tap and drag/drop.
- Confirm the seed-to-soil planting ritual changes based on the selected lane.
- Confirm Preview Award Demo shows a complete sample week and the Week memory strip without changing real check-ins.
- Confirm the weekly review card and Weekly Bloom payoff summarize the completed sample week.
- Confirm the Inner Garden World shows roots, buds, open air, and mood weather.
- Confirm seed memory cards show mood, theme, tiny action, and world change without reflection text.
- Confirm Weekly Bloom does not display private reflection text.
- Confirm the Home screen uses a two-column storm-and-garden layout on iPad/Mac review widths and falls back to a readable single column on narrow widths.
- Confirm Reduce Motion keeps sorting and planting understandable without pulsing motion.
- Run `swift test`.
- Run `swift build`.
- Confirm the ZIP package is under 25 MB.
- Confirm all visible app and submission writing is in English.
- Confirm no secrets, accounts, analytics, telemetry, or network calls are included.
- Confirm any AI usage is disclosed in the final submission form.
- Review `BloomMind_Stage4Review.md` before creating the final package.

## Swift Playgrounds Smoke Check

Use this checklist when the final `BloomMind.swiftpm` package is available in the actual review environment:

1. Open the package on iPad or in Swift Playgrounds.
2. Tap Enter the Storm and select Stressed.
3. Either leave Reflection empty to test the quick path, or type `I have a project deadline and too much to finish.` to test live storm typing and local theme detection.
4. Confirm Continue becomes enabled after selecting a mood.
5. Confirm the live storm responds to typed keywords.
6. Confirm the Growth Action shows the pressure-themed tiny action, movable thought fragments, and a Tiny idea explanation.
7. Complete the seed-to-soil ritual and return to Today.
8. Tap the newest garden plant and confirm it shows a private memory card without reflection text.
9. Tap Preview Award Demo and confirm the Week memory strip, weekly review card, Inner Garden World, and Weekly Bloom payoff show a complete sample week without changing real check-ins.
10. Confirm the Weekly Bloom payoff includes the constellation reveal, time-lapse, week story, literacy unlock, closing ritual, next-week seed, privacy note, and archive preview.
11. Rotate or resize to a wider iPad/Mac review width and confirm Home uses the two-column storm-and-garden layout.
12. Switch the device or simulator to dark appearance and confirm text, panels, storm scenes, buttons, and garden notes remain readable.
13. Turn on Reduce Motion and confirm the garden remains understandable without relying on animation.
14. Turn on a larger text size and confirm the main flow remains scrollable and readable.

## Packaging Notes

This repository is a Swift Package prototype. For the final Apple upload, package it as an app playground directory named `BloomMind.swiftpm`, then ZIP that `.swiftpm` directory. Keep the final ZIP under 25 MB and verify it opens with Swift Playgrounds 4.6 or Xcode 26, or later.

Create the current local submission package with:

```sh
bash Scripts/create_submission_package.sh
```

Verify the generated package with:

```sh
bash Scripts/verify_submission_package.sh
```

Collect local review environment status with:

```sh
bash Scripts/collect_review_environment.sh
```

Current generated package verification:

- ZIP path: `SubmissionBuild/BloomMind.swiftpm.zip`
- ZIP size: 44,281 bytes after the Stage 7 package refresh.
- Contents: `BloomMind.swiftpm/Package.swift` plus `BloomMind.swiftpm/Sources/`.
- The generated ZIP excludes `.DS_Store` and `__MACOSX`.
- The generated `.swiftpm` package includes the Stage 7 Inner Garden World source files.
- The generated `.swiftpm` package passes `bash Scripts/verify_submission_package.sh` when Swift/Clang cache permissions are available.

2.0 readiness notes:

- The package now declares iOS and macOS platform support.
- The reflection field uses a multiline SwiftUI `TextField` for reliable typing across macOS, iPad, and Swift Playgrounds-style review environments.
- The pressure storm is native SwiftUI and does not require remote assets.
- The live storm, inner garden world, planting ritual, seed memory cards, and Weekly Bloom payoff are local SwiftUI and use only mood, theme, and lane metadata after planting, not private reflection text.
- The source set has no network, analytics, telemetry, CloudKit, HealthKit, or CoreLocation API usage.
- The final iPad or Swift Playgrounds smoke check moves to Stage 5 because it needs the actual review environment.
