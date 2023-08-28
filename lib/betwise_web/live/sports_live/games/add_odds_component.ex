defmodule BetwiseWeb.SportsLive.Games.AddOddsComponent do
  alias Betwise.BetTypes
  use BetwiseWeb, :live_component

  alias Betwise.Markets
  alias Betwise.BetTypes
  alias Betwise.Selections

  def mount(socket) do
    {:ok, assign(socket, :open, false)}
  end

  def render(assigns) do
    ~H"""
    <div>
      <button
        type="button"
        phx-target={@myself}
        phx-click="add-odds"
        class="focus:outline-none text-sm  rounded-full py-1.5 px-4 font-semibold  hover:bg-gray-800
      hover:text-white dark:bg-gray-700"
      >
        <span class="btn">Add Odds</span>
      </button>

      <div style={if @open, do: "display:block", else: "display:none"}>
        <.simple_form for={@form} phx-target={@myself} phx-submit="save-odds">
          <.input type="hidden" field={@form[:game_id]} value={@game_id} />
          <.input
            field={@form[:bet_type_id]}
            phx-target={@myself}
            type="select"
            prompt="Choose an option"
            options={Enum.map(@bet_types, fn type -> {type.bet_type_name, type.id} end)}
            phx-change="onchange-bet-type"
            label="Bet Type"
          />

          <div class="flex flex-row space-x-4">
            <%= Enum.map(@selections, fn selection -> %>
              <div class="basis-1/4 ">
                <label class="flex items-center gap-4 text-sm leading-6 text-zinc-600">
                  <%= selection.name %>
                </label>
                <input
                  class="mt-2 block w-full rounded-lg text-zinc-900 focus:ring-1 sm:text-sm sm:leading-6 "
                  type="number"
                  name={"market[odds][#{selection.id}]"}
                />
              </div>
            <% end) %>
          </div>
          <:actions>
            <.button phx-disable-with="Saving...">Save Odds</.button>
          </:actions>
        </.simple_form>
      </div>
    </div>
    """
  end

  def update(%{market: market, id: game_id} = assigns, socket) do
    changeset = Markets.change_market(market)
    bet_types = BetTypes.list_bet_types()

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:game_id, game_id)
     |> assign(:bet_types, bet_types)
     |> assign(:selections, [])
     |> assign(:form, to_form(changeset))}
  end

  def handle_event("add-odds", _params, socket) do
    {:noreply, assign(socket, :open, !socket.assigns.open)}
  end

  def handle_event(
        "onchange-bet-type",
        %{"market" => %{"bet_type_id" => bet_type_id}},
        socket
      ) do
    selection = Selections.get_selections_by_bet_type!(bet_type_id)

    {:noreply, socket |> assign(:selections, selection)}
  end

  def handle_event("save-odds", %{"market" => market}, socket) do
    user = socket.assigns.current_user

    market = market |> Map.put("user_id", user.id)

    socket =
      case Markets.create_market(market) do
        {:ok, market} ->
          notify_parent({:saved, market})

          socket
          |> put_flash(:info, "Odds Added successfully")

        {:error, error} ->
          IO.inspect("Odds no added#{inspect(error)}")

          socket
          |> put_flash(:error, "Odds not Added ")
          |> redirect(to: socket.view.module_url(socket, :index))

          socket
      end

    {:noreply, socket}
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
