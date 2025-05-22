defmodule Weather.CLI do
  @default_airport "KABQ"

  def main(_) do
    @default_airport
    |> process
  end

  def process(airport) do
    Weather.WeatherService.fetch(airport)
    |> decode_response()
    |> print_pretty()
  end

  def decode_response({:ok, map}) do
    map
  end

  def decode_response({:error, error}) do
    IO.puts("Error fetching from weather.gov: #{error["message"]}")
    exit(2)
  end

  def print_pretty(map) do
    header_width =
      Map.keys(map) |> Enum.map(&Atom.to_string/1) |> Enum.map(&String.length/1) |> Enum.max()

    IO.puts("======================= Weather Station ========================")
    Enum.each(map, &print_one_line(&1, header_width))
    IO.puts("================================================================")
  end

  def print_one_line({key, value}, width) do
    Atom.to_string(key)
    |> String.pad_trailing(width + 1)
    |> Kernel.<>(": ")
    |> Kernel.<>(value |> to_string)
    |> IO.puts()
  end
end
