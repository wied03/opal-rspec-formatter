module Rake::TeamCity::StdCaptureHelper
  # flush /captureis not supported on STDOUT or STDERR
  
  def isCaptureDisabled()
    true
  end
  
  # flush is not supported on STDOUT or STDERR and it was at the beginning of this method
  def capture_output_end_external(old_out, old_err, new_out, new_err)
    if isCaptureDisabled()
      return "", ""
    end

    reopen_stdout_stderr(old_out, old_err)

    return get_redirected_stdout_stderr_from_files(new_out, new_err)
  end  
end
