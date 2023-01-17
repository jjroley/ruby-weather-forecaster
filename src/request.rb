

module Request
  def self.build_request_string(url, query_hash)
    url_string = url
    url_string += "?"
    query_hash.each do |key, value|
      url_string += key.to_s
      if value
        url_string += "=#{value}"
      end
      url_string += "&"
    end
    url_string.gsub!(/&$/, '')
    url_string
  end
end