defmodule BetwiseWeb.UserLive.FormComponent do
  use BetwiseWeb, :live_component
  alias Betwise.Accounts.User
  alias Betwise.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Add Users.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="user-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:first_name]} type="text" label="First Name" />
        <.input field={@form[:last_name]} type="text" label="Last Name" />
        <.input field={@form[:msisdn]} type="text" label="Phone Number" />
        <.input field={@form[:email]} type="email" label="Email" />
        <.input
          field={@form[:role_id]}
          type="select"
          label="Role"
          options={Enum.map(@roles, fn role -> {role.role_display_name, role.id} end)}
        />
        <:actions>
          <.button phx-disable-with="Saving...">Save User</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{user: user} = assigns, socket) do
    changeset = Accounts.change_user_registration(user)

    {:ok,
     socket
     |> assign(:roles, Accounts.list_roles())
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("save", %{"user" => user_params}, socket) do

    save_user(socket, socket.assigns.action, user_params)
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_registration(%User{}, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp save_user(socket, :edit, user_params) do

    case Accounts.update_user(socket.assigns.user, user_params) do
      {:ok, user} ->
        notify_parent({:saved, user})
        IO.inspect(user)
        {:noreply,
         socket
         |> put_flash(:info, "User updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    end
  end

  defp save_user(socket, :new, user_params) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        notify_parent({:saved, user})

        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &url(~p"/auth/users/confirm/#{&1}")
          )

        changeset = Accounts.change_user_registration(user)

        {:noreply,
         socket
         |> assign(trigger_submit: true)
         |> assign_form(changeset)
         |> put_flash(:info, "User saved successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
