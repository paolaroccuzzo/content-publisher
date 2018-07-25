# frozen_string_literal: true

require 'gds_api/publishing_api_v2'

class DocumentPublishingService
  PUBLISHING_APP = "content-publisher"

  def publish_draft(document)
    publishing_api.put_content(document.content_id, payload(document))
  end

  def publish(document)
    Document.transaction do
      unless document.first_public_at
        document.update!(first_public_at: Time.zone.now)
        publishing_api.put_content(document.content_id, payload(document))
      end

      publishing_api.publish(document.content_id, "major")
    end
  end

private

  def payload(document)
    {
      base_path: document.base_path,
      title: document.title,
      schema_name: document.document_type_schema.schema_name,
      document_type: document.document_type,
      publishing_app: PUBLISHING_APP,
      rendering_app: document.document_type_schema.rendering_app,
      details: document.contents.merge(first_public_at: (document.first_public_at || Time.zone.now),
                                       government: {
                                         title: "Hey", slug: "what", current: true,
                                       },
                                       political: false),
      routes: [
        { path: document.base_path, type: "exact" },
      ]
    }
  end

  def publishing_api
    GdsApi::PublishingApiV2.new(
      Plek.new.find('publishing-api'),
      disable_cache: true,
      bearer_token: ENV['PUBLISHING_API_BEARER_TOKEN'] || 'example',
    )
  end
end
