# frozen_string_literal: true

module Kor
  # App
  class App < Gosu::Window
    COLOURS = %w[white red blue green yellow].freeze
    FINISH_X = 1700

    def initialize
      super 1920, 1080
      self.caption = 'Kor'

      @background_image = Gosu::Image.new('assets/bg.jpg')
      @finish_image = Gosu::Image.new('assets/finish.png', tileable: true)
      @cars = []
      @going = false

      COLOURS.each_with_index do |colour, index|
        @cars << Kor::Car.new(colour: colour, position: { x: 100, y: (index * 200) + 100 })
      end

      @time_font = Gosu::Font.new(50)
      @winner_font = Gosu::Font.new(200)
      @start_time = 0
      @finished = false
      @winner = nil
    end

    def update
      if @going
        @cars.sample.move
        sleep 0.075
      end

      go! if Gosu.button_down?(Gosu::KB_RIGHT) && !@finished
      exit if Gosu.button_down? Gosu::KB_END
    end

    def draw
      @background_image.draw(0, 0, 0)
      @finish_image.draw(FINISH_X, 0, 0)
      @cars.each(&:draw)
      show_time
      check_for_winner
      declare_winner if @finished
    end

    def go!
      return if @going

      @start_time = Time.now.to_i
      @going = true
    end

    def stop!
      @going = false
      @finished = Time.now.to_i
    end

    def check_for_winner
      return if @finished

      @cars.each do |car|
        next if car.x < (FINISH_X + 10) - (@finish_image.width / 2)

        @winner = car
        stop!
      end
    end

    def declare_winner
      diff = @finished - @start_time

      @winner_font.draw_text("#{@winner.colour.upcase} WINS IN #{diff}s!", 100, 200, 3, 1.0, 1.0, Gosu::Color::YELLOW)
    end

    def show_time
      diff = Time.now.to_i - @start_time

      @time_font.draw_text("Time: #{diff}", 200, 1000, 3, 1.0, 1.0, Gosu::Color::YELLOW) if @going
    end
  end
end
