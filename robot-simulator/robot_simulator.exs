defmodule RobotSimulator do
  defstruct direction: :north, position: {0, 0}
  @compass [:north, :east, :south, :west]

  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec create(direction :: atom, position :: { integer, integer }) :: any
  def create(direction \\ nil, position \\ nil)
  def create(nil, nil),
    do: %RobotSimulator{}
  def create(direction, _position) when direction not in [:north, :east, :south, :west],
    do: {:error, "invalid direction"}
  def create(direction, {x, y}) when is_integer(x) and is_integer(y),
    do: %RobotSimulator{direction: direction, position: {x, y}}
  def create(_direction, _position),
    do: {:error, "invalid position"}

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)
  """
  @spec simulate(robot :: any, instructions :: String.t ) :: any
  def simulate(robot, "R" <> rest),
    do: simulate(turn(robot, 1), rest)
  def simulate(robot, "L" <> rest),
    do: simulate(turn(robot, -1), rest)
  def simulate(%RobotSimulator{direction: :north, position: {x, y}} = robot, "A" <> rest),
    do: simulate(%RobotSimulator{robot | position: {x, y + 1}}, rest)
  def simulate(%RobotSimulator{direction: :east,  position: {x, y}} = robot, "A" <> rest),
    do: simulate(%RobotSimulator{robot | position: {x + 1, y}}, rest)
  def simulate(%RobotSimulator{direction: :south, position: {x, y}} = robot, "A" <> rest),
    do: simulate(%RobotSimulator{robot | position: {x, y - 1}}, rest)
  def simulate(%RobotSimulator{direction: :west,  position: {x, y}} = robot, "A" <> rest),
    do: simulate(%RobotSimulator{robot | position: {x - 1, y}}, rest)
  def simulate(robot, <<>>) do
    robot
  end
  def simulate(_robot, _instructions),
    do: {:error, "invalid instruction"}

  defp turn(robot, shift) do
    index = Enum.find_index(@compass, &(&1 == robot.direction))
    %{robot | direction: Enum.at(@compass, rem(index + shift, 4))}
  end

  @doc """
  Return the robot's direction.

  Valid directions are: :north`, `:east`, `:south`, `:west`
  """
  @spec direction(robot :: any) :: atom
  def direction(%RobotSimulator{direction: direction}),
    do: direction

  @doc """
  Return the robot's position.
  """
  @spec position(robot :: any) :: { integer, integer }
  def position(%RobotSimulator{position: position}),
    do: position
end
