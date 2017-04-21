defmodule Spike.Task do
  use Spike.Web, :model

  schema "tasks" do
    field :title, :string, null: false
    field :duration, :integer
    field :complete, :boolean, default: false
    field :completed_at, Ecto.DateTime
    belongs_to :user, Spike.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :duration, :complete])
    |> validate_required([:title])
  end
end