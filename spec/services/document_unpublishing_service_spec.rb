# frozen_string_literal: true

RSpec.describe DocumentUnpublishingService do
  describe "#retire" do
    let(:document) { create(:document) }
    let(:explanatory_note) { "The document is out of date" }

    it "withdraws a document in publishing-api with an explanatory note" do
      stub_publishing_api_unpublish(document.content_id, body: { type: "withdrawal", explanation: explanatory_note, locale: "en" })
      DocumentUnpublishingService.new.retire(document, explanatory_note)

      assert_publishing_api_unpublish(document.content_id, type: "withdrawal", explanation: explanatory_note, locale: "en")
    end

    it "does not delete assets for retired documents" do
      asset = create(:image, :in_asset_manager, document: document)

      stub_publishing_api_unpublish(document.content_id, body: { type: "withdrawal", explanation: explanatory_note, locale: "en" })
      DocumentUnpublishingService.new.retire(document, explanatory_note)

      assert_not_requested asset_manager_delete_asset(asset.asset_manager_id)
    end

    it "sets the locale of the document if specified" do
      stub_publishing_api_unpublish(document.content_id, body: { type: "withdrawal", explanation: explanatory_note, locale: "fr" })
      DocumentUnpublishingService.new.retire(document, explanatory_note, locale: "fr")

      assert_publishing_api_unpublish(document.content_id, type: "withdrawal", explanation: explanatory_note, locale: "fr")
    end
  end

  describe "#remove" do
    let(:document) { create(:document) }

    it "removes a document" do
      stub_publishing_api_unpublish(document.content_id, body: { type: "gone", locale: "en" })
      DocumentUnpublishingService.new.remove(document)

      assert_publishing_api_unpublish(document.content_id, type: "gone", locale: "en")
    end

    it "deletes assets associated with removed documents" do
      asset = create(:image, :in_asset_manager, document: document)
      stub_publishing_api_unpublish(document.content_id, body: { type: "gone", locale: "en" })
      asset_manager_request = asset_manager_delete_asset(asset.asset_manager_id)

      DocumentUnpublishingService.new.remove(document)

      assert_requested(asset_manager_request)
    end

    it "accepts an optional explanatory note" do
      explanatory_note = "The reason document has been removed"
      stub_publishing_api_unpublish(document.content_id, body: { type: "gone", explanation: explanatory_note, locale: "en" })
      DocumentUnpublishingService.new.remove(document, explanatory_note: explanatory_note)

      assert_publishing_api_unpublish(document.content_id, type: "gone", explanation: explanatory_note, locale: "en")
    end

    it "accepts an optional alternative path" do
      alternative_path = "/look-here-instead"
      stub_publishing_api_unpublish(document.content_id, body: { type: "gone", alternative_path: alternative_path, locale: "en" })
      DocumentUnpublishingService.new.remove(document, alternative_path: alternative_path)

      assert_publishing_api_unpublish(document.content_id, type: "gone", alternative_path: alternative_path, locale: "en")
    end

    it "sets the locale of the document if specified" do
      stub_publishing_api_unpublish(document.content_id, body: { type: "gone", locale: "fr" })
      DocumentUnpublishingService.new.remove(document, locale: "fr")

      assert_publishing_api_unpublish(document.content_id, type: "gone", locale: "fr")
    end
  end

  describe "#remove_and_redirect" do
    let(:document) { create(:document) }
    let(:redirect_path) { "/redirect-path" }

    it "removes documents with a redirect" do
      stub_publishing_api_unpublish(document.content_id, body: { type: "redirect", alternative_path: redirect_path, locale: "en" })
      DocumentUnpublishingService.new.remove_and_redirect(document, redirect_path)

      assert_publishing_api_unpublish(document.content_id, type: "redirect", alternative_path: redirect_path, locale: "en")
    end

    it "deletes assets associated with redirected documents" do
      asset = create(:image, :in_asset_manager, document: document)

      stub_publishing_api_unpublish(document.content_id, body: { type: "redirect", alternative_path: redirect_path, locale: "en" })
      asset_manager_request = asset_manager_delete_asset(asset.asset_manager_id)

      DocumentUnpublishingService.new.remove_and_redirect(document, redirect_path)

      assert_requested(asset_manager_request)
    end

    it "accepts an optional explanatory note" do
      explanatory_note = "The reason document has been removed"
      stub_publishing_api_unpublish(document.content_id, body: { type: "redirect", alternative_path: redirect_path, explanation: explanatory_note, locale: "en" })
      DocumentUnpublishingService.new.remove_and_redirect(document, redirect_path, explanatory_note: explanatory_note)

      assert_publishing_api_unpublish(document.content_id, type: "redirect", alternative_path: redirect_path, explanation: explanatory_note, locale: "en")
    end

    it "sets the locale of the document if specified" do
      stub_publishing_api_unpublish(document.content_id, body: { type: "redirect", alternative_path: redirect_path, locale: "fr" })
      DocumentUnpublishingService.new.remove_and_redirect(document, redirect_path, locale: "fr")

      assert_publishing_api_unpublish(document.content_id, type: "redirect", alternative_path: redirect_path, locale: "fr")
    end
  end
end