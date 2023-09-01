defmodule Betwise.PlayingSup do
  alias Betwise.Playing
  use DynamicSupervisor

  def start_link(opts \\ []) do
    DynamicSupervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(_opts) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_playing(game) do
    DynamicSupervisor.start_child(__MODULE__, {Playing, game})
  end

end
