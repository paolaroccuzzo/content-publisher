# frozen_string_literal: true

class ImageCollectionValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.is_a?(Array)
      record.errors[attribute] << "is not an array"
      return
    end

    value.each { |image| check_valid_image(record, attribute, image) }
  end

  def check_valid_image(record, attribute, image)
    unless image.is_a?(Hash)
      record.errors[attribute] << "contains non objects"
      return
    end
  end
end
