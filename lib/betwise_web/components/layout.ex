defmodule BetwiseWeb.Layout do
  use Phoenix.Component

  slot(:sidebar)
  slot(:navbar)
  slot(:inner_block)

  def layout(assigns) do
    ~H"""
    <%= render_slot(@navbar) %>
    """
  end
end
