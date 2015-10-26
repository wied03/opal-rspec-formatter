module Rake::TeamCity::MessageFactory
  # Can't use gsub! in Opal and removed copy_of_text.encode!('UTF-8') if copy_of_text.respond_to? :encode! since we don't exactly have encoding
  def self.replace_escaped_symbols(text)
    copy_of_text = String.new(text)

    copy_of_text = copy_of_text.gsub(/\|/, "||")

    copy_of_text = copy_of_text.gsub(/'/, "|'")
    copy_of_text = copy_of_text.gsub(/\n/, "|n")
    copy_of_text = copy_of_text.gsub(/\r/, "|r")
    copy_of_text = copy_of_text.gsub(/\]/, "|]")

    copy_of_text = copy_of_text.gsub(/\[/, "|[")

    begin
      copy_of_text = copy_of_text.gsub(/\u0085/, "|x") # next line
      copy_of_text = copy_of_text.gsub(/\u2028/, "|l") # line separator
      copy_of_text = copy_of_text.gsub(/\u2029/, "|p") # paragraph separator
    rescue
      # it is not an utf-8 compatible string :(
    end

    copy_of_text
  end

  # Opal 0.8 doesn't support usec
  def self.convert_time_to_java_simple_date(time)
    if MOCK_ATTRIBUTES_VALUES[:time][:enabled]
      return MOCK_ATTRIBUTES_VALUES[:time][:value]
    end
    gmt_offset = time.gmt_offset
    gmt_sign = gmt_offset < 0 ? "-" : "+"
    gmt_hours = gmt_offset.abs / 3600
    gmt_minutes = gmt_offset.abs % 3600

    # Opal 0.8 doesn't support usec
    usec = `#{time}.getMilliseconds() * 1000`
    millisec = usec == 0 ? 0 : usec / 1000
    #millisec = time.usec == 0 ? 0 : time.usec / 1000

    #Time string in Java SimpleDateFormat
    sprintf("#{time.strftime("%Y-%m-%dT%H:%M:%S.")}%03d#{gmt_sign}%02d%02d", millisec, gmt_hours, gmt_minutes)
  end
end
