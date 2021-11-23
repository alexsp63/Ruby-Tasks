# frozen_string_literal: true
require_relative 'modules/manufacturer'
require_relative 'modules/instance_counter'

class Train

  include Manufacturer
  include InstanceCounter

  attr_reader :number, :type, :vans, :speed, :route

  @@all_trains = []  

  def self.find(train_number)
    @@all_trains.select { |t| train_number == t.number }[0]   # если нет поезда, вернётся nil
  end

  def initialize(number)
    @number = number
    @speed = 0
    @type = :other
    @vans = []
    @current_station_index = nil
    @@all_trains.push(self) if @@all_trains.select { |t| number == t.number }.empty?   # номер поезда может рассматриваться как уникальный идентификатор, а один первичный ключ не должен быть у нескольких объектов
    register_instance
  end

  def increase_speed
    @speed += speed_to_increase
  end

  def stop
    # остановиться поезд может только если он был в движении, иначе нечего останавливать
    stop! if is_moving?
  end

  def is_moving?
    !speed.zero?
  end

  def add_van(van)
    if !is_moving? && van.type == type && !van.train
      @vans.push(van)
      van.train = self
    end
  end

  def del_van(van)
    unless is_moving? # если попытаться удалить вагон, которого нет, ничего не произойдёт (в т.ч. если нет вагонов у поезда)
      @vans.delete(van)
      van.train = nil
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

  protected

  # каждый тип поезда может разгоняться быстрее или медленнее
  def speed_to_increase
    10
  end

  # это вынесено в protected, чтобы пользователь не мог изменить скорость на 0
  # (т.е. остановить поезд), если поезд и не двигался
  def stop!
    self.speed = 0
  end
end
