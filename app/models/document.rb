# frozen_string_literal: true

class Document < ApplicationRecord
  def base_path
    "/foo"
  end

  def description
    "Hela hola yolo bolo"
  end
end
