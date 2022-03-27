defmodule ConsensusWeb.ChatLiveView do
  use ConsensusWeb, :live_view
  alias Consensus.{Accounts, Message}

  def render(assigns) do
    ~H"""
    <.form let={f} for={@changeset} phx-submit="save">
      <%= label f, :body %>
      <%= text_input f, :body %>
      <%= error_tag f, :body %>

      <%= submit "Send" %>
    </.form>
    <h1> Messages </h1>
    <%= for message <- @messages do %>
      <p><%= message.body %></p>
    <% end %>
    """
  end

  def mount(_params, %{"user_token" => user_token}, socket) do
    user_id = Accounts.get_user_by_session_token(user_token).id
    Phoenix.PubSub.subscribe Consensus.PubSub, "messages"
    messages = Message.get_all()
    {:ok, assign(socket, %{messages: messages, user_id: user_id, changeset: Message.changeset(%Message{}, %{})})}
  end

  def handle_event("save", %{"message" => message_params}, socket) do
    case Message.create_message(Map.put(message_params, "user_id", socket.assigns.user_id)) do
      {:ok, _message} ->
        {:noreply, put_flash(socket, :info, "Message sent")}
      {:error, %Ecto.Changeset{} = changeset} ->
        {
          :noreply,
          socket
          |> put_flash(:error, "Invalid message")
          |> assign(changeset: changeset)
        }
    end
  end

  # PubSub Events
  def handle_info(:new_message, socket) do
    messages = Message.get_all()
    {:noreply, assign(socket, :messages, messages)}
  end
end
