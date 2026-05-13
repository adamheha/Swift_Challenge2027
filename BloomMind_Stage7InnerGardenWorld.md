# BloomMind 3.0 Stage 7 Inner Garden World

Stage 7 begins BloomMind 3.0. The goal is to make the app feel less like a tracker and more like a living emotional landscape where every private choice visibly changes the world.

## Product Problem

The previous 2.6 version gave the week a stronger ending, but the experience could still feel like completing a flow and reading a summary. BloomMind needed more cause-and-effect:

- Typing a reflection should visibly affect the storm.
- Planting should feel like a ritual, not only a button.
- The garden should feel spatial and explorable.
- Each seed should hold a private memory card without resurfacing reflection text.
- The weekly ending should show a time-lapse of transformation, not only a static reveal.

## Completed

- Added Live Storm Typing: reflection text now creates live storm keywords, theme color, intensity, and accessible storm feedback.
- Added a stronger seed-to-soil planting ritual on Growth Action.
- Added an Inner Garden World scene with sky, mood weather, roots, buds, open air, and world plants.
- Expanded seed memory cards with mood, theme, lane, tiny action, world-change summary, and privacy-preserving memory sentence.
- Added Weekly Bloom time-lapse phases: Storm, Seeds, World, Bloom.
- Added Emotional Literacy Unlocks based on the week's dominant theme or mood.
- Added a Return Tomorrow hook so the user has a next seed to notice after today.
- Added a personal origin line on Home to make the project feel student-made and emotionally grounded.
- Reframed the completed-week preview as Preview Award Demo, with a guided evaluator path.
- Added unit tests for live storm profiles, seed memory summaries, literacy unlocks, and return-tomorrow prompts.
- Refreshed and verified the generated submission ZIP; current size is 44,281 bytes.

## Main Demo Path

1. Open BloomMind.
2. Tap Enter the Storm.
3. Select Stressed.
4. Type: `I have a project deadline and too much to finish.`
5. Confirm the storm responds with live keywords and pressure-themed weather.
6. Continue to Growth Action.
7. Move fragments through Now, Later, and Let go.
8. Press the seed into the soil and confirm the selected lane changes the planting ritual.
9. Return to Today and inspect the Inner Garden World.
10. Tap a seed and confirm the memory card shows theme, action, and world change without reflection text.
11. Tap Preview Award Demo.
12. Confirm the Weekly Bloom includes constellation reveal, time-lapse, emotional literacy unlock, closing ritual, next-week seed, and archive preview.

## Verification

Run after every Stage 7 code change:

```sh
swift test
swift build
bash Scripts/verify_submission_package.sh
```

## Remaining Before Final Submission

- Smoke check the full 3.0 path in full Xcode or Swift Playgrounds.
- Smoke check on iPad or an iPad-sized simulator.
- Replace the generic origin line with the applicant's true personal story.
- Refresh official Apple rules close to submission.
