defmodule BetwiseWeb.Navbar do
  use BetwiseWeb, :live_component

  attr(:menu_items, :list, default: [])

  def render(assigns) do
    ~H"""
    <div class="sticky top-0 px-4 sm:px-6 lg:px-8 bg-white border-gray-200 dark:bg-gray-800">
      <header class="px-4 sm:px-6 lg:px-8">
        <div class="flex items-center justify-between border-b border-zinc-100 py-3 text-sm">
          <div class="flex items-center gap-4"></div>
          <div class="flex items-center gap-4 font-semibold leading-6 text-zinc-900">

          <button type="button" class="relative rounded-full  p-1 text-gray-400 hover:text-gray focus:outline-none focus:ring-2 focus:ring-white focus:ring-offset-2 focus:ring-offset-gray-800">
              <span class="absolute -inset-1.5"></span>
              <span class="sr-only">View notifications</span>
              <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" aria-hidden="true">
                <path stroke-linecap="round" stroke-linejoin="round" d="M14.857 17.082a23.848 23.848 0 005.454-1.31A8.967 8.967 0 0118 9.75v-.7V9A6 6 0 006 9v.75a8.967 8.967 0 01-2.312 6.022c1.733.64 3.56 1.085 5.455 1.31m5.714 0a24.255 24.255 0 01-5.714 0m5.714 0a3 3 0 11-5.714 0" />
              </svg>
            </button>
            <%!-- Profile dropdownmenu --%>
            <%= if @current_user do %>
              <%= @current_user.email %>
            <% end %>
            <div x-data="{ isOpen: false }" class="relative ml-3">
              <button
                type="button"
                @click="isOpen = !isOpen"
                @keydown.escape.window="isOpen = false"
                @click.away="isOpen = false"
              >
                <img
                  class="h-8 w-8 rounded-full"
                  src={if @current_user.avatar == nil do  "/images/profile.png" else @current_user.avatar end}
                  alt=""
                />
              </button>
              <div x-show="isOpen">
                <div
                  class="absolute right-0 z-40 mt-2 w-48 origin-top-right rounded-md bg-white py-1 shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none dark:bg-gray-800"
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
