# frozen_string_literal: true

class Train
  # я бы сделала этот класс абстрактным, чтобы создавать только либо пассажирский, либо грузовой поезд
  attr_reader :number, :type, :vans, :speed, :route

  def initialize(number)
    @number = number
    @speed = 0
    # пусть этот абстрактный поезд будет иметь тип "другой"
    # если отдельно передавать сюда тип, то что мешает пользователю передать, например, пассажирский
    # и тогда получится просто Train с типом пассажирский, но для этого у нас есть PassengerTrain
    # в общем, я не уверена, как лучше сделать
    @type = :other
    @vans = []
    @current_station_index = nil
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
