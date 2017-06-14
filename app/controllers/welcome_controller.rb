class WelcomeController < ApplicationController
  def index
    flash[:notice] = "good morning ! Hosyo!"
  end
end
