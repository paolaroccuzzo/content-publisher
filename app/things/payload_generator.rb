# frozen_string_literal: true

class PayloadGenerator
  def self.generate(document)
    {
      base_path: document.base_path,
      title: document.title,
      schema_name: "news_article",
      document_type: document.document_type,
      publishing_app: "email-alert-frontend", # FIX
      rendering_app: "government-frontend",
      details: {
        body: "Hello!",
        first_public_at: Time.now.iso8601,
        government: {
          title: "Hey", slug: "what", current: true,
        },
        political: false,
      },
      routes: [
        { path: document.base_path, type: "exact" }
      ]
    }
  end
end

class DocumentUpdater
  def self.update(document, edits)
    document.update!(edits.merge(state: "unpublished-edits"))
  end
end

class SaveToThePublishingApiAsDraftBackgroundWorker
  def self.save(document)
    raise unless document.ready_for_publishing_api?
    # Send it to the publishing-api
    document.update!(state: "as-draft-in-publishing-api")
  end
end

class ActualPublisher
  def self.publish_it(document)
    document.update!(
      current_edition_number: document.current_edition_number + 1,
      state: "being-published-to-live",
    )

    # Send `/publish` to the publishing-api

    document.update!(
      state: "live-in-publishing-api"
    )
  end
end
