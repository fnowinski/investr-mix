defmodule Investr.Stock do
  use Ecto.Schema

  alias Investr.User

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
end
