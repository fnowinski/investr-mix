require IEx;

defmodule Investr.User do
  use Ecto.Schema
  import Ecto.Query

  alias Investr.Repo
  alias Investr.User
  alias Investr.Stock
  alias Investr.StockData

  schema "users" do
    field :email, :string
    field :name, :string
    field :password, :string
    has_many :stocks, Stock

    timestamps()
  end

  def changeset(user, params \\ %{}) do
    user
    |> Ecto.Changeset.cast(params, [:email, :name, :password])
    |> Ecto.Changeset.validate_required([:name])
  end

  def list_users do
    Repo.all(User)
  end

  def get_user!(id), do: Repo.get!(User, id, preload: :stocks)

  def get_by_name(name) do
    Repo.one(from user in User,
             where:   user.name == ^name,
             join:    stocks in assoc(user, :stocks),
             preload: [stocks: stocks])
  end

  def todays_return(name) do
    stocks = User.get_by_name(name).stocks

    stocks
    |> Enum.map(&(&1.ticker))
    |> Enum.join(",")
    |> StockData.batch_data
    |> calculate_return(stocks)
  end

  def calculate_return(stock_data, stocks) do
    Enum.reduce(stocks, 0.0, fn(stock, acc) ->
      daily_return = Map.fetch(stock_data, stock.ticker) |> calculate_daily_return
      acc + (daily_return * stock.shares)
    end)
  end

  def calculate_daily_return(stock_data) do
    { _, %{
      "quote" => %{
        "close"         => close,
        "previousClose" => previous_close
      }} = _ } = stock_data

    close - previous_close
  end
end
