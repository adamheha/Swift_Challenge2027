# BloomMind 2.0 Stage 5 Packaging

Stage 5 status: in progress.

## Official Rules Refresh

Checked on May 8, 2026 against Apple's official Swift Student Challenge pages:

- Swift Student Challenge overview: https://developer.apple.com/swift-student-challenge/
- Eligibility and requirements: https://developer.apple.com/swift-student-challenge/eligibility/
- Terms and conditions: https://developer.apple.com/swift-student-challenge/policy/

Apple's official pages currently show the 2026 challenge and 2026 terms. A 2027-specific rules page was not published on the official Apple Developer site during this check, so BloomMind continues to use the latest official 2026 submission requirements as the packaging baseline.

Current baseline requirements:

- Submit an app playground directory named with the `.swiftpm` extension inside a ZIP file.
- The app should work offline, with local resources included in the ZIP.
- The ZIP file can be up to 25 MB.
- The app playground must run in Swift Playgrounds 4.6 or Xcode 26, or later.
- The experience should fit within 3 minutes.
- All content should be in English.
- AI assistance must be disclosed.

## Packaging Command

Create a fresh package from the repository root:

```sh
bash Scripts/create_submission_package.sh
```

The script creates:

```text
SubmissionBuild/BloomMind.swiftpm/
SubmissionBuild/BloomMind.swiftpm.zip
```

The script copies only:

- `Packaging/BloomMindSubmissionPackage.swift` as the submitted `Package.swift`
- `Sources/`

It excludes generated files such as `.DS_Store`, keeps tests and repository docs out of the final app playground, and checks the ZIP against the 25 MB limit.

## First Package Verification

Generated package result:

- ZIP path: `SubmissionBuild/BloomMind.swiftpm.zip`
- ZIP size: 30,021 bytes
- ZIP contents: `BloomMind.swiftpm/Package.swift` plus `BloomMind.swiftpm/Sources/`
- No `.DS_Store` or `__MACOSX` entries in the ZIP.
- Generated package builds with:

```sh
swift build --package-path SubmissionBuild/BloomMind.swiftpm
```

## Remaining Stage 5 Work

- Open `SubmissionBuild/BloomMind.swiftpm` in full Xcode or Swift Playgrounds.
- Smoke check the package on an iPad or iPad-sized simulator.
- Refresh official rules again close to submission.
- Replace the personal motivation scaffold with the applicant's true story.
- Recreate the ZIP after any future code changes.
