# frozen_string_literal: true

class HyperDocument < ApplicationRecord
  validates_presence_of :content_id
  validates_presence_of :locale
  has_paper_trail

  def ready_for_publishing_api?
    title && base_path && document_type
  end
end
