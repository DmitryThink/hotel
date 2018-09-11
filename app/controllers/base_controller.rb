class BaseController < ApplicationController
  before_action :click

  def click
    Click.create!(location: self._prefixes.first)
  end
end