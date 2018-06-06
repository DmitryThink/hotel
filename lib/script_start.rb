class ScriptStart
  def initialize
    @room = Room.create!(number: 20, number_of_people: 3, type_of_room: "standart")
  end
end