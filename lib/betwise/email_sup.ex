defmodule Betwise.EmailSup do
  alias Betwise.EmailServer
  use Supervisor
  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(_opts) do
    children = [
      {EmailServer, []}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
