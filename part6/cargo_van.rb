# frozen_string_literal: true
require_relative 'modules/validation'

class CargoVan < Van
  include Validation

  attr_reader :volume, :free_volume

  def initialize(number, volume=10000)
    @number = number
    @type = :cargo
    @volume = volume
    @free_volume = @volume
    validate!
  end

  def take_volume(v)
    @free_volume -= v if @free_volume >= v && v > 0
  end

  def taken_volume
    @volume - @free_volume
  end

  protected

  def validate!
    raise 'Invalid volume (must be positive)' unless @volume.to_i > 0
  end
end
