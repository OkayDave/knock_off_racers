#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'

  gem 'gosu'
  gem 'byebug'
end

require_relative 'kor/app'
require_relative 'kor/car'

kor = ::Kor::App.new

kor.show
