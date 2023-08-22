# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Betwise.Repo.insert!(%Betwise.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Betwise.Accounts.{DefaultRoles, User}
alias Betwise.{Repo,Accounts}


# Seed roles

for role <- DefaultRoles.all() do
  unless Accounts.get_role_by_name(role.role_name) do
    {:ok, _role} = Accounts.create_role(role)
  end
end

# Seed Users

# Gets super user
role = Accounts.get_role_by_name("superuser")

attrs = %{
  "email" => "root@localhost",
  "first_name" => "Super",
  "last_name" => "Admin",
  "msisdn" => 123456789,
  "avatar" => "https://images.unsplash.com/photo-1550525811-e5869dd03032?ixlib=rb-1.2.1&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80",
  "password" => "secret",
  "role_id" => role.id
}

%User{}
|> User.registration_changeset(attrs)
|> Repo.insert!()
