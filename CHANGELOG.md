# Changelog

All notable changes to this project will be documented in this file.

## [0.2.0] - 2026-07-28

### 🚀 Features

- Use template path if present (*Łukasz Niemier*)
- Put full request and response structs into telemetry events (*martosaur*)
- [**breaking**] Rename ReqTelemetry to ReqTele (*lud*)

### 🐛 Bug Fixes

- Upgrade req to resolve dependency vulnerabilities (*Wígny*)

### 💼 Other

- Update locked deps to clear mint security advisories (*lud*)

### 📚 Documentation

- Add fork notice to README (*lud*)

### ⚙️ Miscellaneous Tasks

- Change source URL (*lud*)
- Setup default library checks and LICENSE (*lud*)
- Remove old CI workflow (*lud*)
- Setup versioning/changelog support (*lud*)

## [0.1.1] - 2024-07-10

### 🚀 Features

- Allow metadata to be set that is passed to the telemetry event (#2) (*Andrew Selder*)
- Support metadata at request time (*Zach Allaun*)

### 🐛 Bug Fixes

- [**breaking**] Raise if unknown events are passed to attach_default_logger/1 (*Zach Allaun*)
- Correctly merge initial options specified in attach with request options (*Zach Allaun*)
- Report duration in milliseconds, not microseconds (*Zach Allaun*)
- Report durations in :native time units (*Zach Allaun*)

### 💼 Other

- Req_telemetry (*Zach Allaun*)
- Add telemetry as a dependency (*Zach Allaun*)
- *(release)* V0.0.2 (*Zach Allaun*)
- V0.0.3 (*Zach Allaun*)
- Bump deps (*Zach Allaun*)

### 🚜 Refactor

- Normalize opts to map instead of keyword list (*Zach Allaun*)
- Attach_default_logger/1 can now accept an event kind as a shortcut (*Zach Allaun*)
- Specify empty list instead of map as default arg in attach/2 (*Zach Allaun*)

### 📚 Documentation

- Move req_telemetry moduledoc into readme (*Zach Allaun*)
- Reference attach/2 options in readme (*Zach Allaun*)
- Improve docs for attach_default_logger/1 (*Zach Allaun*)
- Remove redundant keyword (*Zach Allaun*)
- Copy edit some function docs and improve default logger examples (*Zach Allaun*)
- Add links to package and docs in readme (*Zach Allaun*)
- Link to req docs at top of readme (*Zach Allaun*)
- Fix code formatting in readme (*Zach Allaun*)
- Fix incorrect github ci badge (#7) (*Kian-Meng Ang*)
- Fix typos (#9) (*Kian-Meng Ang*)

### 🧪 Testing

- Attach/2 raises when given invalid opts (*Zach Allaun*)
- Add tests for event measurements and metadata (*Zach Allaun*)
- Ensure events not emitted and warning logged if invalid options passed to request (*Zach Allaun*)
- Add test for error event (*Zach Allaun*)
- Update assertion on logged message to support elixir 1.12 (*Zach Allaun*)

### ⚙️ Miscellaneous Tasks

- Github action to test on elixir 1.12-1.14 and otp 23-25 (*Zach Allaun*)
- Update github actions to new checkout@v3 and cache@v3 to avoid warnings (*Zach Allaun*)
- Latest deps (*Zach Allaun*)
- *(release)* 0.0.4 (*Zach Allaun*)
- Update ci test matrix (*Zach Allaun*)
- *(release)* V0.1.0 (*Zach Allaun*)
- Housekeeping (#8) (*Kian-Meng Ang*)
- Only run dialyzer if lint (*Zach Allaun*)
- *(release)* V0.1.1 (*Zach Allaun*)

