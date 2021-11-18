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
    self.current.add_train(self)
  end

  # может перемещаться вперед
  def move_forward
    if self.next # то есть поезд не на конечной станции
      self.current.send(self)
      @current_station_index += 1
      self.current.add_train(self)
    end
  end

  # может перемещаться назад
  def move_back
    if self.prev # то есть поезд не на начальной станции
      self.current.send(self)
      @current_station_index -= 1
      self.current.add_train(self)
    end
  end

  # предыдущая станция
  def prev
    if @current_station_index > 0 && @route
      @route.stations[@current_station_index-1]
    end
  end

  # текущая станция
  def current
    if @route
      @route.stations[@current_station_index]
    end
  end

  # следующая станция
  def next 
    if @current_station_index < (@route.stations.size - 1) && @route
      @route.stations[@current_station_index+1]
    end
  end

end