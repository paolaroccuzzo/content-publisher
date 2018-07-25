# frozen_string_literal: true

require 'gds_api/publishing_api_v2'

class LinkablesService
  def linkables(document_type)
    publishing_api.get_linkables(document_type: document_type).to_hash.map do |linkable|
      [linkable['title'], linkable['content_id']]
    end
  end

private

  def publishing_api
    GdsApi::PublishingApiV2.new(
      Plek.new.find('publishing-api'),
      disable_cache: true,
      bearer_token: ENV['PUBLISHING_API_BEARER_TOKEN'] || 'example',
    )
  end
end
