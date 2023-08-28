defmodule BetwiseWeb.SportsLive.Games.FormComponent do
  use BetwiseWeb, :live_component

  alias Betwise.Games
  alias Betwise.Sports
  alias Betwise.Teams

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Add Game.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="game-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input
          field={@form[:sport_type_id]}
          type="select"
          label="Sport Type"
          options={Enum.map(@sportTypes, fn sportType -> {sportType.sport_name, sportType.id} end)}
        />
        <.input
          field={@form[:home_team_id]}
          type="select"
          label="Home Team"
          options={Enum.map(@teams, fn team -> {team.team_name, team.id} end)}
        />
        <.input
          field={@form[:away_team_id]}
          type="select"
          label="AwayTeam"
          options={Enum.map(@teams, fn team -> {team.team_name, team.id} end)}
        />
        <.input field={@form[:date_from]} type="date" label="Date from" />
        <.input field={@form[:time_from]} type="time" label="Time from" />
        <.input field={@form[:date_to]} type="date" label="Date to" />
        <.input field={@form[:time_to]} type="time" label="Time to" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Game</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{game: game} = assigns, socket) do
    changeset = Games.change_game(game)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)
     |> assign(:sportTypes, Sports.list_sport_type())
     |> assign(:teams, Teams.list_teams())}
  end

  @impl true
  def handle_event("validate", %{"game" => game_params}, socket) do
    changeset =
      socket.assigns.game
      |> Games.change_game(game_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"game" => game_params}, socket) do
    save_game(socket, socket.assigns.action, game_params)
  end

  defp save_game(socket, :edit, game_params) do
    case Games.update_game(socket.assigns.game, game_params) do
      {:ok, game} ->
        notify_parent({:saved, game})

        {:noreply,
         socket
         |> put_flash(:info, "Game updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_game(socket, :new, game_params) do
    case Games.create_game(game_params) do
      {:ok, game} ->
        notify_parent({:saved, game})

        {:noreply,
         socket
         |> put_flash(:info, "Game created successfully")
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
