# BloomMind 2.0 Stage 5 Device Review

Stage 5 device review status: prepared, but not fully executable in the current command-line-only environment.

## Current Environment Finding

This workspace currently has Command Line Tools selected:

```text
/Library/Developer/CommandLineTools
```

`xcodebuild -version` reports that a full Xcode app is not selected. That means this environment can build SwiftPM packages, run tests, and create the submission ZIP, but it cannot complete the final Xcode, Swift Playgrounds, or iPad simulator smoke check.

## Environment Collection

Run this from the repository root:

```sh
bash Scripts/collect_review_environment.sh
```

The script reports:

- Swift version.
- Selected developer directory.
- Whether full Xcode is selected.
- Current submission ZIP path and size.
- Recommended next package checks.

## Full Xcode Setup

When full Xcode is installed, select it before the final review pass:

```sh
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
xcodebuild -version
```

Then rerun:

```sh
swift test
swift build
bash Scripts/create_submission_package.sh
bash Scripts/verify_submission_package.sh
```

## Xcode Smoke Check

Open the generated package:

```text
SubmissionBuild/BloomMind.swiftpm
```

Check:

- The package opens without missing files.
- The app launches to Today.
- Reflection accepts typed text.
- Continue works after selecting a mood, even if Reflection is empty.
- Preview Demo Week shows a sample full week without changing real check-ins.
- Show My Week returns to the user's actual week.
- The main one-minute path finishes in under 3 minutes.

## iPad Or Simulator Smoke Check

Use an actual iPad, Swift Playgrounds, or an iPad-sized simulator window.

Check:

- Today uses the intended iPad/Mac two-column layout at wider widths.
- Narrow widths fall back to a readable single-column layout.
- Text remains readable in light and dark appearances.
- Larger text sizes keep the flow scrollable.
- Reduce Motion keeps storm sorting and planting understandable.
- VoiceOver labels describe progress without exposing private reflection text.

## Demo Script

1. Open BloomMind.
2. Tap Enter the Storm.
3. Select Stressed.
4. Type: `I have a project due today and feel pressure to finish everything.`
5. Tap Continue.
6. Move at least one fragment between Now, Later, and Let go.
7. Tap Plant This Seed.
8. Confirm the garden shows the newest plant, Storm planted banner, Week memory, and weekly review card.
9. Tap Preview Demo Week.
10. Confirm the sample full week appears without changing real check-ins.
11. Tap Show My Week.
12. Confirm the real week returns.

## Stage 5 Remaining Blockers

- Full Xcode or Swift Playgrounds needs to be available locally.
- iPad or iPad-sized simulator smoke check still needs to be performed.
- The applicant still needs to provide a true personal motivation story before final submission.
