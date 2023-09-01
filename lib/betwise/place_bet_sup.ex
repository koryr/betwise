defmodule Betwise.PlaceBetSup do
  @moduledoc false
  alias Betwise.Play
  alias Betwise.PlaceBet
  use Supervisor

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    children = [
      {PlaceBet, []},
      {Play, []}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

end
