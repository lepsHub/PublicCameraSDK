#!/usr/bin/env bash
set -euo pipefail

# expects .release_* and .build_* files
# requires GH_TOKEN env set to a token with repo permissions

if [ -z "${GH_TOKEN:-}" ]; then
  echo "GH_TOKEN is required (set via env GH_EXTERNAL_PAT in workflow)"; exit 1
fi

gh_auth() {
  # gh already uses the environment token if GITHUB_TOKEN or GH_TOKEN set.
  export GITHUB_TOKEN="$GH_TOKEN"
}

gh_auth

for k in ${AFF// / }; do
  prefix="$(cat .release_${k}_prefix)"
  full="$(cat .release_${k}_full)"
  build_num="$(cat .release_${k}_build)"
  prerelease="$(cat .release_${k}_prerelease)"
  title="$(cat .release_${k}_title)"
  changelog="$(cat .release_${k}_changelog)"
  xcoutput="$(cat .build_${k}_xcoutput)"
  tag="${full}"

  if [ "$k" = "cam" ]; then
    # Truvideo/truvideo-sdk-ios-camera
    external_repo="lepsHub/PublicCameraSDK"
  else
    # Truvideo/truvideo-sdk-ios-core
    external_repo="lepsHub/PublicCoreSDK"
  fi

  ZIP_NAME="${tag}-${k}.xcframework.zip"
  rm -f "/tmp/${ZIP_NAME}"
  (cd "$(dirname "$xcoutput")" && zip -r "/tmp/${ZIP_NAME}" "$(basename "$xcoutput")")

  # check tag existence on external repo
  AUTH_REPO_URL="https://${GH_TOKEN}:x-oauth-basic@github.com/${external_repo}.git"
  if git ls-remote --tags "$AUTH_REPO_URL" | grep -q "refs/tags/${tag}"; then
    echo "Tag ${tag} already exists in ${external_repo}, skipping tag creation."
  else
    git tag "${tag}" || true
    git push "https://${GH_TOKEN}@github.com/${external_repo}.git" "refs/tags/${tag}" || true
  fi

  # ensure release exists
  if gh release view "${tag}" --repo "${external_repo}" >/dev/null 2>&1; then
    echo "Release ${tag} already exists in ${external_repo}"
  else
    gh api -X POST "repos/${external_repo}/releases" \
      -f tag_name="${tag}" \
      -f name="${tag}" \
      -f body="${title}\n\n${changelog}" \
      -F prerelease="${prerelease}" >/dev/null || true
  fi

  # upload asset (clobber replace)
  gh release upload "${tag}" "/tmp/${ZIP_NAME}" --repo "${external_repo}" --clobber || echo "Upload warn"
done

echo "External releases created/updated"
