# BloomMind 2.0 Stage 6 Weekly Bloom Payoff

Stage 6 answers the product gap discovered during hands-on use: after seven seeds, the user should not feel "that's it?" The full-week moment now becomes a story reveal instead of a plain progress state.

## Goal

Make seven completed check-ins unlock a memorable emotional ending:

- The week becomes a single bloom, not just seven separate plants.
- The garden summarizes mood, theme, and Now / Later / Let go choices without showing private reflection text.
- Every sorting choice leaves a visible consequence in the garden.
- Preview Award Demo can show the complete award demo path in under 90 seconds.

## Completed

- Added `GardenSeed`, which stores the mood, local reflection theme, and selected Now / Later / Let go lane for each planted seed.
- Added `GrowthLane` as shared model logic so sorting choices can affect both Growth Action and Home.
- Updated planting so the selected lane and detected theme are saved when the seed enters the garden.
- Added a living garden line that describes the week's mood weather and lane consequence.
- Added lane consequence glyphs and private plant notes so Now becomes roots, Later becomes buds, and Let go becomes open air.
- Added a Weekly Bloom payoff that unlocks at 7/7 seeds with a constellation-style reveal, week story, local insight, closing ritual, next-week seed, and privacy note.
- Updated Preview Award Demo so it includes mood, theme, and lane data for the full award path.
- Added unit tests for seed consequence storage, weekly bloom unlock, demo-week payoff, privacy-preserving summary text, and updated accessibility copy.
- Refreshed the generated submission ZIP with the Stage 6 source files; current size is 38,004 bytes.

## Demo Path

1. Open BloomMind.
2. Tap Preview Award Demo from Today.
3. Confirm the garden fills with seven mood-specific seeds.
4. Confirm the living garden line explains the week's emotional ecology.
5. Confirm the Weekly Bloom payoff appears with "This week bloomed."
6. Confirm the week story and insight do not show private reflection text.
7. Tap Show My Week and confirm the real check-ins return.

## Verification

Run after every Stage 6 code change:

```sh
swift test
swift build
bash Scripts/create_submission_package.sh
bash Scripts/verify_submission_package.sh
```

## Remaining Before Final Submission

- Smoke check the Weekly Bloom reveal in full Xcode or Swift Playgrounds.
- Smoke check on iPad or an iPad-sized simulator.
- Replace the personal motivation scaffold with the applicant's true story.
- Refresh official rules close to the 2027 submission window.
