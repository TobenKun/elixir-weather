defmodule Weather.CLITest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureIO

  alias Weather.CLI

  describe "decode_response/1" do
    test "returns map on success tuple" do
      assert CLI.decode_response({:ok, %{foo: "bar"}}) == %{foo: "bar"}
    end

    test "prints error and halts on error tuple" do
      error = %{"message" => "not found"}

      output =
        capture_io(fn ->
          assert catch_exit(CLI.decode_response({:error, error})) == 2
        end)

      assert output =~ "Error fetching from weather.gov: not found\n"
    end
  end

  describe "print_pretty/1" do
    test "prints formatted weather map" do
      map = %{location: "Seoul", temp: "20C"}

      output =
        capture_io(fn ->
          CLI.print_pretty(map)
        end)

      assert output =~ "Weather Station"
      assert output =~ "location"
      assert output =~ "temp"
      assert output =~ "Seoul"
      assert output =~ "20C"
    end
  end

  describe "print_one_line/2" do
    test "prints a single formatted line" do
      output =
        capture_io(fn ->
          CLI.print_one_line({:foo, "bar"}, 5)
        end)

      assert output =~ "foo   : bar\n"
    end
  end
end
