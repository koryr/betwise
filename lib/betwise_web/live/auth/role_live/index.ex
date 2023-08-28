defmodule BetwiseWeb.Auth.RoleLive.Index do
  alias Betwise.Accounts.Permissions
  use BetwiseWeb, :live_view

  alias Betwise.Accounts
  alias Betwise.Accounts.Role

  @impl true
  def mount(_params, _session, socket) do
    required_permission = {"roles", ["read"]}


    # IO.inspect("permssion#{inspect(required_permission(:index))}")

    # if Permissions.user_has_permission?(user, required_permission) do
    #   IO.inspect("permssion")
    # end

    # if Permissions.user_has_permission?(user, required_permission) do
    #   socket
    # else
    #   socket
    #   |> put_status(:forbidden)
    #   |> halt()
    # end

    {:ok, stream(socket, :roles, Accounts.list_roles())}
  end

  @impl true

  def handle_params(params, _url, socket) do
    user = socket.assigns.current_user
    IO.inspect("user#{inspect(user)}")
    socket = if Permissions.user_has_permission?(user, required_permission(socket.assigns.live_action)) do
      socket
    else
      socket
      |> put_flash(:error, "Could not find the user")
      |> push_patch(to: socket.assigns.patch)

      # {:halt, socket |> put_flash(:error, "Could not find the user")}
    end

    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Role")
    |> assign(:role, Accounts.get_role!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Role")
    |> assign(:role, %Role{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Roles")
    |> assign(:role, nil)
  end

  @impl true
  def handle_info({BetwiseWeb.Auth.RoleLive.FormComponent, {:saved, role}}, socket) do
    {:noreply, stream_insert(socket, :roles, role)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    role = Accounts.get_role!(id)
    {:ok, _} = Accounts.delete_role(role)

    {:noreply, stream_delete(socket, :roles, role)}
  end

  defp required_permission(action) do
    list = [
      index: {"roles", "read"},
      show: {"roles", "read"},
      delete: {"roles", "delete"}
    ]

    result = Enum.find(list, fn {key, _value} -> key == action end)

    case result do
      {_key, value} ->
        value

      nil ->
        IO.puts("Permission not found")
    end
  end
end
