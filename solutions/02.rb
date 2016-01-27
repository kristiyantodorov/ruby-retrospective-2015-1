dimensions = {width: 10, height: 10}

def next_position(snake, direction)
  [snake[-1][0] + direction[0], snake[-1][1] + direction[1]]
end

def move(snake, direction)
  snake = snake[1..-1]
  snake.push next_position(snake, direction)
end

def grow(snake, direction)
  snake = snake[0..-1]
  snake.push next_position(snake, direction)
end

def new_food(food, snake, dimensions)
  food_x = rand(dimensions[:width]).to_i
  food_y = rand(dimensions[:height]).to_i
  generated_food = [food_x, food_y]
  if snake.include? generated_food or food.include? generated_food
    new_food(food, snake, dimensions)
  else
    generated_food
  end
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