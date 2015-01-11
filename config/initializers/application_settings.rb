# This reads /config/settings.yml and sets up the environment
APPLICATION_SETTINGS = YAML.load(File.read(Rails.root.join('config', 'settings.yml')))[Rails.env]

puts "Starting with application settings: #{APPLICATION_SETTINGS.to_json}"