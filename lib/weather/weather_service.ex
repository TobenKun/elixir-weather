defmodule Weather.WeatherService do
  require Logger
  import SweetXml

  @default_url "https://forecast.weather.gov/xml/current_obs"

  def fetch(airport) do
    make_url(airport)
    |> HTTPoison.get()
    |> handle_response()
  end

  def make_url(airport) do
    "#{@default_url}/#{airport}.xml"
  end

  def handle_response({_, %{status_code: 200, body: body}}) do
    {
      :ok,
      %{
        location: body |> xpath(~x"//location/text()"),
        station_id: body |> xpath(~x"//station_id/text()"),
        weather: body |> xpath(~x"//weather/text()"),
        temperature: body |> xpath(~x"//temperature_string/text()"),
        wind: body |> xpath(~x"//wind_string/text()")
      }
    }
  end

  def handle_response({_, %{status_code: _code, body: body}}) do
    inspect(body) |> Logger.error()
    {:error, body}
  end
end
