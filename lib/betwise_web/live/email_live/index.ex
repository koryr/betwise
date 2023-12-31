defmodule BetwiseWeb.EmailLive.Index do
  use BetwiseWeb, :live_view

  alias Betwise.Emails
  alias Betwise.Emails.Email

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :emails, Emails.list_emails())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Email")
    |> assign(:email, Emails.get_email!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Email")
    |> assign(:email, %Email{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Emails")
    |> assign(:email, nil)
  end

  @impl true
  def handle_info({BetwiseWeb.EmailLive.FormComponent, {:saved, email}}, socket) do
    {:noreply, stream_insert(socket, :emails, email)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    email = Emails.get_email!(id)
    {:ok, _} = Emails.delete_email(email)

    {:noreply, stream_delete(socket, :emails, email)}
  end
end
