require IEx;

defmodule Investr.StockData do
  @base_url       "https://api.iextrading.com/1.0/stock/"
  @batch_base_url "https://api.iextrading.com/1.0/stock/market/batch?symbols="

  def batch_data(tickers) do
    HTTPoison.get!("#{@batch_base_url}#{tickers}&types=quote").body
    |> Poison.decode!
  end

  def todays_return_for(ticker) do
    ticker
    |> fetch_stock_data
    |> calculate_return
  end

  def calculate_return(data) do
    %{
      "previousClose" => previous_close,
      "close" => close
    } = data
    (close - previous_close)
  end

  def fetch_stock_data(ticker) do
    HTTPoison.get!("#{@base_url}/#{ticker}/quote").body
    |> Poison.decode!
  end

  def closing_price(ticker) do
    %{ "close" => close } = ticker |> fetch_stock_data
    close
  end

  def previous_closing_price(ticker) do
    %{ "previousClose" => prev_close } = ticker |> fetch_stock_data
    prev_close
  end
end
