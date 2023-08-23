defmodule BetwiseWeb.Sports.SelectionLive.FormComponent do
  use BetwiseWeb, :live_component

  alias Betwise.Selections

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage selection records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="selection-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Selection</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{selection: selection} = assigns, socket) do
    changeset = Selections.change_selection(selection)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"selection" => selection_params}, socket) do
    changeset =
      socket.assigns.selection
      |> Selections.change_selection(selection_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"selection" => selection_params}, socket) do
    save_selection(socket, socket.assigns.action, selection_params)
  end

  defp save_selection(socket, :edit, selection_params) do
    case Selections.update_selection(socket.assigns.selection, selection_params) do
      {:ok, selection} ->
        notify_parent({:saved, selection})

        {:noreply,
         socket
         |> put_flash(:info, "Selection updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_selection(socket, :new, selection_params) do
    case Selections.create_selection(selection_params) do
      {:ok, selection} ->
        notify_parent({:saved, selection})

        {:noreply,
         socket
         |> put_flash(:info, "Selection created successfully")
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
