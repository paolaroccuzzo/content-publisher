# frozen_string_literal: true

class DocumentsController < ApplicationController
  def index
    @documents = Document.all
  end

  def edit
    @document = Document.find(params[:id])
  end

  def update
    ActionCable.server.broadcast("updates:#{params[:id]}", message: "Saving document...")
    document = Document.find(params[:id])
    document.update_attributes(document_update_params)
    ActionCable.server.broadcast("updates:#{params[:id]}", message: "Document live")
    redirect_to edit_document_path(document)
  end

private

  def document_update_params
    params.require(:document).permit(:title)
  end
end
