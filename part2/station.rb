class Station

  attr_reader :name, :trains  # возвращает имя и список всех поездов на станции, находящиеся в текущий момент

  def initialize(name)   # название станции указывается при создании
    @name = name
    @trains = []
  end

  def add_train(train)   # принимает поезда (по одному за раз)
    @trains.push(train)
  end

  # отправлять поезда по одному за раз
  def send(train)
    @trains.delete(train)
  end

  # возвращать список поездов по типу
  def by_type(type_to_find)
    @trains.each {|t| puts t.number if type_to_find.eql?(t.type)}
  end

end