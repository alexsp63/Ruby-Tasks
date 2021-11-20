# frozen_string_literal: true

class Van
  attr_reader :number, :type
  attr_accessor :train

  def initialize(number)
    @number = number
    @type = :other # то же самое, что и с поездами
    @train = nil
  end
end
