defmodule RangerWeb.MetricsLiveTest do
  use RangerWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "renders loading indicator when loading", ctx do
    {:ok, _view, html} = live(ctx.conn, ~p"/metrics")

    assert html =~ "data-role=\"loading\""
  end

  test "renders metric after loading", ctx do
    {:ok, view, _html} = live(ctx.conn, ~p"/metrics")

    timeout = Application.get_env(:ranger, RangerWeb.MetricsLive)[:timeout]

    assert render_async(view, timeout + 100) =~ "User Visits"
  end

  test "renders failure case upon failure", ctx do
    {:ok, view, _html} = live(ctx.conn, ~p"/metrics?test_force_failure=true")

    assert render_async(view) =~ "Failed to load"
  end
end
