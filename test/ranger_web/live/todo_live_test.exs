defmodule RangerWeb.TodoLiveTest do
  use RangerWeb.ConnCase

  import Phoenix.LiveViewTest

  test "user can create a new todo", ctx do
    {:ok, view, _html} = live(ctx.conn, ~p"/todo")

    view
    |> form("#add-todo", %{todo: %{body: "Form fellowship"}})
    |> render_submit()

    assert has_element?(view, "[data-role=todo]", "Form fellowship")
  end

  test "user can create a new todo (target event directly)", ctx do
    {:ok, view, _html} = live(ctx.conn, ~p"/todo")

    render_submit(view, "create", %{todo: %{body: "Form fellowship"}})

    assert has_element?(view, "[data-role=todo]", "Form fellowship")
  end

  test "user can create a new todo (with HTML)", ctx do
    {:ok, view, _html} = live(ctx.conn, ~p"/todo")

    html =
      view
      |> form("#add-todo", %{todo: %{body: "Form fellowship"}})
      |> render_submit()

    assert html =~ "Form fellowship"
  end
end
