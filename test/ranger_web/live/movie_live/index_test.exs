defmodule RangerWeb.MovieLive.IndexTest do
  use RangerWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Ranger.CloudinaryUpload

  test "user can see preview of poster to be uploaded", ctx do
    {:ok, view, _html} = live(ctx.conn, ~p"/movies")

    assert view
           |> upload("fellowship-poster.jpg")
           |> has_element?("[data-role=image-preview]")
  end

  test "user can cancel upload", ctx do
    {:ok, view, _html} = live(ctx.conn, ~p"/movies")

    view
    |> upload("fellowship-poster.jpg")
    |> cancel_upload()

    refute has_element?(view, "[data-role=image-preview]")
  end

  test "user sees error when uploading too many files", ctx do
    {:ok, view, _html} = live(ctx.conn, ~p"/movies")

    view
    |> upload("fellowship-poster.jpg")
    |> upload("fellowship-poster.jpg")
    |> upload("fellowship-poster.jpg")

    assert render(view) =~ "Too many files"
  end

  test "generates correct metadata for external upload", ctx do
    {:ok, view, _html} = live(ctx.conn, ~p"/movies")

    {:ok, %{entries: entries}} =
      view
      |> file_input("#upload-form", :posters, [
        %{
          name: "fellowship-poster.jpg",
          content: File.read!("test/support/images/fellowship-poster.jpg"),
          type: "image/jpeg"
        }
      ])
      |> preflight_upload()

    for {_k, v} <- entries do
      assert v.uploader == "Cloudinary"
      assert v.url =~ CloudinaryUpload.image_api_url(cloud_name())
      assert v.fields[:folder] == "testing-liveview"

      assert is_binary(v.fields[:public_id])
      refute String.ends_with?(v.fields[:public_id], ".jpg")

      assert is_binary(v.fields[:signature])
      refute is_nil(v.fields[:api_key])
      refute is_nil(v.fields[:timestamp])
    end
  end

  test "user can create movie and stores correct URLs", ctx do
    {:ok, view, _html} = live(ctx.conn, ~p"/movies")

    {:ok, show_view, _show_html} =
      view
      |> upload("fellowship-poster.jpg")
      |> create_movie("The Fellowship of the Ring")
      |> follow_redirect(ctx.conn)

    assert has_element?(show_view, "h2", "The Fellowship of the Ring")
    assert has_element?(show_view, "[data-role=image]")
    assert hd(last_movie().poster_urls) =~ CloudinaryUpload.image_url(cloud_name())
  end

  defp upload(view, filename) do
    view
    |> file_input("#upload-form", :posters, [
      %{
        name: filename,
        content: File.read!("test/support/images/#{filename}"),
        type: "image/jpeg"
      }
    ])
    |> render_upload(filename)

    # Calls Phoenix validate event
    view
    |> form("#upload-form")
    |> render_change()

    view
  end

  defp cancel_upload(view) do
    view
    |> element("[data-role=cancel-upload]")
    |> render_click()
  end

  defp create_movie(view, name) do
    view
    |> form("#upload-form", %{movie: %{name: name}})
    |> render_submit()
  end

  defp cloud_name do
    Application.get_env(:ranger, :cloudinary)[:cloud_name]
  end

  defp last_movie do
    Ranger.Movie
    |> Ecto.Query.last()
    |> Ranger.Repo.one()
  end
end
