defmodule BetwiseWeb.UserLive.SysUsers do
  use BetwiseWeb, :live_view

  alias Betwise.Accounts.User
  alias Betwise.Accounts

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:roles, Accounts.list_roles())

    {:ok, stream(socket, :users, Accounts.list_users())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    socket = socket |> assign(:roles, Accounts.list_roles())
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New User")
    |> assign(:user, %User{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Users")
    |> assign(:user, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    user = Accounts.get_user!(id)
    Accounts.soft_delete_record(user)

    {:noreply, stream_delete(socket, :users, user)}
  end
end
