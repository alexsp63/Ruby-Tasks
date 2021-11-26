# frozen_string_literal: true

require_relative 'modules/manufacturer'
require_relative 'modules/validation'

class Van
  include Manufacturer
  include Validation

  attr_reader :number, :type
  attr_accessor :train

  def initialize(number)
    @number = number
    @type = :other
    @train = nil
    validate!
  end

  protected

  def validate!
    raise "Number can't be empty" if @number.nil?
  end
end
