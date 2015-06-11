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
end
