defmodule Consensus.Message do
  use Ecto.Schema
  import Ecto.Changeset
  alias Consensus.{Repo, Message}

  schema "messages" do
    field :body, :string
    belongs_to :user, Consensus.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:user_id, :body])
    |> validate_required([:user_id, :body])
  end

  @doc """
  Gets all messages.
  """
  def get_all do
    Repo.all(Message)
  end

  ## User registration

  @doc """
  Creates a message.

  ## Examples

      iex> create_message(%{field: value})
      {:ok, %Message{}}

      iex> create_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_message(attrs) do
    msg = %Message{}
    |> changeset(attrs)
    |> Repo.insert()

    case msg do
      {:ok, %Message{}} ->
        Phoenix.PubSub.broadcast Consensus.PubSub, "messages", :new_message
        {:ok, %Message{}}
      {:error, %Ecto.Changeset{}} ->
        {:error, %Ecto.Changeset{}}
    end
  end
end
