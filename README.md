<!-- rdmx :badges
    hexpm         : "req_tele?color=4e2a8e"
    github_action : "lud/req_tele/elixir.yaml?label=CI&branch=main"
    license       : req_tele
    -->
[![hex.pm Version](https://img.shields.io/hexpm/v/req_tele?color=4e2a8e)](https://hex.pm/packages/req_tele)
[![Build Status](https://img.shields.io/github/actions/workflow/status/lud/req_tele/elixir.yaml?label=CI&branch=main)](https://github.com/lud/req_tele/actions/workflows/elixir.yaml?query=branch%3Amain)
[![License](https://img.shields.io/hexpm/l/req_tele.svg)](https://hex.pm/packages/req_tele)
<!-- rdmx /:badges -->

> [!NOTE]
> This project is a fork of [`req_telemetry`](https://github.com/zachallaun/req_telemetry)
> by [Zach Allaun](https://github.com/zachallaun), maintained and published
> independently. It includes community contributions from the original
> repository.

<!-- MDOC !-->

[`Req`](https://hexdocs.pm/req) plugin to instrument requests with `:telemetry` events.

## Usage

Preferably, `ReqTele` should be the last plugin attached to your `%Req.Request{}`. This
allows `ReqTele` to emit events both at the very start and very end of the request and
response pipelines. In this way, you can observe both the total time spent issuing and
processing the request and response, as well as the time spent only with the request adapter.

```elixir
req = Req.new() |> ReqTele.attach()

req =
  Req.new(adapter: &my_adapter/1)
  |> ReqSomeOtherThing.attach()
  |> ReqTele.attach()
```

## Events

`ReqTele` produces the following events (in order of event dispatch):

  * `[:req, :request, :pipeline, :start]`
  * `[:req, :request, :adapter, :start]`
  * `[:req, :request, :adapter, :stop]`
  * `[:req, :request, :adapter, :error]`
  * `[:req, :request, :pipeline, :stop]`
  * `[:req, :request, :pipeline, :error]`

You can configure `ReqTele` to produce only `:pipeline` or `:adapter` events; see
`ReqTele.attach/2` for options.

## Logging

`ReqTele` defines a simple, default logger that logs basic request information and timing.

Here's how a successful request might be logged:

    Req:479128347 - GET https://example.org (pipeline)
    Req:479128347 - GET https://example.org (adapter)
    Req:479128347 - 200 in 403ms (adapter)
    Req:479128347 - 200 in 413ms (pipeline)

For usage and configuration, see `ReqTele.attach_default_logger/1`.

<!-- MDOC !-->

## Installation

`req_tele` is available through [hex.pm](https://hex.pm/packages/req_tele), and can be
installed by adding the following to your list of dependencies:

<!-- rdmx :app_dep vsn:$app_vsn -->
```elixir
defp deps do
  [
    {:req_tele, "~> 0.2"},
  ]
end
```
<!-- rdmx /:app_dep -->
