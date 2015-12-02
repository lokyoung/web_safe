class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @announces = Announce.paginate(page: params[:page])
    end
  end

  def about
  end

  def help
  end
end
