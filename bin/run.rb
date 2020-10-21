require_relative '../config/environment'
require_relative "../app/lib/api_communicator.rb"
require_relative "../app/lib/command_line_interface.rb"


CLI.new.start
