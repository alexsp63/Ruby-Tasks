class Route

  attr_reader :start_station, :end_station, :stations # имеет начальную и конечную станцию, а также список промежуточных станций

  def initialize(start_station, end_station)
    # Начальная и конечная станции указываютсся при создании маршрута, 
    # а промежуточные могут добавляться между ними
    @start_station = start_station
    @end_station = end_station
    @stations = []
  end

  def add_station(station)
    # может добавлять промежуточную станцию в список
    @stations.push(station)
  end

  def delete_station(station)
    # может удалять промежуточную станцию из списка
    @stations.delete(station)
  end

  def all_stations
    # может выводить список всех станций по-порядку от начальной до конечной
    @all_stations = []
    @all_stations.push(@start_station)
    @all_stations += @stations
    @all_stations.push(@end_station)
  end

end