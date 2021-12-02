# frozen_string_literal: true

require_relative 'modules/instance_counter'
require_relative 'modules/validation'

class Station
  include InstanceCounter
  include Validation

  attr_reader :name, :trains

  NAME_FORMAT = /[a-z]+/i

  @@all_stations = []

  validate :name, :presence
  validate :name, :format, NAME_FORMAT

  def self.all
    @@all_stations
  end

  def initialize(name)
    @name = name
    @trains = []
    validate!
    validate_existing!
    @@all_stations.push(self)
    register_instance
  end

  def by_type(type_to_find)
    @trains.select { |t| type_to_find == t.type }
  end

  def add_train(train)
    @trains.push(train)
  end

  def send_train(train)
    @trains.delete(train)
  end

  def with_block(&block)
    @trains.each(&block)
  end

  protected

  def validate_existing!
    raise 'Station already exists' unless @@all_stations.select { |s| @name == s.name }.empty?
  end
end
