# frozen_string_literal: true

require_relative 'modules/instance_counter'

class Station
  include InstanceCounter

  attr_reader :name, :trains

  @@all_stations = []

  def self.all
    @@all_stations
  end

  def initialize(name)
    @name = name
    @trains = []
    @@all_stations.push(self)
    register_instance
  end

  def by_type(type_to_find)
    @trains.select { |t| type_to_find == t.type }
  end

  def add_train(train)
    @trains.push(train)
  end

  def send(train)
    @trains.delete(train)
  end
end
