# Changelog

This format is based on [Keep a Changelog](https://keepachangelog.com) and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased

### Changed

  * **Breaking:** Renamed the project from `req_telemetry`/`ReqTelemetry` to `req_tele`/`ReqTele`. This package is a fork of [`req_telemetry`](https://github.com/zachallaun/req_telemetry) by Zach Allaun.
  * Event `:url` metadata now uses the path params template when present ([zachallaun/req_telemetry#11](https://github.com/zachallaun/req_telemetry/pull/11), thanks @hauleth!)

### Added

  * Event metadata now includes the full `Req.Request` and `Req.Response` structs under the `:request` and `:response` keys ([zachallaun/req_telemetry#12](https://github.com/zachallaun/req_telemetry/pull/12), thanks @martosaur!)

### Fixed

  * Upgrade `req` to `~> 0.6` to resolve dependency vulnerabilities. ([zachallaun/req_telemetry#13](https://github.com/zachallaun/req_telemetry/pull/13), thanks @Wigny!)

## v0.1.1 (2024-7-10)

### Fixed

  * Fixed a Dialyzer error.

## v0.1.0 (2024-7-9)

### Added

  * Add support for `req` 0.5.X ([#6](https://github.com/zachallaun/req_telemetry/pull/6), thanks @nicholasbair!)

### Changed

  * **Breaking:** `req_telemetry` now requires Elixir 1.13+.

## v0.0.4 (2024-1-29)

### Added

  * Add support for `req` 0.4.X ([#5](https://github.com/zachallaun/req_telemetry/pull/5), thanks @aselder!)
