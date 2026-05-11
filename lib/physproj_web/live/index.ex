defmodule PhysprojWeb.QuantityLive.Index do
  use PhysprojWeb, :live_view
  alias Physproj.Quantities
  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        <div class="flex place-content-center mb-10"><p>Поиск величин</p></div>
        <.form for={@searchform} id="search-form" phx-submit="search" class="flex justify-between">
          <.input field={@searchform[:search]} name="search" class="input lg:w-140 md:w-100 w-50 rounded-xl focus:outline-black-500 focus:outline-offset-2 focus:outline-2 flex-auto" type="text" placeholder="Название величины" value=""/>
          <.button phx-disable-with="Ищем..." variant="primary">Найти</.button>
        </.form>
      </.header>
      <div class="sm:block hidden">
      <.table
        id="quantities"
        rows={@streams.quantities}
        row_click={fn {_id, quantity} -> JS.patch(~p"/quantities/#{quantity}") end}
      >
        <:col :let={{_id, quantity}} label="Название">{quantity.name}</:col>
        <:col :let={{_id, quantity}} label="Обозначение">{quantity.symbol}</:col>
        <:col :let={{_id, quantity}} label="Единица измерения (СИ)"><%= raw quantity.unit %></:col>
        <:col :let={{_id, quantity}} label="Раздел физики">{quantity.section}</:col>
      </.table>
      </div>
      <div class="sm:hidden flex">
      <div id="quantities-mobile" class="carousel carousel-vertical carousel-end rounded-box h-96 w-full">
          <div :for={{_id, quantity} <- @streams.quantities} class="carousel-item h-full card-border card">
            <div class="card-body">
              <div class="card-title flex justify-between">
                <h2>{quantity.name}</h2>
                <h2 class="badge badge-xl badge-outline badge-primary">{quantity.symbol}</h2>
              </div>
              <div class="divider divider-primary"></div>
              <div class="text-center items-center">
              <span class="badge badge-md badge-dash badge-primary mb-2">Формула</span>
              <p class="text-center"><%= raw quantity.formula %></p>
              <span class="badge badge-md badge-dash badge-primary  mt-2 mb-2">Единица измерения</span>
              <p class="text-center"><%= raw quantity.unit %></p>
              <div class="justify-center flex self-end items-end card-actions">
                <.button class="btn btn-primary absolute btn-outline self-end btn-sm bottom-15 mt-2" patch={~p"/quantities/#{quantity}"}>Подробнее</.button>
              </div>
              </div>
            </div>
          </div>
      </div>
    </div>
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

  @impl true
  def handle_event("search", %{"search" => search}, socket) do
    filtr = case search do
      "" -> list_quantities()
      " " -> list_quantities()
      "\n" -> list_quantities()
      _ -> Enum.filter(list_quantities(), fn quantity -> String.jaro_distance(search, quantity.name) > 0.75 end)
    end
    {:noreply, stream(socket, :quantities, filtr, reset: true)}
  end


  defp list_quantities() do
    Quantities.list()
  end
end
