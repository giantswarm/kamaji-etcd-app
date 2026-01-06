# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Added `sync/` folder with patch-based sync system for maintaining Giant Swarm specific overrides
- Added patches for Chart.yaml annotations, values.yaml image registry, and helpers template labels
- Added `sync.sh` script to automate chart syncing, patching, and schema generation
- Added documentation in `sync/README.md` describing the sync system and how to add new patches

### Changed

- Changed default image repository to use Giant Swarm's container registry (`gsoci.azurecr.io/giantswarm/etcd`)
- Changed `app.giantswarm.io` label group to `application.giantswarm.io`

[Unreleased]: https://github.com/giantswarm/kamaji-etcd-app/tree/main
