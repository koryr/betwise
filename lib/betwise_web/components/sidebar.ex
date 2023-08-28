defmodule BetwiseWeb.Sidebar do
  use BetwiseWeb, :live_component

  attr(:menu_items, :list, default: [])

  def render(assigns) do
    ~H"""
    <div class="absolute top-0 left-0 z-40 flex-shrink-0 w-64 h-screen p-4 overflow-y-auto transition-transform duration-200 ease-in-out transform border-r lg:static lg:left-auto lg:top-auto lg:translate-x-0 lg:overflow-y-auto no-scrollbar bg-white dark:bg-gray-900 border-gray-200 dark:border-gray-700 -translate-x-64">
      <div class="flex justify-between pr-3 mb-10 sm:px-2">
        <button class="text-gray-500  hover:text-gray-400" aria-controls="sidebar">
          <a href="/" data-phx-link="redirect" data-phx-link-state="push" class="block">
            <img
              class="h-8 transition-transform duration-300 ease-out transform hover:scale-105 block dark:hidden"
              src={~p"/images/logo.svg"}
            />
            <img
              class="h-8 transition-transform duration-300 ease-out transform hover:scale-105 hidden dark:block"
              src={~p"/images/logo.svg"}
            />
            <p class="bg-brand/5 text-brand rounded-full px-2 font-medium leading-6">
              v<%= Application.spec(:phoenix, :vsn) %>
            </p>
          </a>
        </button>
        </div>
        <div class="flex flex-col gap-5">
          <nav>
            <div class="divide-y divide-gray-300">
              <div class="space-y-1">
                <%= for link <- Enum.filter(@menu_items, & !is_nil(&1)) do %>
                  <%= unless Map.has_key?(link, :menu_items) do %>
                    <.link navigate={link.path} class="flex items-center text-sm font-semibold leading-none px-3 py-2 gap-3 transition duration-200 w-full rounded-md group
                                        text-gray-700 hover:bg-gray-50 dark:text-gray-200 hover:text-gray-900 dark:hover:text-white dark:hover:bg-gray-700 ">
                      <.icon name={link.icon} class="w-5 h-5 text-gray-700 dark:text-gray-300" />
                      <%= link.label %>
                    </.link>
                  <% end %>
                <% end %>
              </div>
            </div>
          </nav>

      </div>
    </div>
    """
  end
end
