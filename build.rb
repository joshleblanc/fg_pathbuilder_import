require 'rubygems'
require 'zip'

folder = "."
input = [
  "scripts/**/*",
  "strings/**/*",
  "utility/**/*",
  "windows/**/*",
  "extension.xml"
]

zipfile_name = "pathbuilder_import.pak"

Zip::File.open(zipfile_name, create: true) do |zipfile|
  input.each do |i|
    Dir.glob(i).each do |file|
      zipfile.add(file, file)
    end
  end
end