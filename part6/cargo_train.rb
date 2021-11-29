# frozen_string_literal: true

class CargoTrain < Train
  def initialize(number)
    super
    @type = :cargo
  end

  protected

  def speed_to_increase
    15
  end
end
