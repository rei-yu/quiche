module ApplicationHelper
  TAGS_TO_BE_REMOVED = [/<div>/, /<\/div>/, /\n/, /\t/, /<p>/, /<\/p>/].freeze

  #TODO move to decorator
  def extract_url(url)
    url = URI(url)
    extracted_url = url.scheme + '://' + url.host + url.path
  end

  #TODO move to decorator
  def re_arrange(str)
    cloned_str = str.dup
    TAGS_TO_BE_REMOVED.each { |pattern| cloned_str.gsub!(pattern, '') }
    cloned_str.truncate(250)
  end
end
