defmodule ConsensusWeb.LiveChatComponent do
  use ConsensusWeb, :live_component
  alias Consensus.{Accounts, Message}

  def render(assigns) do
    ~H"""
    <div>
      <h1> Messages </h1>
      <%= for message <- @messages do %>
        <p><%= message.body %></p>
      <% end %>

      <.form let={f} for={@changeset} phx-submit="save" phx-target={@myself}>
        <%= label f, :body %>
        <%= text_input f, :body %>
        <%= error_tag f, :body %>

        <%= submit "Send" %>
      </.form>
    </div>
    """
  end

  def update(assigns, socket) do
    user_id = Accounts.get_user_by_session_token(assigns.user_token).id
    messages = Message.get_all()
    {:ok, assign(socket, %{messages: messages, user_id: user_id, changeset: Message.changeset(%Message{}, %{})})}
  end

  def mount(socket) do
    {:ok, socket}
  end

  def handle_event("save", %{"message" => message_params}, socket) do
    case Message.create_message(Map.put(message_params, "user_id", socket.assigns.user_id)) do
      {:ok, _message} ->
        flash_parent(:info, "Message sent")
        {:noreply, socket}
      {:error, %Ecto.Changeset{} = changeset} ->
        flash_parent(:error, "Invalid message")
        {
          :noreply,
          socket
          |> assign(changeset: changeset)
        }
    end
  end

  defp flash_parent(severity, message) do
    send self(), {:flash, {severity, message}}
  end
end
