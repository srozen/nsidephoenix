defmodule ConsensusWeb.ChatLiveView do
  use ConsensusWeb, :live_view
  alias Consensus.Message

  def render(assigns) do
    ~H"""
    <h1> Messages </h1>
    <%= for message <- @messages do %>
      <p><%= message.body %></p>
    <% end %>
    """
  end

  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe Consensus.PubSub, "messages"
    messages = Message.get_all()
    {:ok, assign(socket, :messages, messages)}
  end

  def handle_info(:new_message, socket) do
    messages = Message.get_all()
    {:noreply, assign(socket, :messages, messages)}
  end
end
