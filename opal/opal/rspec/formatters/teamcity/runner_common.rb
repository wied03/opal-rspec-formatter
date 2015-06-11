module Rake::TeamCity::RunnerCommon
  # Opal.IO does not support flush
  def send_msg(msg)
    #@@original_stdout.flush
    @@original_stdout.puts("\n#{msg}")
    #@@original_stdout.flush
  end
end
