class PreviewController < ApplicationController
  def show
    @document = Document.find(params[:id])
    @url = Plek.new.find('draft-origin') + @document.base_path
  end
end
