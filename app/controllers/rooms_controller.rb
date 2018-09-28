class RoomsController < BaseController
  before_action :click
  def index; end

  Room.all.each do |room|
    define_method(room.name) do
      @room = room
      render :room
    end
  end
end
