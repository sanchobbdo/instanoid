require 'open-uri'

PRAWN_DEFAULT_TPL = lambda { |pdf, data|

  # Vars
  image_path = 'tmp/prawn_default_tpl_image.jpg'

  # Download image
  open(data.images.standard_resolution.url) do |image|
    File.open(image_path, 'w') { |f| f.write(image.read) }
  end

  # Include image
  pdf.image image_path

}
