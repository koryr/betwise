defmodule BetwiseWeb.Navbar do
  use BetwiseWeb, :live_component

  attr(:menu_items, :list, default: [])

  def render(assigns) do
    ~H"""
    <div>
      <header class="px-4 sm:px-6 lg:px-8">
        <div class="flex items-center justify-between border-b border-zinc-100 py-3 text-sm">
          <div class="flex items-center gap-4"></div>
          <div class="flex items-center gap-4 font-semibold leading-6 text-zinc-900">

            <a
              href="https://hexdocs.pm/phoenix/overview.html"
              class="rounded-lg bg-zinc-100 px-2 py-1 hover:bg-zinc-200/80"
            >
              Get Started <span aria-hidden="true">&rarr;</span>
            </a>
            <%!-- Profile dropdownmenu --%>
            <%= if @current_user do %>
                <%= @current_user.email %>
              <% end %>
            <div x-data="{ isOpen: false }" class="relative ml-3">

              <button type="button" @click="isOpen = !isOpen">

                <img
                  class="h-8 w-8 rounded-full"
                  src="https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80"
                  alt=""
                />
              </button>
              <div x-show="isOpen">
                <div
                  class="absolute right-0 z-10 mt-2 w-48 origin-top-right rounded-md bg-white py-1 shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none dark:bg-gray-800"
                  role="menu"
                  aria-orientation="vertical"
                >
                  <%= for link <- @menu_items do %>
                    <.link
                      href={link.path}
                      method={
                        if Map.has_key?(link, :method) do
                          link.method
                        end
                      }
                      role="menuitem"
                      class="block px-4 py-2 text-sm text-gray-700  hover:bg-zinc-100 dark:hover:bg-zinc-700 dark:text-white"
                    >
                      <.icon name={link.icon} class="w-5 h-5 text-gray-700 dark:text-white " />
                      <%= link.label %>
                    </.link>
                  <% end %>
                </div>
              </div>
            </div>
          </div>
        </div>
      </header>
    </div>
    """
  end
end
