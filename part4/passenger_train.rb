# frozen_string_literal: true

class PassengerTrain < Train
  def initialize(number)
    super
    @type = :passenger
  end

  protected

  # за единицу времени пусть разгоняется медленнее,
  # чтобы пассажирам было комфортно
  def speed_to_increase
    5
  end
end
