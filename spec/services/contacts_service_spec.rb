# frozen_string_literal: true

RSpec.describe ContactsService do
  describe "#by_content_id" do
    context "when a contact is found" do
      it "returns the contact" do
        content_id = SecureRandom.uuid
        editions = [ { "content_id" => content_id, "locale" => "en", "title" => "Clark Kent" } ]
        publishing_api_get_editions(editions, ContactsService::EDITION_PARAMS)

        expect(ContactsService.new.by_content_id(content_id)).to eq(editions.first)
      end
    end

    context "when a contact is not found" do
      it "returns nil" do
        publishing_api_get_editions([], ContactsService::EDITION_PARAMS)
        expect(ContactsService.new.by_content_id(SecureRandom.uuid)).to be_nil
      end
    end
  end

  describe "#all_by_organisation" do
    context "when there are organisations with contacts" do
      it "returns each organisation with their contacts" do
        org_1 = { "content_id" => SecureRandom.uuid, "internal_name" => "Org 1" }
        org_2 = { "content_id" => SecureRandom.uuid, "internal_name" => "Org 2" }
        publishing_api_has_linkables([org_1, org_2], document_type: "organisation")

        org_1_contacts = [
          { "content_id" => SecureRandom.uuid, "locale" => "en", "title" => "Contact 1", "links" => { "organisations" => [org_1["content_id"]] } },
          { "content_id" => SecureRandom.uuid, "locale" => "en", "title" => "Contact 2", "links" => { "organisations" => [org_1["content_id"]] } },
        ]
        org_2_contacts = [
          { "content_id" => SecureRandom.uuid, "locale" => "en", "title" => "Contact 3", "links" => { "organisations" => [org_2["content_id"]] } },
        ]
        publishing_api_get_editions(org_1_contacts + org_2_contacts, ContactsService::EDITION_PARAMS)

        expect(ContactsService.new.all_by_organisation).to match([
          { "name" => org_1["internal_name"], "content_id" => org_1["content_id"], "contacts" => org_1_contacts },
          { "name" => org_2["internal_name"], "content_id" => org_2["content_id"], "contacts" => org_2_contacts },
        ])
      end
    end

    context "when there are organisations without contacts" do
      it "returns them despite their lack of contacts" do
        org_1 = { "content_id" => SecureRandom.uuid, "internal_name" => "Org 1" }
        publishing_api_has_linkables([org_1], document_type: "organisation")

        publishing_api_get_editions([], ContactsService::EDITION_PARAMS)

        expect(ContactsService.new.all_by_organisation).to match([
          { "name" => org_1["internal_name"], "content_id" => org_1["content_id"], "contacts" => [] },
        ])
      end
    end

    context "when there are no organisations" do
      it "returns an empty array" do
        publishing_api_has_linkables([], document_type: "organisation")
        publishing_api_get_editions([], ContactsService::EDITION_PARAMS)
        expect(ContactsService.new.all_by_organisation).to eql([])
      end
    end
  end
end
