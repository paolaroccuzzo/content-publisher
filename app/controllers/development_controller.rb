# frozen_string_literal: true

class DevelopmentController < ApplicationController
  def form
    @form = FormatForm.new(params[:document_type] || "press_release")
  end

  class FormatForm
    attr_reader :document_type, :config

    def initialize(document_type)
      @document_type = document_type
      @config = YAML.load_file("config/formats.yml").find { |format| format["document_type"] == document_type }
    end
  end
end
