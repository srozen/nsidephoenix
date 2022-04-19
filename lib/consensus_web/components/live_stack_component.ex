defmodule ConsensusWeb.LiveStackComponent do
  use ConsensusWeb, :live_component

  def render(assigns) do
    ~H"""
    <div>
      <button phx-click="pop" phx-target={@myself}>Pop</button><br>
      <form phx-submit="push" phx-target={@myself}>
        <%= text_input :stack, :element, value: "Push me" %>
        <%= submit "Push" %>
      </form>

      <div>
        <h1> Stack </h1>
        <%= for element <- @stack do %>
          <p><%= element %></p>
        <% end %>
      </div>
    </div>

    """
  end

  def update(_assigns, socket) do
    stack = LiveStack.status()
    {:ok, assign(socket, %{stack: stack})}
  end

  def handle_event("pop", _value, socket) do
    LiveStack.pop
    {:noreply, socket}
  end

  def handle_event("push", %{"stack" => %{"element" => element}} = _value, socket) do
    LiveStack.push(element)
    {:noreply, socket}
  end

  def mount(socket) do
    {:ok, socket}
  end
end
