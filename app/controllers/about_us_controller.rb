class AboutUsController < BaseController
  before_action :click
  def index
    render :about
  end
end