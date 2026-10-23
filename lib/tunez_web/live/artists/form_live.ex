defmodule TunezWeb.Artists.FormLive do
  use TunezWeb, :live_view

  def mount(%{"id" => artist_id}, _session, socket) do
    artist = Tunez.Music.get_artist_by_id!(artist_id, actor: socket.assigns.current_user)

    form =
      Tunez.Music.form_to_update_artist(artist, actor: socket.assigns.current_user)
      |> AshPhoenix.Form.ensure_can_submit!()

    socket =
      socket
      |> assign(:form, to_form(form))
      |> assign(:page_title, "Update Artist")

    {:ok, socket}
  end

  def mount(_params, _session, socket) do
    form =
      Tunez.Music.form_to_create_artist(actor: socket.assigns.current_user)
      |> AshPhoenix.Form.ensure_can_submit!()

    socket =
      socket
      |> assign(:form, to_form(form))
      |> assign(:page_title, "New Artist")

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <.header>
        <.h1>{@page_title}</.h1>
      </.header>

      <.simple_form
        :let={form}
        id="artist_form"
        as={:form}
        for={@form}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={form[:name]} label="Name" />
        <.input field={form[:biography]} type="textarea" label="Biography" />
        <:actions>
          <.button>Save</.button>
        </:actions>
      </.simple_form>
    </Layouts.app>
    """
  end

  def handle_event("validate", %{"form" => form_data}, socket) do
    {:noreply, TunezWeb.Live.AshForm.validate(socket, form_data)}
  end

  def handle_event("save", %{"form" => form_data}, socket) do
    socket =
      TunezWeb.Live.AshForm.save(socket, form_data,
        success_message: "Artist saved successfully",
        error_message: "Could not save artist data",
        on_success: &~p"/artists/#{&1}"
      )

    {:noreply, socket}
  end
end
