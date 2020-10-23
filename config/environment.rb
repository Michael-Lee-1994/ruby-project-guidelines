require 'bundler'
Bundler.require

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: '../db/development.db')
require_rel '../app'
ActiveRecord::Base.logger = nil

# require_all 'app/models'
# require_rel '../app/models'
# require_rel '../app/lib'