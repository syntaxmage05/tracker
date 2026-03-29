# frozen_string_literal: true

file_path = "config/products.yml"
if File.exist?(file_path)
  PRODUCTS = YAML.load(File.read(file_path)).with_indifferent_access
end
