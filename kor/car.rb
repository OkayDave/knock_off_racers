# frozen_string_literal: true

module Kor
  # Car
  class Car
    attr_accessor :colour, :x, :y, :image, :angle
    X_MOVEMENT = 30

    def initialize(colour:, position:)
      self.colour = colour
      self.x = position[:x]
      self.y = position[:y]
      self.image = Gosu::Image.new("assets/car_#{colour}.png")
      self.angle = 0
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
