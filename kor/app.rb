# frozen_string_literal: true

module Kor
  # App
  class App < Gosu::Window
    COLOURS = %w[white red blue green yellow].freeze
    FINISH_X = 1700

    def initialize
      super 1920, 1080
      init_themes
      init_ui
      init_cars

      self.caption = 'Kor'
    end

    def init_ui
      @time_font = Gosu::Font.new(50)
      @winner_font = Gosu::Font.new(200)
      @start_time = 0
      @finished = false
      @winner = nil
      @going = false
      init_background_finish_images
    end

    def init_background_finish_images
      @background_image = Gosu::Image.new(theme_image('bg.jpg'))
      @finish_image = Gosu::Image.new(theme_image('finish.png'), tileable: true)
    end

    def init_cars
      @cars = []

      @current_theme_entities.each_with_index do |colour, index|
        @cars << Kor::Car.new(colour: colour, position: { x: 100, y: (index * 200) + 100 }, app: self)
      end
    end

    def init_themes
      @theme_index = 0
      @themes = Dir.glob('assets/themes/*')
      @current_theme_entities = []
      init_current_theme_entities
    end

    def theme_image(filename)
      "#{current_theme}/#{filename}"
    end

    def current_theme
      @themes[@theme_index]
    end

    def load_next_theme
      @theme_index = (@theme_index + 1) % @themes.size
      init_current_theme_entities
      init_background_finish_images
      @current_theme_entities.each_with_index do |image, index|
        @cars[index].init_image(image)
      end
    end

    def init_current_theme_entities
      @current_theme_entities = []
      Dir.each_child(current_theme) do |file|
        @current_theme_entities << file.split('_')[1].split('.')[0] if file.include?('car')
      end
    end

    def update
      if @going
        @cars.sample.move
        sleep 0.075
      end

      go! if Gosu.button_down?(Gosu::KB_RIGHT) && !@finished
      exit if Gosu.button_down? Gosu::KB_END
      load_next_theme if Gosu.button_down? Gosu::KB_T
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
