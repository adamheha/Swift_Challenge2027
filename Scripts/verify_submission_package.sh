#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PACKAGE_DIR="${ROOT_DIR}/SubmissionBuild/BloomMind.swiftpm"
ZIP_PATH="${ROOT_DIR}/SubmissionBuild/BloomMind.swiftpm.zip"
SIZE_LIMIT_BYTES=$((25 * 1024 * 1024))

if [[ ! -d "${PACKAGE_DIR}" || ! -f "${ZIP_PATH}" ]]; then
    echo "Submission package not found."
    echo "Run: bash Scripts/create_submission_package.sh"
    exit 1
fi

ZIP_SIZE_BYTES="$(wc -c < "${ZIP_PATH}" | tr -d ' ')"

if (( ZIP_SIZE_BYTES > SIZE_LIMIT_BYTES )); then
    echo "Package is too large: ${ZIP_SIZE_BYTES} bytes."
    echo "Limit is ${SIZE_LIMIT_BYTES} bytes."
    exit 1
fi

ZIP_ENTRIES="$(unzip -Z -1 "${ZIP_PATH}")"

if ! grep -q "^BloomMind.swiftpm/Package.swift$" <<< "${ZIP_ENTRIES}"; then
    echo "ZIP is missing BloomMind.swiftpm/Package.swift"
    exit 1
fi

if ! grep -q "^BloomMind.swiftpm/Sources/" <<< "${ZIP_ENTRIES}"; then
    echo "ZIP is missing BloomMind.swiftpm/Sources/"
    exit 1
fi

if grep -E '(^|/)(\.DS_Store|__MACOSX|\.build|Tests|DerivedData)(/|$)' <<< "${ZIP_ENTRIES}"; then
    echo "ZIP contains generated or non-submission files."
    exit 1
fi

if grep -R -E "URLSession|http://|https://|Network|NWPath|analytics|telemetry|CloudKit|HealthKit|CoreLocation" "${PACKAGE_DIR}/Sources"; then
    echo "Submission sources contain network, telemetry, or unrelated platform API references."
    exit 1
fi

swift build --package-path "${PACKAGE_DIR}"

echo "Verified ${ZIP_PATH}"
echo "ZIP size: ${ZIP_SIZE_BYTES} bytes"
