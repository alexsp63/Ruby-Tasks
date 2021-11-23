# frozen_string_literal: true

module Manufacturer
  def self.included(base)
    # base.extend ClassMethods   # на случай, если потом придётся писать методы класса
    base.send(:include, InstanceMethods)
  end

  module InstanceMethods
    attr_accessor :manufacturer
  end
end
