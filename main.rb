load './instance_counter.rb'
load './company.rb'
load './station.rb'
load './route.rb'
load './train.rb'
load './passenger_train.rb'
load './cargo_train.rb'
load './car.rb'
load './passenger_car.rb'
load './cargo_car.rb'

choise = ''

# rubocop:disable Layout/IndentHeredoc
menu_text = <<-'MENU_TEXT'
Choose action:
  1   - Create station
  2   - Create train
  3   - Create route
  4   - Add station to route
  5   - Remove station from route
  6   - Set route to train
  7   - Add cars to train
  8   - Remove cars from train
  9   - Move train forward
  10  - Move train backward
  11  - Display stations list
  12  - Display trains list
  13  - Display routes list
  14  - Display cars list (in train)
  15  - Load/Unload car
(Enter 'stop' for exit)
MENU_TEXT
# rubocop:enable Layout/IndentHeredoc

stations  = []
trains    = []
routes    = []
cars      = []

while choise != 'stop'
  begin
    puts menu_text
    print 'Your choise: '
    choise = gets.chomp
    puts

    case choise
    when 'stop'
      puts 'Exiting...'
      next

    when '1'
      puts 'Enter station name: '
      name = gets.chomp
      stations << Station.new(name)

    when '2'
      print 'Enter train number: '
      number = gets.chomp
      print "Enter train type ('pass' or 'cargo'): "
      type = gets.chomp

      case type
      when 'pass'
        trains << PassengerTrain.new(number, type)
      when 'cargo'
        trains << CargoTrain.new(number, type)
      else
        puts "Type must be 'pass' or 'cargo'. Retry saving of the train."
      end

    when '3'
      print 'Enter begin station name (from existing stations): '
      name1 = gets.chomp
      print 'Enter end station name (from existing stations): '
      name2 = gets.chomp

      st1 = stations.select { |st| st.name == name1 }.first
      st2 = stations.select { |st| st.name == name2 }.first

      if st1 && st2
        routes << Route.new(st1, st2)
        puts 'Route created succesfull.'
      else
        puts "Bad station name. Check stations(see p.11). Route was't created."
      end

    when '4'
      print 'Enter begin station name (first station of route): '
      name1 = gets.chomp
      print 'Enter end station name (last station of route): '
      name2 = gets.chomp

      route = routes.select do |r|
        r.st_begin.name == name1 && r.st_end.name == name2
      end
      route = route.first

      if route
        print 'Enter station name to add (from existing): '
        name3 = gets.chomp

        station = stations.select { |s| s.name == name3 }.first
        if station
          route.add_station station
          puts 'Station was added to route'
        else
          puts 'Station for add not found. check station list (see p. 11)'
        end
      else
        puts 'Route not found.'
      end

    when '5'
      print 'Enter begin station name (first station of route): '
      name1 = gets.chomp
      print 'Enter end station name (last station of route): '
      name2 = gets.chomp

      route = routes.select do |r|
        r.st_begin.name == name1 && r.st_end.name == name2
      end
      route = route.first

      if route
        print 'Enter station name to remove (from existing in route list): '
        name3 = gets.chomp

        station = route.intermediate.select { |s| s.name == name3 }.first
        if station
          route.delete_station(name3)
          puts 'Station was removed from route'
        else
          puts 'Station for delete not found.' \
            'Check stations in route(see p. 13)'
        end
      else
        puts 'Route not found.'
      end

    when '6'
      print 'Enter train number for setting route: '
      number = gets.chomp

      train = trains.select { |t| t.number == number }.first
      if train
        print 'Enter begin station name (first station of route): '
        name1 = gets.chomp
        print 'Enter end station name (last station of route): '
        name2 = gets.chomp

        route = routes.select do |r|
          r.st_begin.name == name1 && r.st_end.name == name2
        end
        route = route.first

        if route
          train.route = route
          puts 'Route entered.'
        else
          puts 'Route not found.'
        end
      else
        puts 'Train not found.'
      end

    when '7'
      print 'Enter train number to add cars: '
      number = gets.chomp

      train = trains.select { |t| t.number == number }.first
      if train
        c = if train.type == 'pass'
              print 'Enter number of seats: '
              nums = gets.to_i

              PassengerCar.new(nums)
            else
              print 'Enter volume: '
              vol = gets.to_i

              CargoCar.new(vol)
            end
        train.car_connect(c)

        cars << c
        puts 'Car added.'
      else
        puts 'Train not found.'
      end

    when '8'
      print 'Enter train number to remove cars: '
      number = gets.chomp

      train = trains.select { |t| t.number == number }.first
      if train
        if train.cars_count.zero?
          puts 'Can not to remove cars: cars count is zero.'
        else
          train.car_disconnect
          puts 'Car removed.'
        end
      else
        puts 'Train not found.'
      end

    when '9'
      print 'Enter train number to move next station: '
      number = gets.chomp

      train = trains.select { |t| t.number == number }.first
      if train
        if train.route
          train.go_to_next_st
          puts 'Train moved.'
        else
          puts 'Can not move train: set route.'
        end
      else
        puts 'Train not found.'
      end

    when '10'
      print 'Enter train number to move next station: '
      number = gets.chomp

      train = trains.select { |t| t.number == number }.first
      if train
        if train.route
          train.go_to_prev_st
          puts 'Train moved.'
        else
          puts 'Can not move train: set route.'
        end
      else
        puts 'Train not found.'
      end

    when '11'
      puts 'Station name    train  cars cnt'
      stations.each do |st|
        if st.trains.any?
          st.trains.each do |t|
            puts "  #{st.name.rjust(10, ' ')}   " \
              "#{t.number.rjust(6, ' ')}  " \
              "#{t.cars_count.to_s.rjust(8, ' ')}"
          end
        else
          puts "  #{st.name.rjust(10, ' ')}"
        end
      end

    when '12'
      puts 'Cur.St    Number     Type     Cars    Company name    Route'
      trains.each do |t|
        bname = t.route.st_begin.name
        ename = t.route.st_end.name

        rr = t.route.nil?   ? '' : "#{bname}-#{ename}"
        s  = t.station.nil? ? '' : t.station.name

        puts "#{s.ljust(8, ' ')} " \
          "#{t.number.to_s.rjust(7, ' ')}   " \
          "#{t.type.rjust(6, ' ')}" \
          "#{t.cars_count.to_s.rjust(9, ' ')}" \
          "#{t.company_name.to_s.rjust(17, ' ')}     " \
          "#{rr}"
      end

    when '13'
      puts 'Route name            stations'
      routes.each do |r|
        puts "#{(r.st_begin.name + '-' + r.st_end.name).rjust(20, ' ')}  " \
          "#{r.intermediate.map(&:name).join(', ')}"
      end

    when '14'
      print 'Enter train number: '
      number = gets.chomp

      train = trains.select { |t| t.number == number }.first
      if train.nil?
        puts 'Train not found.'
      else
        puts 'Cur.St   train   type   cars count    ' \
          'cars detalization (car number/reserved/vacant/total)'
        s = train.station.nil? ? 'none' : train.station.name
        c = if train.type == 'pass'
              train.cars.map do |car|
                [
                  car.object_id.to_s,
                  car.reserved_seats.to_s,
                  car.vacant_seats.to_s,
                  car.seats.to_s
                ].join('/')
              end
            else
              train.cars.map do |car|
                [
                  car.object_id.to_s,
                  car.reserved_volume.to_s,
                  car.vacant_volume.to_s,
                  car.volume.to_s
                ].join('/')
              end
            end

        puts "#{s.ljust(8, ' ')}" \
          "#{train.number.rjust(6, ' ')}  " \
          "#{train.type.rjust(5, ' ')}       " \
          "#{train.cars_count.to_s.rjust(6, ' ')}    " \
          "#{c.join(' , ')}"
      end

    when '15'
      print 'Enter train number for load/unload car: '
      number = gets.chomp

      train = trains.select { |t| t.number == number }.first
      if train.nil?
        puts 'Train not found.'
      else
        c = if train.type == 'pass'
              train.cars.map do |car|
                [
                  car.object_id.to_s,
                  car.reserved_seats.to_s,
                  car.vacant_seats.to_s,
                  car.seats.to_s
                ].join('/')
              end
            else
              train.cars.map do |car|
                [
                  car.object_id.to_s,
                  car.reserved_volume.to_s,
                  car.vacant_volume.to_s,
                  car.volume.to_s
                ].join('/')
              end
            end

        puts 'Car detalization list(car number/reserved/vacant/total):'
        puts c.join(' , ').to_s

        print 'Enter car number for load/unload: '
        cnumber = gets.to_i
        car = train.cars.select { |x| x.object_id == cnumber }.first
        if car.nil?
          puts 'Car not found. (See p.14)'
        else
          puts 'what do you want: '
          puts '  1 - load'
          puts '  2 - unload'
          chs = gets.to_i

          if chs == 1
            car.is_a?(PassengerCar) ? car.reserve_seat : car.reserve_volume
            puts 'Car loaded.'
          else
            car.is_a?(PassengerCar) ? car.unreserve_seat : car.unreserve_volume
            puts 'Car unloaded.'
          end
        end
      end

    when '16'
      print 'Enter train number to set company name: '
      number = gets.chomp

      train = trains.select { |t| t.number == number }.first
      if train
        print 'Enter company name: '
        cname = gets.to_s
        train.company_name = cname
      else
        puts 'Train not found.'
      end

    when '20'
      puts cars.map do |x|
        "#{x.object_id.to_s.rjust(15, ' ')}  #{x.status}"
      end

    when '21'
      block = proc { |x| "<< #{x.number} >>" }

      print 'Enter station name (from existing stations): '
      name1 = gets.chomp
      st1 = stations.select { |st| st.name == name1 }.first

      if st1
        puts "There is/are such trains at here: #{st1.bypass(&block)}!"
      else
        puts 'Bad station name. Check stations(see p. 11).i'
      end

    when '22'
      block = proc { |x| "<< #{x.object_id} >>" }

      print 'Enter train number (from existing trains): '
      number = gets.chomp

      train = trains.select { |t| t.number == number }.first
      if train.nil?
        puts 'Train not found.'
      else
        puts "There is/are such cars at here: #{train.bypass(&block)}!"
      end

    end
  rescue RuntimeError => e
    puts e.message
    puts 'Retry you choise with correct data.'
  rescue StandardError => e
    puts e
    puts e.backtrace
    break
  end

  puts
end
