require IEx;

defmodule Investr.StockData do
  alias Investr.Repo
  alias Investr.User
  alias Investr.Stock

  @alpha_base_url "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol"
  @api_key        "YIVAEBTWVXF52RDT"

  def closing_price(ticker) do
    ticker
    |> fetch_stock_data
    |> extract_data
    |> get_price
  end

  def previous_closing_price(ticker) do
    ticker
    |> fetch_stock_data
    |> extract_data
    |> get_price(previous_closing_date)
  end

  def daily_return_for(ticker) do
    String.to_float(closing_price(ticker)) - String.to_float(previous_closing_price(ticker))
  end

  def fetch_stock_data(ticker) do
    HTTPoison.get!("#{@alpha_base_url}=#{ticker}&outputsize=compact&apikey=#{@api_key}").body
    |> Poison.decode!
  end

  def extract_data(%{"Time Series (Daily)" => stock_data} = data), do: stock_data

  def get_price(data, date \\ Timex.local) do
    string_date = Timex.format!(date, "%F", :strftime)

    case Map.has_key?(data, string_date) do
      true ->
        IO.puts string_date
        %{^string_date => %{"4. close" => closing_date}} = data
        closing_date
      _ ->
        get_price(data, Timex.shift(date, days: -1))
    end
  end

  def previous_closing_date do
    Timex.shift(Timex.local, days: -1)
  end
end

