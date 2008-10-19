module ValidatesUrlFormatOf
  REGEXP = %r{\Ahttps?://[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}(([0-9]{1,5})?/.*)?\Z}i  
  
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
