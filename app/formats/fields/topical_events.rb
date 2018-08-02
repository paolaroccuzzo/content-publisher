module Fields
  class TopicalEvents
    def type
      "topical_events"
    end

    def id
      "topical_events"
    end

    def label
      "Topical Events"
    end

    def validations
      []
    end

    def select_options
      linkables_service.select_options
    end

    def input_to_record(value)
      value.to_a.map do |content_id|
        linkable = linkables_service.by_content_id(content_id)
        next unless linkable
        { "content_id" => content_id, "name" => linkable["internal_name"] }
      end.compact
    end

    def form_value(value)
      value.to_a.map { |i| i["content_id"] }
    end

    def show_value(value)
      value.to_a.map do |link|
        linkable = linkables_service.by_content_id(link["content_id"])
        {
          "content_id" => link["content_id"],
          "name" => linkable ? linkable["internal_name"] : link["name"],
          "exists" => linkable.present?
        }
      end
    end

    def publishing_api_value(value)
      value.to_a.map { |i| i["content_id"] }
    end

    def permit
      { id => [] }
    end

  private

    def linkables_service
      @linkables_service ||= LinkablesService.new("topical_event")
    end
  end
end
