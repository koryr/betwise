defmodule BetwiseWeb.SportsLive.BetTypes.FormComponent do
  use BetwiseWeb, :live_component

  alias Betwise.BetTypes

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage bet_type records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="bet_type-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:bet_type_name]} type="text" label="Bet type name" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Bet type</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{bet_type: bet_type} = assigns, socket) do
    changeset = BetTypes.change_bet_type(bet_type)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"bet_type" => bet_type_params}, socket) do
    changeset =
      socket.assigns.bet_type
      |> BetTypes.change_bet_type(bet_type_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"bet_type" => bet_type_params}, socket) do
    save_bet_type(socket, socket.assigns.action, bet_type_params)
  end

  defp save_bet_type(socket, :edit, bet_type_params) do
    case BetTypes.update_bet_type(socket.assigns.bet_type, bet_type_params) do
      {:ok, bet_type} ->
        notify_parent({:saved, bet_type})

        {:noreply,
         socket
         |> put_flash(:info, "Bet type updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_bet_type(socket, :new, bet_type_params) do
    case BetTypes.create_bet_type(bet_type_params) do
      {:ok, bet_type} ->
        notify_parent({:saved, bet_type})

        {:noreply,
         socket
         |> put_flash(:info, "Bet type created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
