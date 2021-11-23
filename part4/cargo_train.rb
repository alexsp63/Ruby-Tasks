# frozen_string_literal: true

class CargoTrain < Train
  def initialize(number)
    super
    @type = :cargo
  end

  protected

  # может разгоняться быстрее
  def speed_to_increase
    15
  end
end
