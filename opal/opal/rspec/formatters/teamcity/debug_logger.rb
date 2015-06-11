require 'teamcity/utils/logger_util'

module Rake
  module TeamCity
    module Utils
      class ConsoleLogger < FileLogger
        def initialize(enabled)
          @enabled = enabled
          @log_file = $stdout
        end
        
        def log_msg(msg, add_proc_thread_info=false)
          if @enabled
            # Threads don't exist on JS
            @log_file << "[#{Time.now}] : #{" " + msg}\n"
          end
        end            
      end
    end
  end
end
