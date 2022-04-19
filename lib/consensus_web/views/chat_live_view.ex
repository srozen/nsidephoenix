defmodule ConsensusWeb.ChatLiveView do
  use ConsensusWeb, :live_view
  alias ConsensusWeb.LiveChatComponent
  alias ConsensusWeb.LiveStackComponent

  def render(assigns) do
    ~H"""
    <section class="livechat">
      <.live_component module={LiveStackComponent} id="livestack" />
      <.live_component module={LiveChatComponent} id="hero" user_token={@user_token} />
    </section>
    """
  end

  def mount(_params, %{"user_token" => user_token}, socket) do
    Phoenix.PubSub.subscribe Consensus.PubSub, "messages"
    Phoenix.PubSub.subscribe Consensus.PubSub, "live_stack"
    {:ok, assign(socket, %{user_token: user_token})}
  end

  # PubSub Events
  def handle_info(:new_message, socket) do
    send_update LiveChatComponent, id: "hero", user_token: socket.assigns.user_token
    {:noreply, socket}
  end

  def handle_info(:stack_updated, socket) do
    send_update LiveStackComponent, id: "livestack"
    {:noreply, socket}
  end

  def handle_info({:flash, {severity, message}}, socket) do
    {:noreply, put_flash(socket, severity, message)}
  end
end
