# Keeping the chart up to date and preserving GS specific configuration

The `sync.sh` script is used to keep the chart up to date with the upstream chart and to preserve Giant Swarm specific changes.
We use `vendir` to manage the chart dependencies and `git patch` to apply the Giant Swarm specific changes.

## How to sync the chart with upstream

The `vendir.yml` configuration points to a specific version of the upstream chart.
Running `vendir sync` will sync the `helm` directory in this repository with the version defined there.

1. Update the chart version in the `vendir.yml` file.
2. Run `vendir sync`

## How to maintain Giant Swarm specific changes to upstream values and manifests

This folder contains the `sync.sh` script which does the following:

- Syncs the chart with the upstream chart. (See above)
- Applies all patches in the `patches` directory to the chart.
- Generates the json schema for the chart values.

Generally running the script should be enough to keep the chart up to date with the upstream chart and to preserve Giant Swarm specific changes.

1. Update the chart version in the `vendir.yml` file.
2. Run `./sync.sh`

However, if the upstream chart changes in a way that conflicts with a patch, it might have to be regenerated.

## How to generate a patch

Patches are simply git diffs of the changes made to the upstream chart.

1. Run `vendir sync` to get the latest upstream chart.
2. Commit only the manifest that you want to generate a patch for.
3. Make the Giant Swarm specific changes to the manifest.
4. Run `git diff helm/kamaji-etcd/PATH/TO/FILE > sync/patches/PATCH_NAME/_FILE_NAME.patch`
5. Run `./sync.sh` to apply all patches.

## Current patches

### Chart.yaml patch
Location: `sync/patches/chart/_Chart.yaml.patch`

Adds Giant Swarm specific annotations to the chart metadata:
- `application.giantswarm.io/team`: Identifies the team responsible for maintaining this app
- `application.giantswarm.io/readme`: Points to the Giant Swarm repository
- `application.giantswarm.io/upstream`: Points to the upstream repository

### values.yaml patch
Location: `sync/patches/values/_values.yaml.patch`

Changes the default image repository to use Giant Swarm's container registry:
- Changes `repository` from `quay.io/coreos/etcd` to `gsoci.azurecr.io/giantswarm/etcd`

This ensures images are pulled from Giant Swarm's trusted registry which provides:
- Vulnerability scanning
- Image caching for improved reliability
- Compliance with Giant Swarm's security policies

### helpers.tpl patch
Location: `sync/patches/helpers/_templates___helpers.tpl.patch`

Adds the Giant Swarm team label to the common labels template:
- Adds `application.giantswarm.io/team` label to all resources created by the chart

This ensures all Kubernetes resources are properly labeled for monitoring and team ownership tracking.

## Adding new patches

To add a new patch for a different file:

1. Create a new directory under `sync/patches/` (e.g., `sync/patches/myfile/`)
2. Create the patch file with the naming convention `_filename.patch`
3. Create a `patch.sh` script following the pattern in other patch directories
4. Make the script executable: `chmod +x sync/patches/myfile/patch.sh`
5. Add the patch script to the `sync.sh` main script
6. Document the patch in this README

## Troubleshooting

### Patch fails to apply

If a patch fails to apply after syncing with a new upstream version:

1. Check what changed in the upstream file
2. Manually apply the Giant Swarm specific changes
3. Regenerate the patch file using the steps in "How to generate a patch"
4. Test the new patch by running `./sync.sh`

### Schema generation fails

If the schema generation step fails:

1. Ensure Docker is running
2. Check that the helm chart is valid: `helm lint helm/kamaji-etcd`
3. Try running the schema generation command manually to see the full error
