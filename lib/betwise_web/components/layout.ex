defmodule BetwiseWeb.Layout do
  use Phoenix.Component

  slot(:sidebar)
  slot(:navbar)
  slot(:inner_block)

  def layout(assigns) do
    ~H"""
    <main>
      <div class="flex h-screen overflow-auto dark:bg-gray-900" x-data="{sidebarOpen: false}">
        <div class="relative z-40 lg:w-64">
          <div
            x-show="sidebarOpen"
            x-transition:enter="transition-opacity ease-linear duration-300"
            x-transition:enter-start="opacity-0"
            x-transition:enter-end="opacity-100"
            x-transition:leave="transition-opacity ease-linear duration-300"
            x-transition:leave-start="opacity-100"
            x-transition:leave-end="opacity-0"
            class="fixed inset-0 bg-gray-900/80"
            style="display: none;"
          >
          </div>
          <%= render_slot(@sidebar) %>
        </div>
        <div class="relative flex flex-col flex-1 pb-32 overflow-x-auto overflow-y-auto lg:pb-0">
          <%= render_slot(@navbar) %>
          <div class="pc-container pc-container--lg pc-container--mobile-padded my-8">
            <div class="mx-auto max-w-7xl pt-4 pb-4 px-4 sm:px-6 lg:px-8 min-h-[776px] overflow-hidden rounded-xl border border-dashed border-gray-400 dark:border-gray-600 opacity-75">
              <%= render_slot(@inner_block) %>
            </div>
          </div>
        </div>
      </div>
    </main>
    """
  end
end
