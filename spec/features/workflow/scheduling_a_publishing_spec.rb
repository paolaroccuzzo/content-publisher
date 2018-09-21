# frozen_string_literal: true

RSpec.feature "Scheduled publishing" do
  include ActiveSupport::Testing::TimeHelpers

  scenario "User schedules a document" do
    given_there_is_a_document_in_draft

    when_i_visit_the_document
    and_i_click_schedule_document
    and_i_choose_a_date_and_time_for_publishing
    then_the_document_should_look_scheduled

    when_the_scheduled_time_arrives
    then_the_document_is_published
  end

  def given_there_is_a_document_in_draft
    @document = create(:document, publication_state: "sent_to_draft")
  end

  def when_i_visit_the_document
    visit document_path(@document)
  end

  def and_i_click_schedule_document
    click_on "Schedule"
  end

  def and_i_choose_a_date_and_time_for_publishing
    select "2019", from: "document[scheduled_at(1i)]"
    select "March", from: "document[scheduled_at(2i)]"
    select "1", from: "document[scheduled_at(3i)]"
    select "12", from: "document[scheduled_at(4i)]"
    select "12", from: "document[scheduled_at(5i)]"

    click_on "Schedule"
  end

  def then_the_document_should_look_scheduled
    expect(page).to have_content("Scheduled to be published")
  end

  def when_the_scheduled_time_arrives
    stub_any_publishing_api_publish

    travel_to(Date.today + 1.year) do
      ScheduledPublisher.run
    end
  end

  def then_the_document_is_published
    expect(@document.reload.scheduled_at).to be_nil
  end
end
