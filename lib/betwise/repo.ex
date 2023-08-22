defmodule Betwise.Repo do
  use Ecto.Repo,
    otp_app: :betwise,
    adapter: Ecto.Adapters.Postgres
end
