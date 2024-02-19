module Vehicle
  attr_accessor :producer

  def self.included(base)
    base.class_eval %(
      class << self; attr_reader :types; end;
      @types = {cargo: 'грузовой', passenger: 'пассажирский'})
  end
end