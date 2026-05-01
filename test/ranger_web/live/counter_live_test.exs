defmodule RangerWeb.CounterLiveTest do
  use RangerWeb.ConnCase

  import Phoenix.LiveViewTest

  test "user con increase counter", ctx do
    {:ok, view, _html} = live(ctx.conn, ~p"/counter")

    # It's useful for debugging
    # open_browser(view)

    view
    |> element("#increment")
    |> render_click()

    # It's useful for debugging
    # open_browser(view)

    assert has_element?(view, "#count", "1")
  end

  test "user con increase counter (uses HTML)", ctx do
    {:ok, view, _html} = live(ctx.conn, ~p"/counter")

    html =
      view
      |> element("#increment")
      |> render_click()

    assert html =~ "1"
  end

  test "user con increase counter (target event directly)", ctx do
    {:ok, view, _html} = live(ctx.conn, ~p"/counter")

    render_click(view, "increase")

    assert has_element?(view, "#count", "1")
  end

  test "user can decrease counter", ctx do
    {:ok, view, _} = live(ctx.conn, ~p"/counter")

    view
    |> element("#decrement")
    |> render_click()

    assert has_element?(view, "#count", "-1")
  end
end
