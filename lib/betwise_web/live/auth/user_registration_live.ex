defmodule BetwiseWeb.Auth.UserRegistrationLive do
  use BetwiseWeb, :live_view

  alias Betwise.Accounts
  alias Betwise.Accounts.User

  def render(assigns) do
    ~H"""
    <div class="mx-auto mt-20 p-10 max-w-7xl bg-white">
    <div class="mx-auto max-w-sm ">
      <.header class="text-center">
        Register for an account
        <:subtitle>
          Already registered?
          <.link navigate={~p"/auth/users/log_in"} class="font-semibold text-brand hover:underline">
            Sign in
          </.link>
          to your account now.
        </:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="registration_form"
        phx-submit="save"
        phx-change="validate"
        phx-trigger-action={@trigger_submit}
        action={~p"/auth/users/log_in?_action=registered"}
        method="post"
      >
        <.error :if={@check_errors}>
          Oops, something went wrong! Please check the errors below.
        </.error>
        <.input field={@form[:first_name]} type="text" label="First Name" />
        <.input field={@form[:last_name]} type="text" label="Last Name" />
        <.input field={@form[:msisdn]} type="text" label="Phone Number" />
        <.input field={@form[:email]} type="email" label="Email" required />

        <.input field={@form[:password]} type="password" label="Password" required />

        <:actions>
          <.button phx-disable-with="Creating account..." class="w-full">Create an account</.button>
        </:actions>
      </.simple_form>
    </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_registration(%User{})

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil], layout: false}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    IO.inspect(Map.has_key?(user_params, "role_id"))

    params =
      case Map.has_key?(user_params, "role_id") do
        false ->
          case Accounts.get_role_by_name("user") do
            role ->
              Map.put(user_params, "role_id", role.id)
          end

        true ->
          user_params
      end

    case Accounts.register_user(params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &url(~p"/auth/users/confirm/#{&1}")
          )

        changeset = Accounts.change_user_registration(user)
        {:noreply, socket |> assign(trigger_submit: true) |> assign_form(changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    end

  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_registration(%User{}, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
end
