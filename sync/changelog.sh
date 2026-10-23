#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd ) ; readonly SCRIPT_DIR
source "${SCRIPT_DIR}"/_helpers.sh

# this script is deliberately not called by sync.sh; the sync diff check runs
# sync.sh on every pull request and it must not rewrite the changelog.

CHANGELOG="${REPO_DIR}/CHANGELOG.md" ; readonly CHANGELOG

# get the upstream sync version from vendir.yml
UPSTREAM_SYNC_VERSION=$(yq -r .directories[0].contents[0].git.ref "${REPO_DIR}"/vendir.yml) ; readonly UPSTREAM_SYNC_VERSION

ENTRY="- Update upstream kamaji-etcd chart to ${UPSTREAM_SYNC_VERSION}." ; readonly ENTRY

# running this twice with the same version must not change the file, otherwise
# the sync workflow loops. existing entries are never changed or removed.
if grep -qxF -- "${ENTRY}" "${CHANGELOG}"; then
    echo "Changelog entry already present: ${ENTRY}"
    exit 0
fi

echo "Adding changelog entry: ${ENTRY}"

# find out if the Unreleased section already has a Changed heading
HAS_CHANGED=$(awk '
$0 == "## [Unreleased]" { in_unreleased = 1 ; next }
in_unreleased && /^## \[/ { exit }
in_unreleased && $0 == "### Changed" { print 1 ; exit }
' "${CHANGELOG}") ; readonly HAS_CHANGED

TMP_FILE=$(mktemp) ; readonly TMP_FILE

# add the entry to the top of the Changed list in the Unreleased section, and
# add the Changed heading if it does not exist.
awk -v entry="${ENTRY}" -v has_changed="${HAS_CHANGED}" '
# put the entry before the first item of the Changed list
want && /^- / { print entry ; want = 0 }
# the Changed list is empty
want && /^#/ { print entry ; print "" ; want = 0 }
$0 == "## [Unreleased]" {
    print
    in_unreleased = 1
    if (has_changed == "") { print "" ; print "### Changed" ; print "" ; print entry }
    next
}
# the next release heading ends the Unreleased section
in_unreleased && /^## \[/ { in_unreleased = 0 }
in_unreleased && $0 == "### Changed" { want = 1 }
{ print }
' "${CHANGELOG}" > "${TMP_FILE}"

# keep the mode of the existing file
cat "${TMP_FILE}" > "${CHANGELOG}"
rm "${TMP_FILE}"
