require 'bundler'
Bundler.require

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
#ActiveRecord::Base.logger.level = 1 #this is cool, declutters CLI terminal. Must be off to use rake
require_all 'lib'
