require 'bundler/setup'
Bundler.setup

require 'dotenv'
Dotenv.load!('dev_variables.env')

require 'kele'

require 'httparty'

RSpec.configure do |config|
end
