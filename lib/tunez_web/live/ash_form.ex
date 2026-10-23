defmodule TunezWeb.Live.AshForm do
  @moduledoc """
  Shared `AshPhoenix.Form` validate/submit handling for LiveViews backed by a
  single `@form` assign.
  """

  import Phoenix.Component, only: [assign: 3, update: 3]
  import Phoenix.LiveView, only: [put_flash: 3, push_navigate: 2]

  def validate(socket, form_data) do
    update(socket, :form, &AshPhoenix.Form.validate(&1, form_data))
  end

  def save(socket, form_data,
        success_message: success_message,
        error_message: error_message,
        on_success: on_success
      ) do
    case AshPhoenix.Form.submit(socket.assigns.form, params: form_data) do
      {:ok, record} ->
        socket
        |> put_flash(:info, success_message)
        |> push_navigate(to: on_success.(record))

      {:error, form} ->
        socket
        |> put_flash(:error, error_message)
        |> assign(:form, form)
    end
  end
end
