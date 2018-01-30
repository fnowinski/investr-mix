defmodule Investr.Repo.Migrations.CreateStocks do
  use Ecto.Migration

  def change do
    create table(:stocks) do
      add :ticker, :string
      add :purchased_price, :string
      add :shares, :float
      add :user_id, references(:users), null: false

      timestamps()
    end

   create index("stocks", [:user_id])
  end
end
