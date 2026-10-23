defmodule Tunez.Music.Duration do
  @moduledoc """
  Parses the `MM:SS` duration format used for track input.

  The inverse formatting (seconds -> `MM:SS`) is done in SQL by
  `Tunez.Music.Calculations.SecondsToMinutes` since it runs as part of a
  read query rather than a changeset - keep the two in sync if this format
  ever changes.
  """

  @format ~r/^\d+:\d{2}$/

  @spec parse(String.t()) :: {:ok, non_neg_integer()} | {:error, :format | :value}
  def parse(duration) do
    with :ok <- check_format(duration),
         :ok <- check_value(duration) do
      {:ok, to_seconds(duration)}
    end
  end

  defp check_format(duration) do
    if String.match?(duration, @format), do: :ok, else: {:error, :format}
  end

  defp check_value(v) when v in ["0:00", "00:00"], do: {:error, :value}
  defp check_value(_value), do: :ok

  defp to_seconds(duration) do
    [minutes, seconds] = String.split(duration, ":", parts: 2)
    String.to_integer(minutes) * 60 + String.to_integer(seconds)
  end
end
