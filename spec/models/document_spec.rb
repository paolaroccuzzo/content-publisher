# frozen_string_literal: true

RSpec.describe Document do
  describe "PUBLICATION_STATES" do
    it "has correct translations for each state" do
      Document::PUBLICATION_STATES.each do |state|
        I18n.t!("publication_states.#{state}.name")
        I18n.t!("publication_states.#{state}.description")
      end
    end
  end
end
