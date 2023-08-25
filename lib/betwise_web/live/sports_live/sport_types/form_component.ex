defmodule BetwiseWeb.SportsLive.SportTypes.FormComponent do
  use BetwiseWeb, :live_component

  alias Betwise.Sports

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage sport_type records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="sport_type-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:sport_name]} type="text" label="Sport name" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Sport type</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{sport_type: sport_type} = assigns, socket) do
    changeset = Sports.change_sport_type(sport_type)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"sport_type" => sport_type_params}, socket) do
    changeset =
      socket.assigns.sport_type
      |> Sports.change_sport_type(sport_type_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"sport_type" => sport_type_params}, socket) do
    save_sport_type(socket, socket.assigns.action, sport_type_params)
  end

  defp save_sport_type(socket, :edit, sport_type_params) do
    case Sports.update_sport_type(socket.assigns.sport_type, sport_type_params) do
      {:ok, sport_type} ->
        notify_parent({:saved, sport_type})

        {:noreply,
         socket
         |> put_flash(:info, "Sport type updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_sport_type(socket, :new, sport_type_params) do
    case Sports.create_sport_type(sport_type_params) do
      {:ok, sport_type} ->
        notify_parent({:saved, sport_type})

        {:noreply,
         socket
         |> put_flash(:info, "Sport type created successfully")
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
