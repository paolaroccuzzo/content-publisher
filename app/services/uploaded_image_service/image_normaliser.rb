# frozen_string_literal: true

require "mini_magick"

class UploadedImageService::ImageNormaliser
  attr_reader :image, :output

  def initialize(image_path)
    @image = MiniMagick::Image.open(image_path)
    @output = Tempfile.new
  end

  def dimensions
    if %w[RightTop LeftBottom].include?(image["%[orientation]"])
      { width: image.height, height: image.width }
    else
      { width: image.width, height: image.height }
    end
  end

  def normalise
    image.combine_options do |file|
      # apply any orientation specified as exif data
      file.auto_orient

      # remove exif data as this may reveal more than publishers expect
      file.strip
    end

    image.write output.path
    output
  end
end
