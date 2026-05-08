#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="${ROOT_DIR}/SubmissionBuild"
PACKAGE_DIR="${BUILD_DIR}/BloomMind.swiftpm"
ZIP_PATH="${BUILD_DIR}/BloomMind.swiftpm.zip"
SIZE_LIMIT_BYTES=$((25 * 1024 * 1024))

if [[ -e "${PACKAGE_DIR}" || -e "${ZIP_PATH}" ]]; then
    echo "SubmissionBuild already contains package output."
    echo "Move or remove SubmissionBuild before creating a new package."
    exit 1
fi

mkdir -p "${PACKAGE_DIR}"
cp "${ROOT_DIR}/Packaging/BloomMindSubmissionPackage.swift" "${PACKAGE_DIR}/Package.swift"
rsync -a --exclude ".DS_Store" "${ROOT_DIR}/Sources/" "${PACKAGE_DIR}/Sources/"

(
    cd "${BUILD_DIR}"
    zip -qry "BloomMind.swiftpm.zip" "BloomMind.swiftpm" -x "*/.DS_Store" "__MACOSX/*"
)

ZIP_SIZE_BYTES="$(wc -c < "${ZIP_PATH}" | tr -d ' ')"

if (( ZIP_SIZE_BYTES > SIZE_LIMIT_BYTES )); then
    echo "Package is too large: ${ZIP_SIZE_BYTES} bytes."
    echo "Limit is ${SIZE_LIMIT_BYTES} bytes."
    exit 1
fi

echo "Created ${ZIP_PATH}"
echo "ZIP size: ${ZIP_SIZE_BYTES} bytes"
