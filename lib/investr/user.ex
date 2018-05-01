defmodule Investr.User do
  use Ecto.Schema
  import Ecto.Query

  alias Investr.Repo
  alias Investr.User
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
end
