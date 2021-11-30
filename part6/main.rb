# frozen_string_literal: true

require_relative 'station'
require_relative 'route'
require_relative 'train'
require_relative 'van'
require_relative 'cargo_train'
require_relative 'cargo_van'
require_relative 'passenger_train'
require_relative 'passenger_van'

class Main
  OPTIONS = {
    '1' => 'create station',
    '2' => 'create train',
    '3' => 'create and edit route',
    '4' => 'set the train route',
    '5' => 'add a van to a train',
    '6' => 'remove a van from a train',
    '7' => 'move train',
    '8' => 'view station list and trains at the station',
    '9' => 'show all trains at all stations and all vans in trains',   # выводит то, что требуется в задании
    '10' => 'take seat or volume',
    'exit' => 'stop'
  }.freeze

  TRAIN_TYPES = {
    1 => 'passenger',
    2 => 'cargo'
  }.freeze

  def initialize
    @stations = [Station.new('s1'), Station.new('s2'), Station.new('s3'), Station.new('s11'), Station.new('st234')]
    @trains = [CargoTrain.new('D4F'), PassengerTrain.new('Y66-R4')]
    @routes = [Route.new(@stations[3], @stations[4]), Route.new(@stations[0], @stations[1])]
    v1 = CargoVan.new('v-123', 1000)
    v1.take_volume(20)
    v2 = CargoVan.new('va-451', 5000)
    [v1, v2].each { |v| @trains.first.add_van(v) }
    v3 = PassengerVan.new('rx-465', 60)
    v3.take_a_seat
    v4 = PassengerVan.new('k-066')
    [v3, v4].each { |v| @trains[1].add_van(v) }
    @trains.first.route = @routes[0]
    @trains[1].route = @routes[0]
    @vans = [v1, v2, v3, v4]
  end

  def main_content
    @program_end = false
    until @program_end
      show_options
      puts '-> '
      inp = gets.chomp
      @program_end = true if inp == 'exit'
      puts "\n#{OPTIONS[inp]}\n\n"
      case inp.to_i
      when 1
        create_station
      when 2
        create_train
      when 3
        modify_route
      when 4
        set_route
      when 5
        add_v
      when 6
        del_v
      when 7
        move
      when 8
        view
      when 9
        show_stations_trains_vans
      when 10
        take_seat_or_volume
      end
    end
  end

  private

  def show_options
    puts '\nChoose an option'
    OPTIONS.each { |key_value| puts "Type #{key_value[0]} to #{key_value[1]}" }
  end

  def create_station
    is_valid = false
    until is_valid
      begin
        puts 'Enter station name: '
        inp = gets.chomp
        s = Station.new(inp)
        is_valid = s.valid?
      rescue RuntimeError
        puts 'Incorrect. Try again!'
      end
    end
    @stations.push(s)
    puts "Station #{s.name} was created\n"
  end

  def create_train
    is_valid = false
    until is_valid
      begin
        puts 'Enter train number: '
        train_n = gets.chomp
        puts 'Choose the type: '
        correct_inp = false
        until correct_inp
          TRAIN_TYPES.each { |key_value| puts "Type #{key_value[0]} to choose #{key_value[1]}" }
          puts '->'
          train_t = gets.chomp
          type = nil
          type = 'p' if train_t.to_i == 1
          type = 'c' if train_t.to_i == 2
          correct_inp = true if type
        end
        train = CargoTrain.new(train_n) if type == 'c'
        train = PassengerTrain.new(train_n) if type == 'p'
        is_valid = train.valid?
      rescue RuntimeError
        puts 'Incorrect. Try again!'
      end
    end
    @trains.push(train)
    puts "Train #{train.number} was created"
  end

  def create_route
    puts 'Chose the start station (type the index of station) or the first one will be chosen'
    correct_inp = false
    until correct_inp
      @stations.each { |s| puts s.name }
      puts '-> '
      inp = gets.chomp
      start = nil
      start = @stations[inp.to_i]
      correct_inp = true if start
    end
    puts 'Chose the end station (type the index of station) or the first one will be chosen'
    correct_inp = false
    until correct_inp
      rest_stations = @stations.reject { |s| s == start }
      rest_stations.each { |s| puts s.name }
      puts '-> '
      inp = gets.chomp
      end_s = nil
      end_s = rest_stations[inp.to_i]
      correct_inp = true if rest_stations
    end
    @routes.push(Route.new(start, end_s))
    puts 'Route was created'
  end

  def add_s(r)
    aviable_stations = @stations.select { |s| s != r.stations.first && s != r.stations.last }
    puts 'Chose the station to add (type the index of station) or the first one will be chosen'
    correct_inp = false
    until correct_inp
      aviable_stations.each { |s| puts s.name }
      puts '-> '
      inp = gets.chomp
      s = nil
      s = aviable_stations[inp.to_i]
      correct_inp = true if s
    end
    r.add_station(s)
    puts 'Route was edited'
  end

  def del_s(r)
    aviable_stations = r.stations.select { |s| s != r.stations.first && s != r.stations.last }
    if aviable_stations.empty?
      puts 'Nothing to delete'
    elsif aviable_stations.size == 1
      r.delete_station(aviable_stations.first)
      puts 'Deleted'
    else
      puts 'Chose the station to delete (type the index of station) or the first one will be chosen'
      correct_inp = false
      until correct_inp
        aviable_stations.each { |s| puts s.name }
        puts '-> '
        inp = gets.chomp
        s = nil
        s = aviable_stations[inp.to_i]
        correct_inp = true if s
      end
      @routes.delete_station(s)
      puts 'done'
    end
  end

  def edit_route
    puts 'Chose the route to edit (type the index of route) or the first one will be chosen'
    correct_inp = false
    until correct_inp
      @routes.each { |r| puts "Route(#{r.stations.first.name}, #{r.stations.last.name})" }
      puts '-> '
      inp = gets.chomp
      r = nil
      r = @routes[inp.to_i]
      correct_inp = true if r
    end
    puts "You chose #{r}"
    puts 'What do you want?'
    correct_inp = false
    until correct_inp
      h = {
        1 => 'add station',
        2 => 'delete station'
      }
      h.each { |key_value| puts "Type #{key_value[0]} to #{key_value[1]}" }
      puts '-> '
      inp = gets.chomp
      action = nil
      action = 'add' if inp.to_i == 1
      action = 'del' if inp.to_i == 2
      correct_inp = true if action
    end
    add_s(r) if action == 'add'
    del_s(r) if action == 'del'
  end

  def modify_route
    puts 'What do you want?'
    correct_inp = false
    until correct_inp
      h = {
        1 => 'Create route',
        2 => 'Edit route'
      }
      h.each { |key_value| puts "Type #{key_value[0]} to choose #{key_value[1]}" }
      puts '-> '
      inp = gets.chomp
      action = nil
      action = 'create' if inp.to_i == 1
      action = 'edit' if inp.to_i == 2
      correct_inp = true if action
    end
    create_route if action == 'create'
    edit_route if action == 'edit'
  end

  def set_route
    puts 'Chose the train (type the index of train) or the first one will be chosen'
    correct_inp = false
    until correct_inp
      @trains.each { |t| puts t.number }
      puts '-> '
      inp = gets.chomp
      tr = nil
      tr = @trains[inp.to_i]
      correct_inp = true if tr
    end
    puts 'Chose the route (type the index of route) or the first one will be chosen'
    correct_inp = false
    until correct_inp
      @routes.each { |r| puts "Route(#{r.stations.first.name}, #{r.stations.last.name})" }
      puts '-> '
      inp = gets.chomp
      r = nil
      r = @routes[inp.to_i]
      correct_inp = true if r
    end
    tr.route = r
    puts 'Route was set'
  end

  def add_v
    puts 'Chose the train (type the index of train) or the first one will be chosen'
    correct_inp = false
    until correct_inp
      @trains.each { |t| puts t.number }
      puts '-> '
      inp = gets.chomp
      tr = nil
      tr = @trains[inp.to_i]
      correct_inp = true if tr
    end
    is_valid = false
    until is_valid
      begin
        puts 'Enter the van number:'
        n = gets.chomp
        if tr.type == :cargo
          puts 'Enter van volume:'
          v = gets.chomp
          van = CargoVan.new(n, v.to_i)
          tr.add_van(van)
        end
        if tr.type == :passenger
          puts 'Enter seats quantity:'
          s = gets.chomp
          van = PassengerVan.new(n, s.to_i)
          tr.add_van(van)
        end
        is_valid = true
      rescue RuntimeError
        puts 'Incorrect. Try again!'
      end
    end
    @vans.push(van)
    puts 'Van was added'
  end

  def del_v
    puts 'Chose the train (type the index of train) or the first one will be chosen'
    correct_inp = false
    until correct_inp
      @trains.each { |t| puts t.number }
      puts '-> '
      inp = gets.chomp
      tr = nil
      tr = @trains[inp.to_i]
      correct_inp = true if tr
    end
    if tr.vans.empty?
      puts 'Nothing to delete'
    elsif tr.vans.size == 1
      tr.del_van(tr.vans.first)
      puts 'Van was deleted'
    else
      puts 'Chose the van (type the index of van) or the first one will be chosen'
      correct_inp = false
      until correct_inp
        tr.vans.each { |v| puts v.number }
        puts '-> '
        inp = gets.chomp
        v = nil
        v = tr.vans[inp.to_i]
        correct_inp = true if v
      end
      tr.delete_van(v)
      puts 'Van was deleted'
    end
  end

  def move
    puts 'Chose the train (type the index of train) or the first one will be chosen'
    correct_inp = false
    until correct_inp
      @trains.each { |t| puts t.number }
      puts '-> '
      inp = gets.chomp
      tr = nil
      tr = @trains[inp.to_i]
      correct_inp = true if tr
    end
    if tr.route
      puts 'How to move?'
      correct_inp = false
      until correct_inp
        h = {
          1 => 'Forward',
          2 => 'Back'
        }
        h.each { |key_value| puts "Type #{key_value[0]} to choose #{key_value[1]}" }
        puts '-> '
        inp = gets.chomp
        action = nil
        action = 'forward' if inp.to_i == 1
        action = 'back' if inp.to_i == 2
        correct_inp = true if action
      end
      tr.move_forward if action == 'forward'
      tr.move_back if action == 'back'
    else
      puts 'Nowhere to move'
    end
  end

  def view
    @stations.each do |s|
      puts 'Station: '
      puts "#{s.name}\n"
      puts 'Train(s):' if s.train
      s.trains&.each { |t| puts t.number }
    end
  end

  def show_stations_trains_vans
    @stations.each do |station|
      puts "Station: #{station.name}"
      station.with_block do |train|
        puts "Train number: #{train.number}, train type: #{train.type}, van quantity: #{train.vans.size}"
        train.with_block do |van|
          if van.type == :passenger
            puts "Van number (in train): #{van.number_in_train}, van type: #{van.type}, free seats quantity: #{van.free_seats_q}, taken seats quantity: #{van.taken_seats_q}"
          end
        end
        train.with_block do |van|
          if van.type == :cargo
            puts "Van number (in train): #{van.number_in_train}, van type: #{van.type}, free volume: #{van.free_volume}, taken volume: #{van.taken_volume}"
          end
        end
      end
      puts "\n"
    end
  end

  def take_seat_or_volume
    puts 'Choose the van (type index of van, in case of incorrect index, the first one will be chosen)'
    @vans.each { |van| puts van.number }
    puts '-> '
    index = gets.chomp
    selected_van = @vans[index.to_i]
    selected_van ||= @vans[0]
    puts "Van #{selected_van.number} was chosen"
    if selected_van.type == :passenger
      selected_van.take_a_seat
      puts 'The seat was taken'
    else
      is_valid = false
      until is_valid
        puts 'Type volume to take'
        vol = gets.chomp
        puts '-> '
        begin
          is_valid = !selected_van.take_volume(vol.to_i).nil?
        rescue RuntimeError, ArgumentError
          puts 'Incorrect volume'
        end
      end
      puts 'Volume was taken'
    end
  end
end
