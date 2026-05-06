# BloomMind Submission Package

## Latest Rules Check

Checked on May 6, 2026. Apple has not published Swift Student Challenge 2027 rules yet, so this package is aligned with the latest official 2026 requirements:

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

- https://developer.apple.com/swift-student-challenge/eligibility/
- https://developer.apple.com/swift-student-challenge/policy/

## Final One-Minute Demo Path

Target review time: 60 seconds.

1. Open BloomMind.
2. On the Today screen, point out the weekly bloom progress, emotion garden, local privacy status, and start button.
3. Tap Start Check-In.
4. Select Stressed.
5. Enter this short reflection:

   `I have a project due today and feel pressure to finish everything.`

6. Tap Continue.
7. Review the generated Growth Action:

   `Make it tiny: choose one thing that can wait, then start only the next tiny step.`

8. Note that BloomMind detects a pressure theme locally without sending or saving the private reflection text.
9. Tap Complete Check-In.
10. Return to Today and confirm the garden has grown with a mood-specific plant.

## Submission Response Drafts

### App Summary

BloomMind is a privacy-first SwiftUI app playground that helps students turn overwhelming school emotions into one tiny, doable next step. The app guides a student through a short daily check-in: choose a mood, write a brief reflection, receive a small local action, and watch that feeling become part of a growing emotion garden.

### Personal Motivation

I wanted to build BloomMind because students often have only a minute or two to notice what they feel before moving to the next class, assignment, or responsibility. Many wellness tools feel too heavy, clinical, or time-consuming for that moment. BloomMind is designed to feel calm and approachable: it does not diagnose the user, collect private data, or ask for an account. It simply helps a student name what is present and take one small next step.

### Creativity And Impact

The main creative idea is that emotions become growth. Instead of showing a generic checklist, BloomMind turns completed reflections into mood-specific plants in an emotion garden. Calm, happy, tired, stressed, and unsure moods each have a different visual identity, so the garden becomes a gentle record of self-awareness. This makes the app feel more memorable than a standard tracker while still staying useful and quick.

### Technical Work

BloomMind is built with SwiftUI and local state. The app uses a typed navigation flow, responsive SwiftUI layouts, Dynamic Type support, VoiceOver labels and values, Reduce Motion handling, and unit-tested model logic. A small local action engine analyzes simple reflection themes such as school, friendship, rest, pressure, and uncertainty. That theme is combined with the selected mood to create one tiny action. The reflection text stays local in the prototype and is not displayed again on the action screen.

### Privacy And Safety

BloomMind is intentionally local-first. It includes no accounts, analytics, tracking, cloud sync, or network calls. The language avoids diagnosis and medical claims, and every suggestion is framed as a small student-centered action rather than treatment or advice. The prototype is meant for personal reflection and growth, not for clinical support.

### Tool Disclosure Draft

AI assistance was used to help brainstorm, organize documentation, and review implementation details. The app idea, product direction, code decisions, and final submission understanding remain my responsibility, and I can explain how the SwiftUI screens, local state, action engine, accessibility behavior, and tests work.

## Final Review Checklist

- Open the app and complete the demo path in under 3 minutes.
- Confirm the one-minute demo path works without any network connection.
- Run `swift test`.
- Run `swift build`.
- Confirm the ZIP package is under 25 MB.
- Confirm all visible app and submission writing is in English.
- Confirm no secrets, accounts, analytics, telemetry, or network calls are included.
- Confirm any AI usage is disclosed in the final submission form.

## Packaging Notes

This repository is a Swift Package prototype. For the final Apple upload, package it as an app playground directory named `BloomMind.swiftpm`, then ZIP that `.swiftpm` directory. Keep the final ZIP under 25 MB and verify it opens with Swift Playgrounds 4.6 or Xcode 26, or later.
