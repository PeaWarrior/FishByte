require 'bundler'
Bundler.require
require 'colorize'
require 'colorized_string'
require 'JSON'
ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
ActiveRecord::Base.logger = nil
require_all 'lib'