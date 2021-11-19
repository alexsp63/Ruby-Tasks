# frozen_string_literal: true
# require_relative 'station'
# require_relative 'route'
# require_relative 'train'
# require_relative 'van'
# require_relative 'cargo_train'
# require_relative 'cargo_van'
# require_relative 'passenger_train'
# require_relative 'passenger_van'

# s1 = Station.new("first")
# s2 = Station.new("2nd")
# s3 = Station.new("3rd")
# s4 = Station.new("last")

# route = Route.new(s1, s4)
# route.add_station(s2)
# route.add_station(s3)

# p_train = PassengerTrain.new(123)
# p_train.route = route

# c_train = CargoTrain.new(456)
# c_train.route = route

# puts p_train.current.name
# puts c_train.current.name

# s1.trains {|t| puts t.number}
# s2.trains {|t| puts t.number}

# puts s1.by_type(:passenger)
# puts s1.by_type(:cargo)

# van_p = PassengerVan.new(1)
# van_c = CargoVan.new(2)

# p_train.add_van(van_c)
# c_train.add_van(van_p)

# p_train.add_van(van_p)
# c_train.add_van(van_c)
# c_train.add_van(van_c)

# puts p_train.vans
# puts c_train.vans

# p_train.move_forward

# puts !!!
# puts s1.trains
# puts s2.trains
