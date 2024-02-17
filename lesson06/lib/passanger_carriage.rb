class PassangerCarriage < Carriage
  def initialize(number)
    super(number)
    @type = :passenger
  end
end