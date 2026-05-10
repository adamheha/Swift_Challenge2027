#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ZIP_PATH="${ROOT_DIR}/SubmissionBuild/BloomMind.swiftpm.zip"
PACKAGE_DIR="${ROOT_DIR}/SubmissionBuild/BloomMind.swiftpm"

echo "BloomMind review environment"
echo "============================"
echo

echo "Swift:"
swift --version
echo

echo "Selected developer directory:"
xcode-select -p
echo

echo "Xcode:"
if xcodebuild -version; then
    :
else
    echo "Full Xcode is not selected. Select it with:"
    echo "sudo xcode-select -s /Applications/Xcode.app/Contents/Developer"
fi
echo

echo "Submission package:"
if [[ -f "${ZIP_PATH}" ]]; then
    ZIP_SIZE_BYTES="$(wc -c < "${ZIP_PATH}" | tr -d ' ')"
    echo "ZIP: ${ZIP_PATH}"
    echo "ZIP size: ${ZIP_SIZE_BYTES} bytes"
else
    echo "ZIP not found. Run:"
    echo "bash Scripts/create_submission_package.sh"
fi
echo

if [[ -d "${PACKAGE_DIR}" ]]; then
    echo "Package directory: ${PACKAGE_DIR}"
else
    echo "Package directory not found."
fi
echo

echo "Recommended checks:"
echo "bash Scripts/create_submission_package.sh"
echo "bash Scripts/verify_submission_package.sh"
echo "Open SubmissionBuild/BloomMind.swiftpm in full Xcode or Swift Playgrounds."
