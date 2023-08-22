defmodule Betwise.Accounts.Role do
  use Ecto.Schema
  import Ecto.Changeset

  schema "roles" do
    field :role_display_name, :string
    field :role_name, :string
    field :description, :string
    field :permissions, :map

    has_many(:users, Betwise.Accounts.User)

    timestamps()
  end

  @doc false
  def changeset(role, attrs) do
    role
    |> cast(attrs, [:role_display_name, :role_name, :description, :permissions])
    |> validate_required([:role_display_name, :role_name, :permissions])
    |> unique_constraint(:role_name)
    |> unique_constraint(:role_display_name)
  end
end
