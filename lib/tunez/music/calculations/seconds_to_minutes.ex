defmodule Tunez.Music.Calculations.SecondsToMinutes do
  @moduledoc """
  Formats `duration_seconds` as `MM:SS`. Keep in sync with the parser in
  `Tunez.Music.Duration`, which accepts that same format on input.
  """

  use Ash.Resource.Calculation

  @impl true
  def expression(_opts, _context) do
    expr(
      fragment("? / 60 || to_char(? * interval '1s', ':SS')", duration_seconds, duration_seconds)
    )
  end
end
