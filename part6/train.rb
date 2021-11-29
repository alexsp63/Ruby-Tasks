# frozen_string_literal: true

require_relative 'modules/manufacturer'
require_relative 'modules/instance_counter'
require_relative 'modules/validation'

class Train
  include Manufacturer
  include InstanceCounter
  include Validation

  attr_reader :number, :type, :vans, :speed, :route

  @@all_trains = []

  # или три буквы и/или цифры
  # или три буквы и/или цифры, дефис и ещё две буквы и/или цифры
  NUMBER_FORMAT = /^([a-z\d]{3}|[a-z\d]{3}-[a-z\d]{2})$/i

  def self.find(train_number)
    @@all_trains.select { |t| train_number == t.number }[0]
  end

  def initialize(number)
    @number = number
    @speed = 0
    validate!
    validate_existing!
    @type = :other
    @vans = []
    @current_station_index = nil
    @@all_trains.push(self) if @@all_trains.select { |t| number == t.number }.empty?
    register_instance
    @current_van_n = 1
  end

  def increase_speed
    @speed += speed_to_increase
  end

  def stop
    stop! if is_moving?
  end

  def is_moving?
    !speed.zero?
  end

  def add_van(van)
    if !is_moving? && van.type == type && !van.train
      @vans.push(van)
      van.train = self
      van.number_in_train = @current_van_n
      @current_van_n += 1
    end
  end

  def del_van(van)
    unless is_moving? # если попытаться удалить вагон, которого нет, ничего не произойдёт (в т.ч. если нет вагонов у поезда)
      @vans.delete(van)
      van.train = nil
      van.number_in_train = nil
    end
  end

  def route=(route)
    @route = route
    @current_station_index = 0
    current.add_train(self)
  end

  def move_forward
    if self.next
      current.send(self)
      @current_station_index += 1
      current.add_train(self)
    end
  end

  def move_back
    if prev
      current.send(self)
      @current_station_index -= 1
      current.add_train(self)
    end
  end

  def prev
    @route.stations[@current_station_index - 1] if @current_station_index.positive? && @route
  end

  def current
    @route.stations[@current_station_index] if @route
  end

  def next
    @route.stations[@current_station_index + 1] if @current_station_index < (@route.stations.size - 1) && @route
  end

  def with_block(&block)
    @vans.each &block
  end

  protected

  def speed_to_increase
    10
  end

  def stop!
    self.speed = 0
  end

  def validate!
    raise "Number can't be empty" if @number.nil?
    raise 'Invalid number' if @number !~ NUMBER_FORMAT
  end

  def validate_existing!
    # отдельным методом, чтобы в valid? не кидало false, так как проверяю уже существующий поезд
    raise 'Train already exists' if self.class.find(@number)
  end
end
