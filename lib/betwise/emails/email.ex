defmodule Betwise.Emails.Email do
  use Ecto.Schema
  import Ecto.Changeset

  schema "emails" do
    field :content, :string
    field :email_from, :string
    field :recipient, :string
    field :subject, :string
    field :send, :boolean, default: false
    belongs_to(:user, Betwise.Accounts.User)

    timestamps()
  end

  @doc false
  def changeset(email, attrs) do
    email
    |> cast(attrs, [:email_from, :recipient, :subject, :content, :user_id, :send])
    |> validate_required([:email_from, :recipient, :subject, :content])
  end
end
