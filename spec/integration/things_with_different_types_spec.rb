# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Things that have different types", type: :feature do
  scenario "User creates a document" do
    document = Document.create!(document_type: "press_release")

    # We need a body for a press_release
    expect(DocumentValidator.new(document).valid?).to eql(false)

    form_input = {
      title: "Hela",
      contents: {
        body: "A great body text",
        political: true,
      }
    }

    document.update(form_input)

    # We need a body for a press_release
    expect(DocumentValidator.new(document).valid?).to eql(true)

    # Send to publishing api

    GeneratePayload.new(document).payload
  end
end

class GeneratePayload
  def payload
    config = YAML.load_file("config/document_types.yml")
    schema = config.find { |s| s["document_type"] == document.document_type }

    # now has a body
    details = document.contents.merge(
      first_public_at: Time.now.iso8601,
      political: contents["government"].present?
    )

    {
      base_path: document.base_path,
      title: document.title,
      schema_name: schema["schema_name"],
      document_type: document.document_type,
      publishing_app: "content-publisher",
      rendering_app: "government-frontend",
      details: details,
      routes: [
        { path: document.base_path, type: "exact" }
      ]
    }
  end
end

class DocumentValidator
  attr_reader :errors

  def initialize(document)
    @document = document
    @errors = []
  end

  def valid?
    config = YAML.load_file("config/document_types.yml")
    schema = config.find { |s| s["document_type"] == document.document_type }
    fields.each do |field|
      if field["required"] && document.contents[field["id"]].blank?
        @errors << "#{field["id"]} is required! Edit this in <a href=''>here</a>"
      end

      if field["type"] == "date" && document.contents[field["id"]].is_not_a_date_and_not_nil_or_empty?
        @errors << "#{field["id"]} is not a date mate"
      end
    end

    @errors.any?
  end
end
