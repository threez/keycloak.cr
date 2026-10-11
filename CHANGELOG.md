# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

- Bumped the `ameba` dev dependency from `~> 1.0.0` to `~> 1.7.0` and fixed all
  resulting `Lint/NotNil` and `Naming/BlockParameterName` violations.
- Refreshed the `oidc` dependency (unpinned `github` dependency) to pick up
  its own ameba 1.7.0 upgrade; no API changes were required on this side.
- Restructured the CI workflow into separate `lint` and `test` jobs, updated
  `actions/checkout` to `v4`, pinned Crystal to `1.20.2`, added shards
  caching and a compile check, and moved the `environment: ci` block (with
  the `CONFIG_NAME`/`CONFIG_URL`/`CONFIG_KEY` vars/secrets) onto the `test`
  job only.
- Normalized `.github/workflows/pages.yml` to `actions/checkout@v4`,
  `actions/upload-pages-artifact@v3`, `actions/deploy-pages@v4`, and added
  an explicit `actions/configure-pages@v5` step.
- Added `fmtcheck`, `fix`, `version`, `tag`, and `clean` targets to the
  `Makefile`, and fixed the `lib/ameba/bin/ameba` build rule to run
  `shards build ameba` explicitly, since ameba 1.7.0 no longer ships a
  `postinstall` hook.

## [0.1.1]

- See git history for changes prior to this changelog.
