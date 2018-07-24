# spec/features/action_cable_feature_spec.rb

require 'spec_helper'

RSpec.feature "Live updating", type: :feature do
  it "Status is updated without a refresh", js: true do
    given_there_is_a_document
    and_visit_the_edit_page
    when_the_document_is_updated_in_another_window
    then_i_see_that_the_document_is_updated
  end

  def given_there_is_a_document
    @document = Document.create! content_id: SecureRandom.uuid, locale: "en"
  end

  def and_visit_the_edit_page
    visit edit_document_path(@document)
  end

  def when_the_document_is_updated_in_another_window
    new_window = open_new_window

    within_window new_window do
      visit edit_document_path(@document)
      fill_in "document[title]", with: "Another great title"
      click_on "Save"
    end
  end

  def then_i_see_that_the_document_is_updated
    switch_to_window(windows.first)
    expect(page).to have_text("DOCUMENT LIVE")
  end
end
