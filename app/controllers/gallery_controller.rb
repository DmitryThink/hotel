class GalleryController < BaseController
  before_action :click
  def index
    render :'gallery-grid-3'
  end
end