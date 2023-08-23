defmodule BetwiseWeb.Sports.MarketLive.FormComponent do
  use BetwiseWeb, :live_component

  alias Betwise.Markets

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage market records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="market-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:odds]} type="text" label="Odds" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Market</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{market: market} = assigns, socket) do
    changeset = Markets.change_market(market)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"market" => market_params}, socket) do
    changeset =
      socket.assigns.market
      |> Markets.change_market(market_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"market" => market_params}, socket) do
    save_market(socket, socket.assigns.action, market_params)
  end

  defp save_market(socket, :edit, market_params) do
    case Markets.update_market(socket.assigns.market, market_params) do
      {:ok, market} ->
        notify_parent({:saved, market})

        {:noreply,
         socket
         |> put_flash(:info, "Market updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_market(socket, :new, market_params) do
    case Markets.create_market(market_params) do
      {:ok, market} ->
        notify_parent({:saved, market})

        {:noreply,
         socket
         |> put_flash(:info, "Market created successfully")
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
