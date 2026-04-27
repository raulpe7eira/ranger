defmodule RangerWeb.GreetLiveTest do
  use RangerWeb.ConnCase

  import Phoenix.LiveViewTest

  test "renders disconnected state", ctx do
    disconnected = ctx.conn |> get(~p"/greet")

    assert html_response(disconnected, 200) =~ "Welcome to stateless HTTP"
  end

  test "upgrades the connection", ctx do
    disconnected = ctx.conn |> get(~p"/greet")
    {:ok, _view, html} = live(disconnected)

    assert html =~ "Welcome to Testing LiveView"
  end

  test "rendering connected state", ctx do
    {:ok, _view, html} = live(ctx.conn, ~p"/greet")

    assert html =~ "Welcome to Testing LiveView"
  end

  test "rendering with the view", ctx do
    {:ok, view, _html} = live(ctx.conn, ~p"/greet")

    assert view.module == RangerWeb.GreetLive
    assert is_pid(view.pid)
    assert render(view) =~ "Welcome to Testing LiveView"
  end
end
