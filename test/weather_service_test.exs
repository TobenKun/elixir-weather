defmodule Weather.WeatherServiceTest do
  use ExUnit.Case, async: true

  alias Weather.WeatherService

  import ExUnit.CaptureLog

  describe "make_url/1" do
    test "returns correct URL for airport code" do
      assert WeatherService.make_url("ICN") ==
               "https://forecast.weather.gov/xml/current_obs/ICN.xml"
    end
  end

  describe "handle_response/1" do
    test "parses successful response" do
      xml = """
      <current_observation>
        <location>Seoul</location>
        <station_id>ICN</station_id>
        <weather>Clear</weather>
        <temperature_string>20.0 C (68.0 F)</temperature_string>
        <wind_string>Calm</wind_string>
      </current_observation>
      """

      resp = {:ok, %{status_code: 200, body: xml}}
      assert {:ok, data} = WeatherService.handle_response(resp)
      assert data.location == ~c"Seoul" or data.location == "Seoul"
      assert data.station_id == ~c"ICN" or data.station_id == "ICN"
      assert data.weather == ~c"Clear" or data.weather == "Clear"
      assert data.temperature == ~c"20.0 C (68.0 F)" or data.temperature == "20.0 C (68.0 F)"
      assert data.wind == ~c"Calm" or data.wind == "Calm"
    end

    test "logs and returns error for non-200 response" do
      log =
        capture_log(fn ->
          resp = {:ok, %{status_code: 404, body: "Not Found"}}
          assert {:error, "Not Found"} = WeatherService.handle_response(resp)
        end)

      assert log =~ "Not Found"
    end
  end
end
