# frozen_string_literal: true

class PassengerVan < Van
  def initialize(number)
    super
    @type = :passenger
  end
end
