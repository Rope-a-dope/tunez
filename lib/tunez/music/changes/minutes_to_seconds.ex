defmodule Tunez.Music.Changes.MinutesToSeconds do
  use Ash.Resource.Change

  @impl true
  def change(changeset, _opts, _context) do
    {:ok, duration} = Ash.Changeset.fetch_argument(changeset, :duration)

    case Tunez.Music.Duration.parse(duration) do
      {:ok, seconds} ->
        Ash.Changeset.change_attribute(changeset, :duration_seconds, seconds)

      {:error, :format} ->
        Ash.Changeset.add_error(changeset,
          field: :duration,
          message: "use MM:SS format"
        )

      {:error, :value} ->
        Ash.Changeset.add_error(changeset,
          field: :duration,
          message: "must be at least 1 second long"
        )
    end
  end
end
