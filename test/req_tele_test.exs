defmodule ReqTeleTest do
  use ExUnit.Case

  import ExUnit.CaptureLog

  describe "attach/2" do
    test "merges default :telemetry options when none are specified" do
      req = Req.new() |> ReqTele.attach()
      assert {:ok, %{adapter: true, pipeline: true}} = ReqTele.fetch_options(req)
    end

    test "merges default :telemetry options when some are specified" do
      req = Req.new() |> ReqTele.attach(pipeline: false)
      assert {:ok, %{adapter: true, pipeline: false}} = ReqTele.fetch_options(req)

      req = Req.new() |> ReqTele.attach(adapter: false)
      assert {:ok, %{adapter: false, pipeline: true}} = ReqTele.fetch_options(req)

      req = Req.new() |> ReqTele.attach(adapter: false, pipeline: false)
      assert {:ok, %{adapter: false, pipeline: false}} = ReqTele.fetch_options(req)
    end

    test "accepts boolean options" do
      req = Req.new() |> ReqTele.attach(true)
      assert {:ok, %{adapter: true, pipeline: true}} = ReqTele.fetch_options(req)

      req = Req.new() |> ReqTele.attach(false)
      assert {:ok, %{adapter: false, pipeline: false}} = ReqTele.fetch_options(req)
    end

    test "raises if given invalid options" do
      invalid = [
        [{"adapter", false}],
        [unknown: true],
        [adapter: false, unknown: true],
        %{"adapter" => false},
        :unknown
      ]

      for opts <- invalid do
        assert_raise ArgumentError, fn -> Req.new() |> ReqTele.attach(opts) end
      end
    end
  end

  describe "attach_default_logger/1" do
    test "raises if given unknown events" do
      assert_raise ArgumentError, fn ->
        ReqTele.attach_default_logger([:unknown, :event])
      end
    end
  end

  describe "telemetry events" do
    @default_url "https://example.org"
    @default_status 200
    @default_headers [{"content-type", "application/json"}]
    @default_body ""

    defmodule Handler do
      def handle_event(event, measurements, metadata, _config) do
        send(self(), {:telemetry, event, measurements, metadata})
      end
    end

    defmodule MockAdapter do
      def run(request) do
        case Req.Request.get_private(request, :mock) do
          fun when is_function(fun, 1) -> fun.(request)
          %Req.Response{} = resp -> {request, resp}
          %{__exception__: true} = error -> {request, error}
        end
      end
    end

    defp mock(result, opts \\ []) do
      opts
      |> Keyword.merge(url: @default_url, adapter: MockAdapter)
      |> Req.new()
      |> Req.Request.put_private(:mock, result)
    end

    setup context do
      handler_id = "#{context[:test]}"

      :telemetry.attach_many(
        handler_id,
        ReqTele.events(),
        &Handler.handle_event/4,
        nil
      )

      # Handlers are global, so leaving them attached would make later tests
      # receive one copy of each event per test that ran before them.
      on_exit(fn -> :telemetry.detach(handler_id) end)

      mock_req = fn resp_attrs ->
        response = %Req.Response{
          status: @default_status,
          headers: @default_headers,
          body: @default_body
        }

        mock(Map.merge(response, resp_attrs))
      end

      mock_error = fn error -> mock(error) end

      %{mock_req: mock_req, mock_error: mock_error}
    end

    test "are emitted at the start and end of a request", %{mock_req: req} do
      req.(%{}) |> ReqTele.attach() |> Req.get!()

      assert_received {:telemetry, [:req, :request, :pipeline, :start], _, _}
      assert_received {:telemetry, [:req, :request, :adapter, :start], _, _}
      assert_received {:telemetry, [:req, :request, :adapter, :stop], _, _}
      assert_received {:telemetry, [:req, :request, :pipeline, :stop], _, _}
    end

    test "can be excluded with options to attach/1", %{mock_req: req} do
      req.(%{}) |> ReqTele.attach(false) |> Req.get!()
      refute_received {:telemetry, [:req, :request, _, _], _, _}

      req.(%{}) |> ReqTele.attach(pipeline: false) |> Req.get!()
      assert_received {:telemetry, [:req, :request, :adapter, _], _, _}
      refute_received {:telemetry, [:req, :request, :pipeline, _], _, _}
    end

    test "can be overridden with options passed to the request", %{mock_req: req} do
      req.(%{}) |> ReqTele.attach() |> Req.get!(telemetry: false)
      refute_received {:telemetry, [:req, :request, _, _], _, _}

      req.(%{}) |> ReqTele.attach() |> Req.get!(telemetry: [adapter: false])
      assert_received {:telemetry, [:req, :request, :pipeline, _], _, _}
      refute_received {:telemetry, [:req, :request, :adapter, _], _, _}
    end

    test "excluded in attach/1 can be overridden", %{mock_req: req} do
      req.(%{}) |> ReqTele.attach(false) |> Req.get!(telemetry: [adapter: true])
      assert_received {:telemetry, [:req, :request, :adapter, _], _, _}
      refute_received {:telemetry, [:req, :request, :pipeline, _], _, _}
    end

    test "include a :time measurement for :start events", %{mock_req: req} do
      req.(%{}) |> ReqTele.attach() |> Req.get!()

      for _ <- 1..2 do
        assert_received {:telemetry, [:req, :request, _, :start], %{time: ts}, _}
                        when is_integer(ts)
      end
    end

    test "include a :duration measurement for :stop events", %{mock_req: req} do
      req.(%{}) |> ReqTele.attach() |> Req.get!()

      for _ <- 1..2 do
        assert_received {:telemetry, [:req, :request, _, :stop], %{duration: d}, _}
                        when is_integer(d)
      end
    end

    test "include :url, :method, and :headers metadata for :start events", %{mock_req: req} do
      req.(%{}) |> ReqTele.attach() |> Req.post!()

      for _ <- 1..2 do
        assert_received {:telemetry, [:req, :request, _, :start], _,
                         %{url: %URI{}, method: :post, headers: headers}}
                        when is_map(headers)
      end
    end

    test "allows metadata to be sent with :start events", %{mock_req: req} do
      req.(%{}) |> ReqTele.attach(metadata: %{foo: "bar"}) |> Req.post!()

      for _ <- 1..2 do
        assert_received {:telemetry, [:req, :request, _, :start], _, %{metadata: %{foo: "bar"}}}
      end

      req.(%{}) |> ReqTele.attach() |> Req.post!(telemetry: [metadata: %{foo: "bar"}])

      for _ <- 1..2 do
        assert_received {:telemetry, [:req, :request, _, :start], _, %{metadata: %{foo: "bar"}}}
      end

      req.(%{})
      |> ReqTele.attach(metadata: %{foo: "bar"})
      |> Req.post!(telemetry: [metadata: %{baz: "buzz"}])

      for _ <- 1..2 do
        assert_received {:telemetry, [:req, :request, _, :start], _,
                         %{metadata: %{foo: "bar", baz: "buzz"}}}
      end

      req.(%{})
      |> ReqTele.attach(metadata: %{foo: "bar"})
      |> Req.post!(telemetry: [metadata: %{foo: "buzz"}])

      for _ <- 1..2 do
        assert_received {:telemetry, [:req, :request, _, :start], _, %{metadata: %{foo: "buzz"}}}
      end
    end

    test "include :url, :method, :status, :resp_headers metadata for :stop events", %{
      mock_req: req
    } do
      resp_headers = [{"some", "header"}]
      resp_status = 201

      req.(%{headers: resp_headers, status: resp_status}) |> ReqTele.attach() |> Req.post!()

      for _ <- 1..2 do
        assert_received {:telemetry, [:req, :request, _, :stop], _,
                         %{
                           url: %URI{},
                           method: :post,
                           resp_headers: ^resp_headers,
                           status: ^resp_status,
                           request: %Req.Request{},
                           response: %Req.Response{status: 201, body: ""}
                         }}
      end
    end

    test "contains template path", %{
      mock_req: req
    } do
      req.(%{})
      |> ReqTele.attach()
      |> Req.get!(
        url: "/:foo/bar",
        path_params: [foo: 2137]
      )

      for _ <- 1..2 do
        assert_received {:telemetry, [:req, :request, _, :stop], _,
                         %{
                           url: %URI{path: "/:foo/bar"},
                           method: :get
                         }}
      end
    end

    test "allows attach metadata to be sent with :stop events", %{mock_req: req} do
      req.(%{})
      |> ReqTele.attach(metadata: %{foo: "bar"})
      |> Req.post!()

      for _ <- 1..2 do
        assert_received {:telemetry, [:req, :request, _, :stop], _, %{metadata: %{foo: "bar"}}}
      end

      req.(%{})
      |> ReqTele.attach()
      |> Req.post!(telemetry: [metadata: %{foo: "bar"}])

      for _ <- 1..2 do
        assert_received {:telemetry, [:req, :request, _, :stop], _, %{metadata: %{foo: "bar"}}}
      end
    end

    test "include a ref in metadata correlating :start and :stop events", %{mock_req: req} do
      req.(%{}) |> ReqTele.attach() |> Req.get!()

      assert_received {:telemetry, [:req, :request, _, :start], _, %{ref: ref}}
                      when is_reference(ref)

      assert_received {:telemetry, [:req, :request, _, :stop], _, %{ref: ^ref}}
    end

    test "are not emitted if invalid options are given", %{mock_req: req} do
      message =
        capture_log(fn ->
          req.(%{}) |> ReqTele.attach() |> Req.get!(telemetry: :unknown)
        end)

      refute_received {:telemetry, [:req, :request, _, _], _, _}

      assert message =~ "[warning]" || message =~ "[warn]"
      assert message =~ ":unknown"
    end

    test "include a :duration measurement and :error metadata for :error events", %{
      mock_error: req
    } do
      error = Finch.Error.exception(:request_timeout)

      assert {:error, _} =
               req.(error)
               |> Req.Request.merge_options(retry: false)
               |> ReqTele.attach()
               |> Req.get()

      assert_received {:telemetry, [:req, :request, _, :error], %{duration: d}, %{error: ^error}}
                      when is_integer(d)
    end

    test "allows attach metadata to be sent with :error events", %{mock_req: req} do
      error = Finch.Error.exception(:request_timeout)

      assert {:error, _} =
               req.(error)
               |> Req.Request.merge_options(retry: false)
               |> ReqTele.attach(metadata: %{foo: "bar"})
               |> Req.get()

      assert_received {:telemetry, [:req, :request, _, :error], _, %{metadata: %{foo: "bar"}}}

      assert {:error, _} =
               req.(error)
               |> Req.Request.merge_options(retry: false)
               |> ReqTele.attach()
               |> Req.get(telemetry: [metadata: %{foo: "bar"}])

      assert_received {:telemetry, [:req, :request, _, :error], _, %{metadata: %{foo: "bar"}}}
    end

    test "emit one adapter pair per attempt and a single pipeline pair when retrying" do
      Process.put(:responses, [
        %Req.Response{status: 500, headers: %{}, body: ""},
        %Req.Response{status: 200, headers: %{}, body: ""}
      ])

      mock(&pop_response/1, retry_delay: 1, retry_log_level: false)
      |> ReqTele.attach()
      |> Req.get!()

      assert_received {:telemetry, [:req, :request, :pipeline, :start], _,
                       %{ref: ref, attempt: 1}}

      assert_received {:telemetry, [:req, :request, :adapter, :start], _,
                       %{ref: ^ref, attempt: 1}}

      assert_received {:telemetry, [:req, :request, :adapter, :stop], _, %{ref: ^ref, attempt: 1}}

      assert_received {:telemetry, [:req, :request, :adapter, :start], _,
                       %{ref: ^ref, attempt: 2}}

      assert_received {:telemetry, [:req, :request, :adapter, :stop], _, %{ref: ^ref, attempt: 2}}

      assert_received {:telemetry, [:req, :request, :pipeline, :stop], _,
                       %{ref: ^ref, attempt: 2}}

      refute_received {:telemetry, [:req, :request, _, _], _, _}
    end

    test "emit one adapter pair per attempt and a single pipeline pair when redirecting" do
      location = "#{@default_url}/final"

      Process.put(:responses, [
        %Req.Response{status: 302, headers: %{"location" => [location]}, body: ""},
        %Req.Response{status: 200, headers: %{}, body: ""}
      ])

      mock(&pop_response/1) |> ReqTele.attach() |> Req.get!()

      assert_received {:telemetry, [:req, :request, :pipeline, :start], _,
                       %{ref: ref, attempt: 1}}

      assert_received {:telemetry, [:req, :request, :adapter, :start], _,
                       %{ref: ^ref, attempt: 1}}

      assert_received {:telemetry, [:req, :request, :adapter, :stop], _, %{ref: ^ref, attempt: 1}}

      assert_received {:telemetry, [:req, :request, :adapter, :start], _,
                       %{ref: ^ref, attempt: 2, url: %URI{path: "/final"}}}

      assert_received {:telemetry, [:req, :request, :adapter, :stop], _, %{ref: ^ref, attempt: 2}}

      assert_received {:telemetry, [:req, :request, :pipeline, :stop], _,
                       %{ref: ^ref, attempt: 2}}

      refute_received {:telemetry, [:req, :request, _, _], _, _}
    end

    test "measure every attempt in the pipeline duration" do
      delay = 50

      Process.put(:responses, [
        %Req.Response{status: 500, headers: %{}, body: ""},
        %Req.Response{status: 200, headers: %{}, body: ""}
      ])

      mock(&pop_response/1, retry_delay: delay, retry_log_level: false)
      |> ReqTele.attach()
      |> Req.get!()

      assert_received {:telemetry, [:req, :request, :pipeline, :stop], %{duration: duration}, _}
      assert System.convert_time_unit(duration, :native, :millisecond) >= delay
    end

    test "emit one adapter error per attempt and a single pipeline error" do
      error = Req.TransportError.exception(reason: :timeout)

      assert {:error, _} =
               error
               |> mock(max_retries: 1, retry_delay: 1, retry_log_level: false)
               |> ReqTele.attach()
               |> Req.get()

      assert_received {:telemetry, [:req, :request, :adapter, :error], _, %{ref: ref, attempt: 1}}

      assert_received {:telemetry, [:req, :request, :adapter, :error], _,
                       %{ref: ^ref, attempt: 2}}

      assert_received {:telemetry, [:req, :request, :pipeline, :error], _,
                       %{ref: ^ref, attempt: 2}}

      refute_received {:telemetry, [:req, :request, _, :error], _, _}
    end
  end

  defp pop_response(request) do
    [response | rest] = Process.get(:responses)
    Process.put(:responses, rest)
    {request, response}
  end
end
