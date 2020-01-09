# frozen_string_literal: true

module BooksHelper

  def form_for_new?
    params[:action] == 'new'
  end

  def convert_time(time)
    if time
      time.strftime('%Y %m %d %H:%M')
    else
      'book on hand'
    end
  end
end
