defmodule BetwiseWeb.Navbar do
  use BetwiseWeb, :live_component

  attr(:menu_items, :list, default: [])

  def render(assigns) do
    ~H"""
    <div>
      <header class="px-4 sm:px-6 lg:px-8">
        <div class="flex items-center justify-between border-b border-zinc-100 py-3 text-sm">
          <div class="flex items-center gap-4">
            <a href="/">
              <img src={~p"/images/logo.svg"} width="36" />
            </a>
            <p class="bg-brand/5 text-brand rounded-full px-2 font-medium leading-6">
              v<%= Application.spec(:phoenix, :vsn) %>
            </p>
          </div>
          <div class="flex items-center gap-4 font-semibold leading-6 text-zinc-900">
            <a href="https://twitter.com/elixirphoenix" class="hover:text-zinc-700">
              @elixirphoenix
            </a>
            <a href="https://github.com/phoenixframework/phoenix" class="hover:text-zinc-700">
              GitHub
            </a>
            <a
              href="https://hexdocs.pm/phoenix/overview.html"
              class="rounded-lg bg-zinc-100 px-2 py-1 hover:bg-zinc-200/80"
            >
              Get Started <span aria-hidden="true">&rarr;</span>
            </a>
            <%!-- Profile dropdownmenu --%>
            <div x-data="{ isOpen: false }" class="relative ml-3">
              <button type="button" @click="isOpen = !isOpen">
                <img
                  class="h-8 w-8 rounded-full"
                  src="https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80"
                  alt=""
                />
              </button>
            </div>
          </div>
        </div>
      </header>
    </div>
    """
  end
end
