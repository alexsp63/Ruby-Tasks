# frozen_string_literal: true

require_relative 'modules/manufacturer'
require_relative 'modules/validation'
require_relative 'modules/accessors'

class Van
  include Manufacturer
  include Validation
  include Accessors

  attr_reader :number, :type

  attr_accessor_with_history :train, :number_in_train

  validate :number, :presence

  def initialize(number)
    @number = number
    @type = :other
    @train = nil
    validate!
  end
end
