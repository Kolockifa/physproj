defmodule PhysprojWeb.QuantityLive.Show do
  use PhysprojWeb, :live_view
  alias Physproj.Quantities
  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@quantity.name}
        <:subtitle>{@quantity.section}</:subtitle>
        <:actions>
          <.button navigate={~p"/"}>
            <.icon name="hero-arrow-left" /> Вернуться к каталогу
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Формула"><%= raw @quantity.formula %></:item>
        <:item title="Определение">{@quantity.descr}</:item>
        <:item title="Единица измерения"><%= raw @quantity.unit %></:item>
        <:item title="">✓ {@quantity.vector}</:item>
      </.list>

    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Quantity")
     |> assign(:quantity, Quantities.get(id))}
  end
end
