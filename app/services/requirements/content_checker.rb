# frozen_string_literal: true

module Requirements
  class ContentChecker
    TITLE_MAX_LENGTH = 150

    attr_reader :document

    def initialize(document)
      @document = document
    end

    def pre_preview_issues
      issues = []

      if document.title.blank?
        issues << Issue.new(:title, :blank)
      end

      if document.title.to_s.size > TITLE_MAX_LENGTH
        issues << Issue.new(:title, :too_long, max_length: TITLE_MAX_LENGTH)
      end

      if document.title.to_s.lines.count > 1
        issues << Issue.new(:title, :multiline)
      end

      CheckerIssues.new(issues)
    end

    def pre_publish_issues
      issues = []

      if document.summary.blank?
        issues << Issue.new(:summary, :blank)
      end

      document.document_type_schema.contents.each do |field|
        if document.contents[field.id].blank?
          issues << Issue.new(field.id, :blank)
        end
      end

      if document.has_live_version_on_govuk && document.update_type == "major" && document.change_note.blank?
        issues << Issue.new(:change_note, :blank)
      end

      CheckerIssues.new(issues)
    end
  end
end
