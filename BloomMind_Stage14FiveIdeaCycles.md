# BloomMind 5.3 Stage 14 - Five Idea Cycles

## Goal

This stage runs five idea-generation and implementation loops. Each loop creates ten new ideas, then turns the round into a visible and testable BloomMind update.

## Round 1 - Living Micro-Details

Ten ideas:

1. Thought fireflies around the newest seed.
2. Lens fingerprints from weekly choices.
3. Garden breath meter for cramped vs. spacious weeks.
4. Carry seed shimmer when tomorrow is waiting.
5. Hidden non-private long-press whispers.
6. Mood color echoes across small surfaces.
7. Weather crumbs that guide the student back into the story.
8. Quiet empty states that feel intentional.
9. Hover halo around responsive plants.
10. Carry-line glow for the weekly ritual sentence.

Implemented:

- Added `IdeaCycleSystems.swift` with the first round as structured local data.
- Added an Idea Cycle Studio on Home so the ten sparks are visible inside the app.
- Added unit coverage confirming Round 1 has exactly ten sparks and is accessible.

Verification:

- `swift test`: passed with 57 tests.

## Round 2 - Return Hooks

Ten ideas:

1. Tomorrow postcard for the next self.
2. No-shame streak language.
3. Surprise seed after a completed week.
4. Mini quest that asks the student to notice one small thing.
5. Unfinished cloud at the garden edge.
6. Weekly invitation toward the next artifact.
7. Garden postcard inside the private app.
8. Time-window whispers for morning, afternoon, and evening.
9. Focus breadcrumb from a Now choice.
10. Soft reminder script that sounds human instead of demanding.

Implemented:

- Added Round 2 to `IdeaCycleSystems.swift`.
- The Home Idea Cycle Studio now supports multiple rounds and switches between them.
- Added unit coverage confirming Round 2 adds exactly ten return-focused sparks and brings the total to twenty ideas.

Verification:

- `swift test`: passed with 58 tests.
