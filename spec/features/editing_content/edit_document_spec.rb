# frozen_string_literal: true

RSpec.feature "Edit a document" do
  scenario do
    given_there_is_a_document
    when_i_go_to_edit_the_document
    and_i_fill_in_the_content_fields

    then_i_see_the_document_is_saved
    and_the_preview_creation_succeeded
    and_i_see_i_was_the_last_user_to_edit_the_document
  end

  def given_there_is_a_document
    body_field_schema = build(:field_schema, id: "body", type: "govspeak")
    document_type_schema = build(:document_type_schema, contents: [body_field_schema])
    contents = { body: "Existing body" }
    create(:document, document_type: document_type_schema.id, contents: contents)
  end

  def when_i_go_to_edit_the_document
    visit document_path(Document.last)
    expect(page).to have_content("Existing body")
    click_on "Change Content"
  end

  def and_i_fill_in_the_content_fields
    fill_in "document[contents][body]", with: "Edited body."
    stub_publishing_api_put_content(Document.last.content_id, {})
    click_on "Save"
  end

  def then_i_see_the_document_is_saved
    expect(page).to have_content("Edited body.")

    within find(".app-timeline-entry:first") do
      expect(page).to have_content I18n.t!("documents.history.entry_types.updated_content")
    end
  end

  def and_the_preview_creation_succeeded
    expect(page).to have_content(I18n.t!("user_facing_states.draft.name"))

    expect(a_request(:put, /content/).with { |req|
      expect(JSON.parse(req.body)["details"]["body"]).to eq("<p>Edited body.</p>\n")
    }).to have_been_requested
  end

  def and_i_see_i_was_the_last_user_to_edit_the_document
    expect(page).to have_content(I18n.t!("documents.show.metadata.last_edited_by") + ": #{User.last.name}")
  end
end
