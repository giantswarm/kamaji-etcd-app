#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd ) ; readonly dir
cd "${dir}/.."

# Stage 1 sync - intermediate to the ./vendir folder
set -x
vendir sync
helm dependency update helm/kamaji-etcd/
{ set +x; } 2>/dev/null

# Patches
./sync/patches/chart/patch.sh
./sync/patches/values/patch.sh
./sync/patches/helpers/patch.sh
./sync/patches/statefulset/patch.sh
./sync/patches/job-preinstall-1/patch.sh
./sync/patches/job-preinstall-2/patch.sh
./sync/patches/job-postdelete/patch.sh

# Generate schema
echo "Generating values schema..."
{ set +x; } 2>/dev/null
if ! helm plugin list | grep -q values-schema-json; then
  helm plugin install https://github.com/losisin/helm-values-schema-json.git --verify=false || true
fi
cd helm/kamaji-etcd && helm schema
cd "${dir}/.."
echo "✓ Schema generated successfully"
