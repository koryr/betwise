defmodule Betwise.EmailServer do
  alias Betwise.Mailer
  alias Betwise.Emails
  use GenServer
  import Swoosh.Email

  def start_link([]) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def send(email) do
    GenServer.cast(__MODULE__, {:send, email})
  end

  @impl true
  def init(:ok) do
    Process.send_after(self(), :check_mail, 20_000)
    {:ok, %{}}
  end

  @impl true
  def handle_call(_msg, _from, state) do
    {:reply, [], state}
  end

  @impl true
  def handle_cast({:send, email}, state) do
    emails =
      new()
      |> to({email.email_from, email.recipient})
      |> from({email.email_from, email.email_from})
      |> subject(email.subject)
      |> html_body("<h1>Hello #{email.recipient}</h1>")
      |> text_body("#{email.content}\n")

    emails
    |> Mailer.deliver()
    |> case do
      {:ok, _id} ->
        Emails.update_email(email, %{send: true})

      {:error, error} ->
        IO.inspect("error#{inspect(error)}")
    end

    {:noreply, state}
  end

  @impl true
  def handle_info(:check_mail, state) do
    Enum.map(Emails.get_emails(), fn email ->
      email
      |> send()
    end)

    Process.send_after(self(), :check_mail, 20_000)
    {:noreply, state}
  end
end
