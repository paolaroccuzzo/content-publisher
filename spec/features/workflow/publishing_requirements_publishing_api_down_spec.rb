# frozen_string_literal: true

RSpec.feature "Publishing requirements when the Publishing API is down" do
  include TopicsHelper

  scenario do
    given_there_is_a_document
    when_the_publishing_api_is_down
    then_i_do_not_see_warnings_that_require_it

    when_i_try_to_publish_the_document
    then_i_see_an_error_to_prevent_publishing

    when_i_try_to_submit_the_document_for_2i
    then_i_see_an_error_to_prevent_submission
  end

  def given_there_is_a_document
    document_type_schema = build(:document_type_schema, topics: true)
    @document = create(:document, :in_preview, document_type: document_type_schema.id)
  end

  def when_the_publishing_api_is_down
    publishing_api_isnt_available
    visit document_path(@document)
  end

  def then_i_do_not_see_warnings_that_require_it
    within(".app-c-notice") do
      expect(page).to_not have_content(I18n.t!("requirements.topics.none.summary_message"))
      expect(page).to have_content(I18n.t!("requirements.summary.blank.summary_message"))
    end
  end

  def when_i_try_to_publish_the_document
    click_on "Publish"
  end

  def when_i_try_to_submit_the_document_for_2i
    click_on "Submit for 2i review"
  end

  def then_i_see_an_error_to_prevent_publishing
    expect(page).to have_content(I18n.t!("documents.show.flashes.publish_error.title"))
  end

  def then_i_see_an_error_to_prevent_submission
    expect(page).to have_content(I18n.t!("documents.show.flashes.2i_error.title"))
  end
end
