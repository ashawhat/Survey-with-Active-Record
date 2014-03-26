require 'active_record'
require 'rspec'
require 'shoulda-matchers'
require 'survey'
require 'question'
require 'answer'
require 'response'

database_configurations = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configurations['test']
ActiveRecord::Base.establish_connection(development_configuration)

RSpec.configure do |config|
  config.after(:each) do
    Survey.all.each { |task| task.destroy}
  end
end
