defmodule Weather.WeatherService do
  @moduledoc """
  weather.gov에서 날씨를 가져오는 모듈입니다.
  fetch함수를 이용해서 원하는 공항의 날씨 데이터를 받아올 수 있습니다.
  Weather 애플리케이션 중에서 fetch 부분과 필요한 데이터 파싱 부분을 모아뒀습니다.
  """

  require Logger
  import SweetXml

  @default_url "https://forecast.weather.gov/xml/current_obs"

  @doc """
  파라미터로 받아온 공항의 날씨를 조회합니다.
  응답이 성공한 경우 {:ok, map}을 리턴하며,
  실패한 경우 {:error, map}을 리턴합니다.
  """
  def fetch(airport) do
    make_url(airport)
    |> HTTPoison.get()
    |> handle_response()
  end

  @doc """
  파라미터로 받아온 공항과 default_url을 합쳐서 url을 만듭니다.
  """
  def make_url(airport) do
    "#{@default_url}/#{airport}.xml"
  end

  @doc """
  HTTPoison.get() 의 결과를 파라미터로 받아옵니다.
  결과에서 status_code가 200일 경우, 내부 테이터를 파싱해서 맵으로 변환 후 {:ok, map}을 리턴합니다.

  200이외의 status_code를 받으면 Logger.error 함수를 호출하고 {:error, body}를 리턴합니다.
  이 경우 body는 후처리가 되지 않습니다.
  """
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
