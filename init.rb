module ValidatesUrlFormatOf
  HOSTNAME  = /[a-z0-9]+([-.]{1}[a-z0-9]+)*\.[a-z]{2,6}/i
  IPv4_PART = /\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5]/  # 0-255
  IPv4 = /(#{IPv4_PART}\.){3}#{IPv4_PART}/
  REGEXP = %r{\Ahttps?://(#{HOSTNAME}|#{IPv4})(:\d{1,5})?([/?].*)?\Z}i  
  
  def validates_url_format_of(*attr_names)
    options = { :message => 'does not appear to be valid',
                :allow_nil => false,
                :allow_blank => false,
                :with => REGEXP }
    options = options.merge(attr_names.pop) if attr_names.last.is_a?(Hash)
    attr_names << options
    validates_format_of(*attr_names)
  end
  
end

ActiveRecord::Base.extend(ValidatesUrlFormatOf)
