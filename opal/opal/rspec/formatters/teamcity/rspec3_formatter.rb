class Spec::Runner::Formatter::TeamcityFormatter
  # mutable strings
  def dump_summary(summary_notification)
    duration = summary_notification.duration
    example_count = summary_notification.example_count
    failure_count = summary_notification.failure_count
    pending_count = summary_notification.pending_count
    # Repairs stdout and stderr just in case
    repair_process_output
    totals = "#{example_count} example#{'s' unless example_count == 1}"
    totals += ", #{failure_count} failure#{'s' unless failure_count == 1}"
    totals += ", #{example_count - failure_count - pending_count} passed"
    totals += ", #{pending_count} pending" if pending_count > 0

    # Total statistic
    debug_log(totals)
    log(totals)

    # Time statistic from Spec Runner
    status_message = "Finished in #{duration} seconds"
    debug_log(status_message)
    log(status_message)

    #Really must be '@example_count == example_count', it is hack for spec trunk tests
    if !@setup_failed && @example_count > example_count
      msg = "#{RUNNER_ISNT_COMPATIBLE_MESSAGE}Error: Not all examples have been run! (#{example_count} of #{@example_count})\n#{gather_unfinished_examples_name}"

      log_and_raise_internal_error msg
      debug_log(msg)
    end unless @groups_stack.empty?

    unless @@RUNNING_EXAMPLES_STORAGE.empty?
      # unfinished examples statistics
      msg = RUNNER_ISNT_COMPATIBLE_MESSAGE + gather_unfinished_examples_name
      log_and_raise_internal_error msg
    end

    # finishing
    @@RUNNING_EXAMPLES_STORAGE.clear

    debug_log("Summary finished.")
  end
  
  # mutable strings
  def gather_unfinished_examples_name
    if @@RUNNING_EXAMPLES_STORAGE.empty?
      return ""
    end

    msg = "Following examples weren't finished:"
    count = 1
    @@RUNNING_EXAMPLES_STORAGE.each { |key, value|
      msg += "\n  #{count}. Example : '#{value.full_name}'"
      sout_str, serr_str = get_redirected_stdout_stderr_from_files(value.stdout_file_new, value.stderr_file_new)
      unless sout_str.empty?
        msg += "\n[Example Output]:\n#{sout_str}"
      end
      unless serr_str.empty?
        msg += "\n[Example Error Output]:\n#{serr_str}"
      end

      count += 1
    }
    msg
  end
  
  # We can't flush @sout and @serr and we disabled output capturing anyways
  def repair_process_output    
  end
end
