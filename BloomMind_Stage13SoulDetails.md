# BloomMind 5.2 Stage 13 - The Soul Details

## Goal

Stage 13 makes BloomMind feel less like a finished feature set and more like a living, authored emotional world. The work focuses on small but memorable details: tactile calibration, visible consequences, private memory, time-aware atmosphere, weekly naming, and a built-in 90-second judge path.

## What Changed

- Added an Emotional Calibration Ring before mood selection so the student can express whether the feeling is loud or quiet, heavy or light.
- Connected calibration to the live storm, suggested mood, generated storm signal, and private memory stamp.
- Added Begin Journey and 90-second Demo doors to the Opening Origin Scene so judges can enter the guided path immediately.
- Added a time-aware garden tone on Home so the world responds to morning, afternoon, evening, unfinished check-ins, and completed days.
- Added a visible carry seed in the Home lens after the Weekly Bloom carry-forward ritual.
- Added a "What changed because of me?" garden panel explaining how Now, Later, or Let go changed roots, buds, or open air.
- Added Memory Without Text stamps to seed detail cards using day position, mood, theme, lane, and calibration shape without displaying reflection text.
- Added pressure constellation names for completed weeks.
- Added emotional vocabulary unlocks to Weekly Bloom so the completed week leaves a small idea, not just a summary.
- Added final story mode in Weekly Bloom to connect school pressure, weather, the seed, and the project origin line.
- Added short Award Demo Director captions so the 90-second path carries its own story beats.
- Added micro-interactions: layer peel traces, seed hover/tap air expansion, breathing artifacts, and a glowing carry-seed lens.

## Why It Matters

BloomMind already had a strong core loop: storm, sorting, planting, garden, weekly bloom. Stage 13 makes the loop feel more personal and less empty. A student now sees that:

- their pre-mood calibration changes the storm,
- their sorting choice changes the garden,
- their completed week receives a name,
- their private words are remembered only as shape,
- their carry-forward line follows them back to Home,
- the judge can understand the whole concept in 90 seconds.

That moves the project closer to an award-level experience: not just useful, but memorable.

## Files Touched

- `Sources/BloomMind/Models/JourneySystems.swift`: calibration, constellation names, garden time tone, consequence copy, memory stamps, vocabulary unlocks, and demo captions.
- `Sources/BloomMind/Models/CheckInState.swift`: calibration state and carry-seed prompt override.
- `Sources/BloomMind/Views/CheckInView.swift`: Emotional Calibration Ring.
- `Sources/BloomMind/Views/PressureStormView.swift`: live storm rendering now accepts the calibrated storm profile.
- `Sources/BloomMind/Views/OriginJourneyView.swift`: Begin Journey and 90-second Demo doors.
- `Sources/BloomMind/Views/HomeView.swift`: carry seed lens, time-aware garden tone, and demo-start handoff.
- `Sources/BloomMind/Views/EmotionGardenView.swift`: consequence panel, memory stamps, and plant micro-interactions.
- `Sources/BloomMind/Views/GrowthActionView.swift`: layer peel traces.
- `Sources/BloomMind/Views/WeeklyBloomPayoffView.swift`: constellation name, vocabulary unlocks, final story mode, and carry-seed callback.
- `Sources/BloomMind/BloomMindApp.swift`: opening demo path handoff.
- `Tests/BloomMindTests/MoodTests.swift`: Stage 13 model coverage.

## Verification

- `swift test`: passed with 56 tests and Stage 13 coverage.
- `bash Scripts/create_submission_package.sh`: passed; refreshed `SubmissionBuild/BloomMind.swiftpm.zip`.
- ZIP size: 86,098 bytes.
- `bash Scripts/verify_submission_package.sh`: ZIP contents and source safety checks passed before the standalone package build step.
- `swift build`: blocked by Swift/Clang module-cache sandbox permissions; external execution approval was unavailable due usage-limit rejection.
- Standalone package build inside `bash Scripts/verify_submission_package.sh`: blocked by the same Swift/Clang module-cache sandbox permission issue.
- Manual full Xcode, Swift Playgrounds, and iPad smoke checks still require the target review environment.

## Remaining Before Final Submission

- Replace the placeholder origin/personal meaning line with the applicant's true specific school-pressure story.
- Refresh official Apple Swift Student Challenge rules close to the real 2027 submission window.
- Open the generated `.swiftpm` package in full Xcode or Swift Playgrounds.
- Smoke check on an iPad or iPad-sized simulator.
