# frozen_string_literal: true

class CargoVan < Van
  def initialize(number)
    super
    @type = :cargo
  end
end
