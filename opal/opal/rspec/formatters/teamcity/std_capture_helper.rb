module Rake::TeamCity::StdCaptureHelper
  # flush /captureis not supported on STDOUT or STDERR
  
  def isCaptureDisabled()
    true
  end
end
