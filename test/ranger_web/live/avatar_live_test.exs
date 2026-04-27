defmodule RangerWeb.AvatarLiveTest do
  use RangerWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Ranger.Gravatar

  test "renders avatar for give email", ctx do
    email = "frodo@shire.com"
    avatar_url = Gravatar.generate(email)
    {:ok, _view, html} = live(ctx.conn, ~p"/avatar/#{email}")

    assert html =~ avatar_url
  end

  test "renders avatar HTML", ctx do
    email = "frodo@shire.com"
    avatar_url = Gravatar.generate(email)
    {:ok, _view, html} = live(ctx.conn, ~p"/avatar/#{email}")

    avatar = ~s(<img class="avatar" src="#{avatar_url}")

    assert html =~ avatar
  end

  test "renders avatar image for given email", ctx do
    email = "frodo@shire.com"
    avatar_url = Gravatar.generate(email)
    {:ok, view, _html} = live(ctx.conn, ~p"/avatar/#{email}")

    assert has_element?(view, ~s(img[src*="#{avatar_url}"]))
  end

  test "renders avatar element for given email", ctx do
    email = "frodo@shire.com"
    avatar_url = Gravatar.generate(email)
    {:ok, view, _html} = live(ctx.conn, ~p"/avatar/#{email}")

    avatar = element(view, ~s(img[src*="#{avatar_url}"]))

    assert has_element?(avatar)
  end
end
