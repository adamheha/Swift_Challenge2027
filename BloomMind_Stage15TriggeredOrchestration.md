# BloomMind 5.4 Stage 15 - Triggered Orchestration

## Goal

Stage 15 answers the bloat problem directly. BloomMind has become rich, but too many strong pieces were visible at the same time. This stage adds a smarter trigger layer so the app reveals the right surface at the right moment instead of stacking every feature on Home.

## What Changed

- Added `ExperienceOrchestrator.swift`.
- Added 100 smart trigger rules across 10 moments:
  - First arrival
  - Today needs a seed
  - Feeling before label
  - Storm surgery
  - After planting
  - Growing week
  - Almost bloom
  - Weekly bloom
  - Judge path
  - Private archive
- Added `ExperienceSurfacePlan`, which decides when to show observatory tools, idea studio, garden depth, and weekly payoff.
- Added a Smart Trigger rail on Home that surfaces only three focused cards for the current moment.
- Added reveal controls so Observatory Tools and Idea Cycle Studio are available without always taking over the interface.
- Kept old rich features available, but moved them behind context and intent.

## Why It Matters

The app now has a stronger product rhythm:

- Before the first seed, the app emphasizes the opening lens and simple entry.
- When today has no check-in, the app points toward one seed instead of all systems.
- After planting, it shows consequence and garden response.
- Once the week has enough history, deeper exploration becomes relevant.
- When seven seeds unlock Weekly Bloom, the full ceremony earns the screen space.
- In demo mode, richer tools open automatically so the judge can see the strongest path.

This keeps BloomMind rich without making it feel crowded.

## Verification

- `swift test`: passed with 63 tests.
- `swift build`: passed after running with external module-cache access.
- `bash Scripts/create_submission_package.sh`: passed.
- `bash Scripts/verify_submission_package.sh`: passed after running with external module-cache access.
- ZIP size: 95,751 bytes.
