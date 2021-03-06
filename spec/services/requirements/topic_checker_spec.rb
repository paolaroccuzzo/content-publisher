# frozen_string_literal: true

RSpec.describe Requirements::TopicChecker do
  include TopicsHelper

  describe "#pre_publish_issues" do
    it "returns no issues if there are none" do
      document = build :document, :publishable
      issues = Requirements::TopicChecker.new(document).pre_publish_issues
      expect(issues.items).to be_empty
    end

    context "when the Publishing API is available" do
      let(:schema) { build :document_type_schema, topics: true }
      let(:document) { build :document, document_type: schema.id }

      before do
        publishing_api_has_links(
          "content_id" => document.content_id,
          "links" => {},
          "version" => 3,
        )

        publishing_api_has_taxonomy
      end

      it "returns an issue if there are no topics" do
        issues = Requirements::TopicChecker.new(document).pre_publish_issues

        form_message = issues.items_for(:topics).first[:text]
        expect(form_message).to eq(I18n.t!("requirements.topics.none.form_message"))

        summary_message = issues.items_for(:topics, style: "summary").first[:text]
        expect(summary_message).to eq(I18n.t!("requirements.topics.none.summary_message"))
      end
    end

    context "when the Publishing API is down" do
      let(:schema) { build :document_type_schema, topics: true }
      let(:document) { build :document, document_type: schema.id }

      before do
        publishing_api_isnt_available
      end

      it "returns no issues by default (ignore exception)" do
        issues = Requirements::TopicChecker.new(document).pre_publish_issues
        expect(issues.items_for(:topics)).to be_empty
      end

      it "raises an exception if we specify it should" do
        expect { Requirements::TopicChecker.new(document).pre_publish_issues(rescue_api_errors: false) }
          .to raise_error GdsApi::BaseError
      end
    end
  end
end
