defmodule Investr.User do
  use Ecto.Schema

  alias Investr.Stock

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
end
