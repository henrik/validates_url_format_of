module ValidatesUrlFormatOf
  IPv4_PART = /\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5]/  # 0-255
  REGEXP = %r{
    \A
    https?://                                  # http:// or https://
    ([^\s:@]+:[^\s:@]+@)?                      # optional username:pw@
    ( [a-z0-9]+([-.][a-z0-9]+)*\.[a-z]{2,6} |  # domain...
        #{IPv4_PART}(\.#{IPv4_PART}){3} )      # or IPv4
    (:\d{1,5})?                                # optional port
    ([/?].*)?                                  # optional /whatever or ?whatever
    \Z
  }ix
  
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
