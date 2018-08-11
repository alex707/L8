# class with common methods for working with wagons
class Car
  include Company

  attr_accessor :status

  def initialize
    @status = true

    validate!
  end

  # rubocop:disable Style/DoubleNegation
  def validate!
    raise 'Status must be true or false (used/unused)' unless !!status == status
    true
  end
  # rubocop:enable Style/DoubleNegation

  def valid?
    validate!
  rescue StandardError
    false
  end
end
