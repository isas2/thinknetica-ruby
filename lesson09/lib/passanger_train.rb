# frozen_string_literal: true

class PassangerTrain < Train
  def initialize(number)
    super(number)
    @type = :passenger
  end
end
