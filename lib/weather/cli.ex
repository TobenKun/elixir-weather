defmodule Weather.CLI do
  @moduledoc """
  weather.gov 에서 특정 공항의 날씨를 불러와 포매팅 하여 출력합니다.
  기본적으로 KABQ 공항이 하드코딩 되어있으며, @default_airport 속성을 변경해 다른 공항의 날씨를 가져올 수 있습니다.
  """

  @default_airport "KABQ"

  @doc """
  프로그램의 진입점입니다.
  아무 파라미터를 받지 않고, @default_airport의 날씨를 출력합니다.
  """
  def main(_) do
    @default_airport
    |> process
  end

  @doc """
  파라미터로 공항의 날씨를 받아와
  1. 해당 공항의 날씨를 받아오고,
  2. 결과를 확인한 뒤,
  3. 포매팅 하여 출력합니다.
  """
  def process(airport) do
    Weather.WeatherService.fetch(airport)
    |> decode_response()
    |> print_pretty()
  end

  @doc """
  응답을 확인합니다.
  응답 튜플의 첫 번째 요소가 :ok인지 :error인지 확인합니다.
  :ok이면 튜플의 두 번째 요소를 반환하며
  :error이면 에러를 출력하고 프로그램이 종료됩니다.

  ## Examples

  iex> decode_response({:ok, %{hello: world}})
  %{hello: world}

  iex> decode_response({:error, %{"message": "not found"}})
  Error fetching from weather.gov: not found
  exit(2)

  """
  def decode_response({:ok, map}) do
    map
  end

  def decode_response({:error, error}) do
    IO.puts("Error fetching from weather.gov: #{error["message"]}")
    exit(2)
  end

  @doc """
  헤더의 길이를 세고, 헤더의 길이에 맞춰 print_one_line함수를 호출합니다.
  함수를 호출하기 전과 후에 구분선을 출력합니다.
  """
  def print_pretty(map) do
    header_width =
      Map.keys(map) |> Enum.map(&Atom.to_string/1) |> Enum.map(&String.length/1) |> Enum.max()

    IO.puts("======================= Weather Station ========================")
    Enum.each(map, &print_one_line(&1, header_width))
    IO.puts("================================================================")
  end

  @doc """
  키워드 리스트와 폭을 받아와서 폭에 맞게 키를 출력하고 나머지 밸류를 출력합니다.
  아톰으로 들어오는 key는 to_string() 함수로 문자열로 변환하비다.
  콜론 구분자가 글자에 딱 붙지 않게 width + 1만큼 패딩을 주며, 이후 key를 Kernel.<> 함수로 뒤에 연결합니다.
  """
  def print_one_line({key, value}, width) do
    Atom.to_string(key)
    |> String.pad_trailing(width + 1)
    |> Kernel.<>(": ")
    |> Kernel.<>(value |> to_string)
    |> IO.puts()
  end
end
