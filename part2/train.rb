class Train

  attr_reader :number, :type, :van_q, :speed, :route   # может возвращать текущую скорость, кол-во вагонов

  # имеет номер (произвольная строка) и тип (грузовой, пассажирский) 
  # и количество вагонов, эти данные указываются при создании экземпляра класса
  def initialize(number, type, van_q=0)
    @number = number
    @type = type
    @van_q = van_q
    @speed = 0
    @current_station_index = nil
  end

  # может набирать скорость
  def increase_speed
    @speed += 10
  end

  # может тормозить (сбрасывать скорость до нуля)
  def stop
    @speed = 0
  end

  # может прицеплять вагоны
  def add_van
    if @speed == 0   # можно только если поезд не движется
      @van_q += 1
    end
  end

  # может отцеплять вагоны
  def del_van
    if @speed == 0 && @van_q > 0   # можно только если поезд не движется (и кол-во вагонов > 0, иначе нечего отцеплять)
      @van_q -= 1
    end
  end

  # может принимать маршрут следования (объект класса Route)
  def route=(route)
    @route = route
    # при назначении маршрута поезду, поезд автоматически помещается на первую станцию в маршруте
    @current_station_index = 0
    @route.all_stations[@current_station_index].add_train(self)
  end

  # может перемещаться вперед
  def move_forward
    if @current_station_index < (@route.all_stations.size - 1) # то есть поезд не на конечной станции
      @route.all_stations[@current_station_index].send(self)
      @current_station_index += 1
      @route.all_stations[@current_station_index].add_train(self)
    end
  end

  # может перемещаться назад
  def move_back
    if @current_station_index > 0 # то есть поезд не на начальной станции
      @route.all_stations[@current_station_index].send(self)
      @current_station_index -= 1
      @route.all_stations[@current_station_index].add_train(self)
    end
  end

  # возвращать предыдущую станцию, текущую, следующую, на основе маршрута
  def prev_curr_next
    if @current_station_index > 0
      puts "Предыдущая станция: #{@route.all_stations[@current_station_index-1].name}"
    end
    puts "Текущая станция: #{@route.all_stations[@current_station_index].name}"
    if @current_station_index < (@route.all_stations.size - 1)
      puts "Следующая станция: #{@route.all_stations[@current_station_index+1].name}"
    end
  end

end