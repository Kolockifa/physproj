defmodule PhysprojWeb.QuantityLive.Index do
  use PhysprojWeb, :live_view
  alias Physproj.Quantities
  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        <.form for={@searchform} id="search-form" phx-submit="search">
          <p><.input field={@searchform[:search]} name="search" type="text" label="Поиск величин" value=""/>
          <.button phx-disable-with="Ищем..." variant="primary">Найти</.button></p>
        </.form>
      </.header>

      <.table
        id="quantities"
        rows={@streams.quantities}
        row_click={fn {_id, quantity} -> JS.navigate(~p"/quantities/#{quantity}") end}
      >
        <:col :let={{_id, quantity}} label="Название">{quantity.name}</:col>
        <:col :let={{_id, quantity}} label="Обозначение">{quantity.symbol}</:col>
        <:col :let={{_id, quantity}} label="Единица измерения (СИ)"><%= raw quantity.unit %></:col>
        <:col :let={{_id, quantity}} label="Раздел физики">{quantity.section}</:col>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Listing Quantities")
     |> assign(:searchform, %{"search" => ""})
     |> stream(:quantities, list_quantities())}
  end

  def handle_event("search", %{"search" => search}, socket) do
    filtr = case search do
      "" -> list_quantities()
      _ -> Enum.filter(list_quantities(), fn quantity -> String.jaro_distance(search, quantity.name) > 0.6 end)
    end
    {:noreply, stream(socket, :quantities, filtr, reset: true)}
  end


  defp list_quantities() do
    Quantities.list()
  end
end
