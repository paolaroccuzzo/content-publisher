# frozen_string_literal: true

require 'spec_helper'
require 'govuk_schemas/rspec_matchers'

RSpec.describe HyperDocument, type: :model do
  it "works" do
    # A user clicks on the "New button" and selects a formats.
    # This creates an initial document
    document = HyperDocument.create!(
      # Required for database
      content_id: SecureRandom.uuid,
      locale: "en",
      # Doesn't really make sense to do something without a document type.
      document_type: "press_release",
      # Things that can be defaulted
      state: "draft-never-published",
      current_edition_number: 1,
    )

    # At this point, we'll have something in the database. But it can't be sent
    # to the publishing api yet, because it would not validate.
    expect(document.ready_for_publishing_api?).to be_falsy

    # As evidenced by the schema test
    payload = PayloadGenerator.generate(document)
    expect(payload).not_to be_valid_against_schema("news_article")

    # But when we update the document with the required fields (in reality there
    # are probably more required fields like the body).
    DocumentUpdater.update(
      document,
      title: "The first title",
      base_path: "/test-news-article",
    )

    # Now it validates against the schema!
    payload = PayloadGenerator.generate(document)
    expect(payload).to be_valid_against_schema("news_article")

    # And can be sent to publishing-api.
    expect(document.ready_for_publishing_api?).to be_truthy

    # So when we send it to the publishing-api (as draft)
    SaveToThePublishingApiAsDraftBackgroundWorker.save(document)

    # The state will be kind of "synced" with the draft publishing-api.
    # The document will be previewable on the draft stack.
    expect(document.state).to eql("as-draft-in-publishing-api")

    # No document is finished all at once, so the user goes to the document
    # and edits the title
    DocumentUpdater.update(document, title: "The second title")

    # Then the state indicates that it's not yet synced with draft. Sidekiq
    # does this in the background.
    expect(document.state).to eql("unpublished-edits")

    # So when we send it to the publishing-api (as draft)
    SaveToThePublishingApiAsDraftBackgroundWorker.save(document)

    # The state will be kind of "synced" again
    expect(document.state).to eql("as-draft-in-publishing-api")

    # Now somebody can review this document on draft/preview. The user gets
    # a 2i approve, and they press "publish".
    ActualPublisher.publish_it(document)

    # Then the state goes to "live".
    expect(document.state).to eql("live-in-publishing-api")

    # Because we've published it, we'll consider this a new "edition" from now on.
    expect(document.current_edition_number).to eql(2)

    # By now, all the changes have created 7 versions
    expect(document.versions.size).to eql(7)

    # So, the user can now see the history of the HyperDocument, for example
    # that the 4th update to the document changed the title.
    expect(document.versions[3].changeset["title"]).to eql(
      ["The first title", "The second title"]
    )

    # Maybe that title was better actually, so the publisher chooses to restore
    # that version. We'll call the papertrail method `reify` to get to those attributes.
    older_better_version = document.versions[3].reify

    # We restore title (we can do other attributes too later)
    document.update!(title: older_better_version.title)

    # This changes the title
    expect(document.versions.last.changeset["title"]).to eql(["The second title", "The first title"])
    expect(document.title).to eql("The first title")
  end
end
