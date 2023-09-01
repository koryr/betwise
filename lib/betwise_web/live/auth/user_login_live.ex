defmodule BetwiseWeb.Auth.UserLoginLive do
  use BetwiseWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="mx-auto mt-20 p-10 max-w-7xl bg-white">
      <div class="flex min-h-full flex-col justify-center px-6 py-12 lg:px-8">
        <div class="sm:mx-auto sm:w-full sm:max-w-sm ">
          <img
            class="mx-auto h-10 w-auto"
            src="https://tailwindui.com/img/logos/mark.svg?color=indigo&shade=600"
            alt="Your Company"
          />
          <.header class="text-center">
            <h2 class="mt-10 text-center text-2xl font-bold leading-9 tracking-tight text-gray-900">
              Sign in to your account
            </h2>
            <:subtitle>
              Don't have an account?
              <.link
                navigate={~p"/auth/users/register"}
                class="font-semibold text-brand hover:underline"
              >
                Sign up
              </.link>
              for an account now.
            </:subtitle>
          </.header>
        </div>

        <div class="mt-10 sm:mx-auto sm:w-full sm:max-w-sm">
          <.simple_form
            for={@form}
            id="login_form"
            action={~p"/auth/users/log_in"}
            phx-update="ignore"
          >
            <.input field={@form[:email]} type="email" label="Email" required />
            <.input field={@form[:password]} type="password" label="Password" required />

            <:actions>
              <.input field={@form[:remember_me]} type="checkbox" label="Keep me logged in" />
              <.link href={~p"/auth/users/reset_password"} class="text-sm font-semibold">
                Forgot your password?
              </.link>
            </:actions>
            <:actions>
              <.button phx-disable-with="Signing in..." class="w-full">
                Sign in <span aria-hidden="true">→</span>
              </.button>
            </:actions>
          </.simple_form>
        </div>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    email = live_flash(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form], layout: false}
  end
end
