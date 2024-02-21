# frozen_string_literal: true

module Vehicle
  attr_accessor :producer

  def self.included(base)
    base.class_eval %(
      class << self; attr_reader :types; end;
      @types = {cargo: 'грузовой', passenger: 'пассажирский'}), __FILE__, __LINE__ - 2
  end
end
