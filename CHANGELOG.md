# Changelog

All notable changes to this project will be documented in this file.

## [0.3.0] - 2026-07-29

### 🐛 Bug Fixes

- [**breaking**] Keep one pipeline span across retries and redirects (_lud_)

## [0.2.0] - 2026-07-28

### 🚀 Features

- Use template path if present (_Łukasz Niemier_)
- Put full request and response structs into telemetry events (_martosaur_)
- [**breaking**] Rename ReqTelemetry to ReqTele (_lud_)

### 🐛 Bug Fixes

- Upgrade req to resolve dependency vulnerabilities (_Wígny_)

### 💼 Other

- Update locked deps to clear mint security advisories (_lud_)

### 📚 Documentation

- Add fork notice to README (_lud_)

### ⚙️ Miscellaneous Tasks

- Change source URL (_lud_)
- Setup default library checks and LICENSE (_lud_)
- Remove old CI workflow (_lud_)
- Setup versioning/changelog support (_lud_)

## [0.1.1] - 2024-07-10

### 🚀 Features

- Allow metadata to be set that is passed to the telemetry event (#2) (_Andrew Selder_)
- Support metadata at request time (_Zach Allaun_)

### 🐛 Bug Fixes

- [**breaking**] Raise if unknown events are passed to attach_default_logger/1 (_Zach Allaun_)
- Correctly merge initial options specified in attach with request options (_Zach Allaun_)
- Report duration in milliseconds, not microseconds (_Zach Allaun_)
- Report durations in :native time units (_Zach Allaun_)

### 💼 Other

- Req_telemetry (_Zach Allaun_)
- Add telemetry as a dependency (_Zach Allaun_)
- *(release)* V0.0.2 (_Zach Allaun_)
- V0.0.3 (_Zach Allaun_)
- Bump deps (_Zach Allaun_)

### 🚜 Refactor

- Normalize opts to map instead of keyword list (_Zach Allaun_)
- Attach_default_logger/1 can now accept an event kind as a shortcut (_Zach Allaun_)
- Specify empty list instead of map as default arg in attach/2 (_Zach Allaun_)

### 📚 Documentation

- Move req_telemetry moduledoc into readme (_Zach Allaun_)
- Reference attach/2 options in readme (_Zach Allaun_)
- Improve docs for attach_default_logger/1 (_Zach Allaun_)
- Remove redundant keyword (_Zach Allaun_)
- Copy edit some function docs and improve default logger examples (_Zach Allaun_)
- Add links to package and docs in readme (_Zach Allaun_)
- Link to req docs at top of readme (_Zach Allaun_)
- Fix code formatting in readme (_Zach Allaun_)
- Fix incorrect github ci badge (#7) (_Kian-Meng Ang_)
- Fix typos (#9) (_Kian-Meng Ang_)

### 🧪 Testing

- Attach/2 raises when given invalid opts (_Zach Allaun_)
- Add tests for event measurements and metadata (_Zach Allaun_)
- Ensure events not emitted and warning logged if invalid options passed to request (_Zach Allaun_)
- Add test for error event (_Zach Allaun_)
- Update assertion on logged message to support elixir 1.12 (_Zach Allaun_)

### ⚙️ Miscellaneous Tasks

- Github action to test on elixir 1.12-1.14 and otp 23-25 (_Zach Allaun_)
- Update github actions to new checkout@v3 and cache@v3 to avoid warnings (_Zach Allaun_)
- Latest deps (_Zach Allaun_)
- *(release)* 0.0.4 (_Zach Allaun_)
- Update ci test matrix (_Zach Allaun_)
- *(release)* V0.1.0 (_Zach Allaun_)
- Housekeeping (#8) (_Kian-Meng Ang_)
- Only run dialyzer if lint (_Zach Allaun_)
- *(release)* V0.1.1 (_Zach Allaun_)

