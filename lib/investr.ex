defmodule Investr do
  use Ecto.Schema

  schema "users" do
    field :email, :string
    field :name, :string
    field :password, :string

    timestamps()
  end
end
