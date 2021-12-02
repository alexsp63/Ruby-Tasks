# frozen_string_literal: true

require_relative 'modules/validation'

class PassengerVan < Van
  include Validation

  attr_reader :seats_q, :free_seats_q

  def initialize(number, seats_q = 54)
    @number = number
    @type = :passenger
    @seats_q = seats_q
    @free_seats_q = @seats_q
    validate!
  end

  def take_a_seat
    @free_seats_q -= 1 if @free_seats_q >= 1
  end

  def taken_seats_q
    @seats_q - @free_seats_q
  end

  protected

  def validate!
    raise 'Invalid seats quantity (must be integer from 1 to 60)' unless @seats_q.to_i.between?(1, 60)
  end
end
