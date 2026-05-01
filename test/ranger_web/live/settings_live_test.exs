defmodule RangerWeb.SettingsLiveTest do
  use RangerWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  alias Ranger.Repo
  alias Ranger.User

  test "renders user's information", ctx do
    user = create_user()

    {:ok, _view, html} = live(ctx.conn, ~p"/users/#{user}/settings")

    assert html =~ user.name
    assert html =~ user.email
  end

  test "users can edit their name", ctx do
    user = create_user(%{name: "Frodo"})
    {:ok, view, _html} = live(ctx.conn, ~p"/users/#{user}/settings")

    view
    |> element("#name")
    |> render_click()

    view
    |> form("#name-form", %{name: "Bilbo"})
    |> render_submit()

    assert has_element?(view, "#name", "Bilbo")
  end

  test "users can edit their email", ctx do
    user = create_user(%{email: "frodo@example.com"})
    {:ok, view, _html} = live(ctx.conn, ~p"/users/#{user}/settings")

    view
    |> element("#email")
    |> render_click()

    view
    |> form("#email-form", %{email: "bilbo@example.com"})
    |> render_submit()

    assert has_element?(view, "#email", "bilbo@example.com")
  end

  defp create_user(attrs \\ %{}) do
    %{name: "somename", email: "random@example.com"}
    |> Map.merge(attrs)
    |> User.changeset()
    |> Repo.insert!()
  end
end
