# Load the rails application
require File.expand_path('../application', __FILE__)

# Paperclip config:
Paperclip.options[:image_magick_path] = "/opt/ImageMagick/bin"
Paperclip.options[:command_path] = "/opt/ImageMagick/bin"

# Initialize the rails application
Webshaker::Application.initialize!
