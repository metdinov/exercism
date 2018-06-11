defmodule BinTree do
  import Inspect.Algebra

  @moduledoc """
  A node in a binary tree.

  `value` is the value of a node.
  `left` is the left subtree (nil if no subtree).
  `right` is the right subtree (nil if no subtree).
  """
  @type t :: %BinTree{value: any, left: BinTree.t() | nil, right: BinTree.t() | nil}
  defstruct value: nil, left: nil, right: nil

  # A custom inspect instance purely for the tests, this makes error messages
  # much more readable.
  #
  # BT[value: 3, left: BT[value: 5, right: BT[value: 6]]] becomes (3:(5::(6::)):)
  def inspect(%BinTree{value: v, left: l, right: r}, opts) do
    concat([
      "(",
      to_doc(v, opts),
      ":",
      if(l, do: to_doc(l, opts), else: ""),
      ":",
      if(r, do: to_doc(r, opts), else: ""),
      ")"
    ])
  end
end

defmodule Zipper do
  alias BinTree, as: BT
  alias Zipper, as: Z

  @type trail :: [ { :left, any, BT.t } | { :right, any, BT.t } ]

  @type t :: %Zipper{focus: any, left: BT.t, right: BT.t, trail: trail}
  defstruct focus: nil, left: nil, right: nil, trail: []

  @doc """
  Get a zipper focused on the root node.
  """
  @spec from_tree(BT.t()) :: Z.t()
  def from_tree(%BT{value: v, left: l, right: r}), do: %Z{focus: v, left: l, right: r, trail: []}

  @doc """
  Get the complete tree from a zipper.
  """
  @spec to_tree(Z.t()) :: BT.t()
  def to_tree(%Z{focus: f, left: l, right: r, trail: []}), 
    do: %BT{value: f, left: l, right: r}
  def to_tree(zipper), do: zipper |> up |> to_tree

  # def to_tree(%Z{focus: f, left: l, right: r, trail: trail}), 
  #   do: _unroll(%BT{value: f, left: l, right: r}, trail)

  # defp _unroll(tree, []), 
  #   do: tree
  # defp _unroll(tree, [{:left, parent_value, parent_tree} | trail]), 
  #   do: _unroll(%BT{value: parent_value, left: tree, right: parent_tree}, trail)
  # defp _unroll(tree, [{:right, parent_value, parent_tree} | trail]), 
  #   do: _unroll(%BT{value: parent_value, left: parent_tree, right: tree}, trail)


  @doc """
  Get the value of the focus node.
  """
  @spec value(Z.t()) :: any
  def value(%Z{focus: f}), do: f

  @doc """
  Get the left child of the focus node, if any.
  """
  @spec left(Z.t()) :: Z.t() | nil
  def left(%Z{left: nil}), 
    do: nil
  def left(%Z{focus: f, left: l, right: r, trail: trail}), 
    do: %Z{focus: l.value, left: l.left, right: l.right, trail: [{:left, f, r} | trail]}

  @doc """
  Get the right child of the focus node, if any.
  """
  @spec right(Z.t()) :: Z.t() | nil
  def right(%Z{right: nil}), 
    do: nil
  def right(%Z{focus: f, left: l, right: r, trail: trail}), 
    do: %Z{focus: r.value, left: r.left, right: r.right, trail: [{:right, f, l} | trail]}

  @doc """
  Get the parent of the focus node, if any.
  """
  @spec up(Z.t()) :: Z.t()
  def up(%Z{trail: []}),
    do: nil
  def up(%Z{focus: f, left: l, right: r, trail: [{:left, value, tree} | trail]}),
    do: %Z{focus: value, left: %BT{value: f, left: l, right: r}, right: tree, trail: trail}
  def up(%Z{focus: f, left: l, right: r, trail: [{:right, value, tree} | trail]}),
    do: %Z{focus: value, right: %BT{value: f, left: l, right: r}, left: tree, trail: trail}

  @doc """
  Set the value of the focus node.
  """
  @spec set_value(Z.t(), any) :: Z.t()
  def set_value(zipper, v), do: %Z{zipper | focus: v}

  @doc """
  Replace the left child tree of the focus node.
  """
  @spec set_left(Z.t(), BT.t()) :: Z.t()
  def set_left(zipper, l), do: %{zipper | left: l}

  @doc """
  Replace the right child tree of the focus node.
  """
  @spec set_right(Z.t, BT.t) :: Z.t
  def set_right(zipper, r), do: %{zipper | right: r}
end
