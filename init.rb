module ValidatesUrlFormatOf
  IPv4_PART = /\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5]/  # 0-255
  REGEXP = %r{
    \A
    [a-z]+://                                                    # http:// or https:// or xyz://
    ([^\s:@]+:[^\s:@]*@)?                                        # optional username:pw@
    ( (([^\W_]+\.)*xn--)?[^\W_]+([-.][^\W_]+)*\.[a-z]{2,6}\.? |  # domain (including Punycode/IDN)...
        #{IPv4_PART}(\.#{IPv4_PART}){3} )                        # or IPv4
    (:\d{1,5})?                                                  # optional port
    ([/?]\S*)?                                                   # optional /whatever or ?whatever
    \Z
  }iux

  DEFAULT_MESSAGE          = 'does not appear to be a valid URL'
  DEFAULT_MESSAGE_URL      = 'does not appear to be valid'
  DEFAULT_PROTOCOLS        = %w(http https)
  
  def validates_url_format_of(*attr_names)
    options = { :allow_nil => false,
                :allow_blank => false,
                :allow_protocols => DEFAULT_PROTOCOLS,
                :with => REGEXP }
    options = options.merge(attr_names.pop) if attr_names.last.is_a?(Hash)

    attr_names.each do |attr_name|
      message = attr_name.to_s.match(/(_|\b)URL(_|\b)/i) ? DEFAULT_MESSAGE_URL : DEFAULT_MESSAGE
      validates_format_of(attr_name, { :message => message }.merge(options))
      validates_each attr_name do |record, attr, value|
        unless record.errors.on(attr) || value.blank? # skip if the url is already invalid or blank
          protocol = value[/\A\s*([a-z]+):/i, 1].to_s.downcase
          record.errors.add attr, options.fetch(:message, message) unless options[:allow_protocols].include?(protocol)
        end
      end
    end
  end
  
end

ActiveRecord::Base.extend(ValidatesUrlFormatOf)
