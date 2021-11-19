# frozen_string_literal: true

class Route
  attr_reader :stations # имеет начальную и конечную станцию, а также список промежуточных станций

  def initialize(start_station, end_station)
    # Начальная и конечная станции указываютсся при создании маршрута,
    # а промежуточные могут добавляться между ними
    @end_station = end_station
    @stations = [start_station, end_station]
  end

  def add_station(station)
    # может добавлять промежуточную станцию в список
    @stations[-1] = station
    @stations.push(@end_station)
  end

  def delete_station(station)
    # может удалять промежуточную станцию из списка
    unless [@stations.first, @stations.last].include?(station)  # если не начальная или конечная станция
      @stations.delete(station)
    end
  end
end
