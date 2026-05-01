defmodule RangerWeb.CounterLiveTest do
  use RangerWeb.ConnCase

  import Phoenix.LiveViewTest

  test "user con increase counter", ctx do
    {:ok, view, _html} = live(ctx.conn, ~p"/counter")

    view
    |> element("#increment")
    |> render_click()

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
end
