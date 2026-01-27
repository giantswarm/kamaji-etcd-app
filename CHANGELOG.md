# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

- Disable selfsignedcerts and set localpathprovisioner as default storage class.
- Switch to pushing chart to default-catalog to make it available as a helmrelease.

## [0.1.0] - 2026-01-26

### Changed

- Push chart to control-plane-catalog.
- Push to `kamaji-addons-app-collection`.

### Added

- Added `sync/` folder with patch-based sync system for maintaining Giant Swarm specific overrides
- Added vendir configuration for syncing upstream chart
- Initial Chart creation

[Unreleased]: https://github.com/giantswarm/kamaji-etcd-app/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/giantswarm/kamaji-etcd-app/releases/tag/v0.1.0
