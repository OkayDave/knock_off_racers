# frozen_string_literal: true

module Kor
  # Car
  class Car
    attr_accessor :colour, :x, :y, :image, :angle, :theme, :app
    X_MOVEMENT = 30

    def initialize(colour:, position:, app:)
      self.colour = colour
      self.x = position[:x]
      self.y = position[:y]
      self.theme = theme
      self.angle = 0
      self.app = app
      init_image(colour)
    end

    def init_image(colour)
      self.image = Gosu::Image.new(app.theme_image("car_#{colour}.png"))
    end

    def move
      move_speed = rand(0..X_MOVEMENT)

      self.angle = move_speed > 20 ? -25 : 0

      self.x += move_speed
    end

    def draw
      image.draw_rot(x, y, 0, angle)
    end
  end
end
