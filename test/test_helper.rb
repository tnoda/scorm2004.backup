require 'rubygems'
require 'spork'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

Spork.prefork do
  ENV["RAILS_ENV"] = "test"
  require File.expand_path("../dummy/config/environment.rb",  __FILE__)
  require "rails/test_help"
  Rails.backtrace_cleaner.remove_silencers!

  require 'factory_girl_rails'
  ActiveSupport::TestCase.class_eval { include FactoryGirl::Syntax::Methods }
end

Spork.each_run do
  Dir["#{File.dirname(__FILE__)}/../app/models/**/*.rb"].each { |file| load file }
end
