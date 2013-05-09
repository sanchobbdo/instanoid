require 'open-uri'
require "prawn/measurement_extensions"

PRAWN_DEFAULT_TPL = lambda { |pdf, data|

  # Helpers

  def download_image(src, dest)
    open(src) do |image|
      File.open(dest, 'w') { |f| f.write(image.read) }
    end
  end

  # Vars

  profile_image  = OpenStruct.new({
    :original => data.user.profile_picture,
    :path     => 'tmp/prawn_default_tpl_profile_image.jpg',
    :width    => 10.mm,
    :height   => 10.mm
  })

  standard_image = OpenStruct.new({
    :original => data.images.standard_resolution.url,
    :path     => 'tmp/prawn_default_tpl_standard_image.jpg',
    :width    => 150.mm,
    :height   => 150.mm,
  })

  username  = data.user.username
  comment   = data.comments.data.first.text unless data.comments.data.empty?
  comment ||= nil

  # Download images

  download_image(profile_image.original, profile_image.path)
  download_image(standard_image.original, standard_image.path)

  # Paint

  pdf.image profile_image.path, :fit => [profile_image.width, profile_image.height]
  pdf.text  username
  pdf.image standard_image.path, :fit => [standard_image.width, standard_image.height]
  pdf.text comment if comment
}
