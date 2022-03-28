defmodule ConsensusWeb.ChatLiveView do
  use ConsensusWeb, :live_view
  alias ConsensusWeb.LiveChatComponent

  def render(assigns) do
    ~H"""
    <.live_component module={LiveChatComponent} id="hero" user_token={@user_token} />
    """
  end

  def mount(_params, %{"user_token" => user_token}, socket) do
    Phoenix.PubSub.subscribe Consensus.PubSub, "messages"
    {:ok, assign(socket, %{user_token: user_token})}
  end

  # PubSub Events
  def handle_info(:new_message, socket) do
    send_update LiveChatComponent, id: "hero", user_token: socket.assigns.user_token
    {:noreply, socket}
  end

  def handle_info({:flash, {severity, message}}, socket) do
    {:noreply, put_flash(socket, severity, message)}
  end
end
