require IEx;

defmodule Investr.Stock do
  use Ecto.Schema

  alias Investr.Repo
  alias Investr.User
  alias Investr.Stock
  alias Investr.StockData

  schema "stocks" do
    field :ticker, :string
    field :purchased_price, :string
    field :shares, :float
    belongs_to :user, User

    timestamps()
  end

  def changeset(stock, params \\ %{}) do
    stock
    |> Ecto.Changeset.cast(params, [:ticker, :purchased_price, :shares])
    |> Ecto.Changeset.validate_required([:ticker, :purchased_price, :shares])
  end

  def add_stock(ticker, shares, purchased_price, user_id) do
    changeset = %Stock{ticker: ticker, shares: shares, user_id: user_id, purchased_price: purchased_price}

    case Repo.insert(changeset) do
      {:ok, stock} ->
        stock
      {:error, changeset} ->
        IEx.pry
    end
  end
end
