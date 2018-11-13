# frozen_string_literal: true

class ContactsController < ApplicationController
  rescue_from GdsApi::BaseError do |e|
    Rails.logger.error(e)
    render "#{action_name}_api_down", status: :service_unavailable
  end

  def by_organisation
    @organisations = ContactsService.new.all_by_organisation
  end

  def show_organisation
    @organisation = ContactsService.new.all_by_organisation.find do |org|
      org["content_id"] == params[:organisation_id]
    end

    raise ActionController::RoutingError, "Not Found" unless @organisation
  end
end
