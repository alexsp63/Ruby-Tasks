class Route

  attr_reader :start_station, :end_station, :stations # имеет начальную и конечную станцию, а также список промежуточных станций

  def initialize(start_station, end_station)
    # Начальная и конечная станции указываютсся при создании маршрута, 
    # а промежуточные могут добавляться между ними
    @start_station = start_station
    @end_station = end_station
    @stations = [@start_station, @end_station]
  end

  def add_station(station)
    # может добавлять промежуточную станцию в список
    @stations[-1] = station
    @stations.push(@end_station)
  end

  def delete_station(station)
    # может удалять промежуточную станцию из списка
    if ![0, @stations.size-1].include?(@stations.index(station))  # если не начальная или конечная станция
      @stations.delete(station)
    end
  end

end