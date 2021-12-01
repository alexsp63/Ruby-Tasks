# frozen_string_literal: true

require_relative 'modules/instance_counter'
require_relative 'modules/validation'

class Route
  include InstanceCounter
  include Validation

  attr_reader :stations

  def initialize(start_station, end_station)
    @end_station = end_station
    @stations = [start_station, end_station]
    validate!
    register_instance
  end

  def add_station(station)
    @stations[-1] = station
    @stations.push(@end_station)
  end

  def delete_station(station)
    unless [@stations.first, @stations.last].include?(station) # если не начальная или конечная станция
      @stations.delete(station)
    end
  end

  protected

  # это дополнительная валидация
  def validate!
    raise "Start and end stations can't be empty" if @stations.first.nil? || @stations.last.nil?
  end
end
