# frozen_string_literal: true

require 'spec_helper'

RSpec.describe HyperDocument, type: :model do
  it "it updates the JSON" do
    document = HyperDocument.create!(
      content_id: SecureRandom.uuid,
      locale: "en",
      document_type: "press_release",
      state: "draft-never-published",
      current_edition_number: 1,
    )

    expect(document.contents).to eql({})

    document.update!(
      contents: {
        body: "Heyo yolo",
      }
    )

    expect(document.contents).to eql(
      "body" => "Heyo yolo"
    )
  end
end
