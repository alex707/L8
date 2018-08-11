# discriprion for passenger wagons
class PassengerCar < Car
  attr_reader :seats

  def initialize(seats)
    @seats = seats
    @reserved_seats = 0

    validate!
  end

  def validate!
    raise 'Number of seats can not to be nil' if @seats.nil?
    raise 'Number of seats can not to be 0' if @seats.zero?
    true
  end

  def valid?
    validate!
  rescue StandardError
    false
  end

  def reserve_seat
    raise 'Car is full' if @reserved_seats == @seats
    @reserved_seats += 1
  end

  def unreserve_seat
    raise 'Car is empty' if @reserved_seats.zero?
    @reserved_seats -= 1
  end

  attr_reader :reserved_seats

  def vacant_seats
    @seats - @reserved_seats
  end
end
