# frozen_string_literal: true

class Station
  attr_reader :name, :trains

  def initialize(name)
    @name = name
    @trains = []
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
