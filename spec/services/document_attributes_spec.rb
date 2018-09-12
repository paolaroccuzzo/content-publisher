# frozen_string_literal: true

RSpec.describe DocumentAttributes do
  let(:schema) { build :document_type_schema, contents: [build(:field_schema, id: "field")] }
  let(:document) { create :document, document_type: schema.id }
  let(:path_generator_service) { double :path_generator, path: "path" }

  let(:params) do
    ActionController::Parameters.new(
      document: {
        title: "Title",
        summary: "Summary",
        update_type: "Update type",
        change_note: "Change note",
        not_allowed: "Not allowed",
        contents: {
          field: "Value",
          not_allowed: "Not allowed",
        },
      },
    )
  end

  subject { DocumentAttributes.new(document) }

  before do
    allow(PathGeneratorService).to receive(:new) { path_generator_service }
  end

  describe "#attributes" do
    let(:bad_title) { SecureRandom.hex(150) + "\r\n" + SecureRandom.hex(250) }
    let(:bad_summary) { SecureRandom.hex(450) + "\r\n" + SecureRandom.hex(250) }

    it "extracts the simple attributes of the document" do
      attributes = subject.attributes(params)
      expect(attributes[:title]).to eq "Title"
      expect(attributes[:summary]).to eq "Summary"
      expect(attributes[:update_type]).to eq "Update type"
      expect(attributes[:change_note]).to eq "Change note"
      expect(attributes[:not_allowed]).to be_nil
    end

    it "cleans and truncates the title so it's short" do
      params[:document][:title] = bad_title
      attributes = subject.attributes(params)
      expect(attributes[:title].chars.count).to eq DocumentAttributes::TITLE_MAX_LENGTH
      expect(attributes[:title].lines.count).to eq 1
    end

    it "cleans and truncates the summary so it's short" do
      params[:document][:summary] = bad_summary
      attributes = subject.attributes(params)
      expect(attributes[:summary].chars.count).to eq DocumentAttributes::SUMMARY_MAX_LENGTH
      expect(attributes[:summary].lines.count).to eq 1
    end

    it "cleans and truncates the base_path slug it's short" do
      params[:document][:title] = bad_title

      allow(path_generator_service).to receive(:path) do |_, title|
        expect(title.chars.count).to eq DocumentAttributes::TITLE_SLUG_MAX_LENGTH
        expect(title.lines.count).to eq 1
      end

      subject.attributes(params)
    end

    it "extracts the complex attributes of the document" do
      attributes = subject.attributes(params)
      expect(attributes[:contents]["field"]).to eq "Value"
      expect(attributes[:contents]["not_allowed"]).to be_nil
    end

    it "generates a base path for the document" do
      attributes = subject.attributes(params)
      expect(attributes[:base_path]).to eq "path"
    end
  end
end
