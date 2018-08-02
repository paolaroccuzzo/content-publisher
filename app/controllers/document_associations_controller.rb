# frozen_string_literal: true

class DocumentAssociationsController < ApplicationController
  def edit
    @document = Document.find(params[:id])
  end

  def update
    @document = Document.find(params[:id])
    @document.update(associations: updated_associations)
    DocumentPublishingService.new.publish_draft(@document)
    redirect_to @document, notice: "Preview creation successful"
  rescue GdsApi::HTTPErrorResponse, SocketError => e
    Rails.logger.error(e)
    redirect_to @document, alert: "Error creating preview"
  end

private

  def update_params
    permit = @document.document_type_schema.associations.map { |a| a.permit }
    params.fetch(:associations, {}).permit(*permit)
  end

  def updated_associations
    @document.document_type_schema.associations.each_with_object({}) do |field, memo|
      memo[field.id] = field.input_to_record(update_params[field.id])
    end
  end
end
