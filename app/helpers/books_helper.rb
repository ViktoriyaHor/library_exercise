module BooksHelper
  def form_for_new?
    params[:action] == 'new'
  end
end
