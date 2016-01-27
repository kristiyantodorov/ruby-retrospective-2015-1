def next_position(snake, direction)
  [snake[-1][0] + direction[0], snake[-1][1] + direction[1]]
end

def move(snake, direction)
  snake.dup[1..-1].push next_position(snake, direction)
end

def grow(snake, direction)
  snake.dup.push next_position(snake, direction)
end

def new_food(food, snake, dimensions)
  all_positions_x = (0..(dimensions[:width] - 1)).to_a
  all_positions_y = (0..(dimensions[:height] - 1)).to_a
  game_positions = all_positions_x.product(all_positions_y)
  free_positions = game_positions - snake - food
  free_positions.sample
end

def obstacle_ahead?(snake, direction, dimensions)
  snake.include? next_position(snake, direction) or
  next_position(snake, direction)[0] < 0 or
  next_position(snake, direction)[0] >= dimensions[:width] or
  next_position(snake, direction)[1] < 0 or
  next_position(snake, direction)[1] >= dimensions[:height]
end

def danger?(snake, direction, dimensions)
  obstacle_ahead?(snake, direction, dimensions) or
  obstacle_ahead?(move(snake, direction), direction, dimensions)
end
