require 'rubygems'
require 'test/unit'
require 'active_record'
require "#{File.dirname(__FILE__)}/../init"

class Model
  begin  # Rails 3
    include ActiveModel::Validations
  rescue NameError  # Rails 2.*
	  # ActiveRecord validations without database
    # Thanks to http://www.prestonlee.com/archives/182
    def save() end
    def save!() end
    def new_record?() false end
    def update_attribute() end  # Needed by Rails 2.1.
    def self.human_name() end
    def self.human_attribute_name(_) end
    def initialize
      @errors = ActiveRecord::Errors.new(self)
      def @errors.[](key)  # Return errors in same format as Rails 3.
        Array(on(key))
      end
    end
    def self.self_and_descendants_from_active_record() [self] end
    def self.self_and_descendents_from_active_record() [self] end  # Needed by Rails 2.2.
    include ActiveRecord::Validations
  end
    
  extend ValidatesUrlFormatOf

  attr_accessor :homepage
  validates_url_format_of :homepage
  
  attr_accessor :my_UrL_hooray
  validates_url_format_of :my_UrL_hooray
  
  attr_accessor :custom_url
  validates_url_format_of :custom_url, :message => 'custom message'
  
  attr_accessor :ftp_url
  validates_url_format_of :ftp_url, :allow_protocols => %w(ftp ftps), :allow_nil => true
end

class ValidatesUrlFormatOfTest < Test::Unit::TestCase
  
  def setup
    @model = Model.new
  end
  
  def test_should_allow_valid_urls
    [
      'http://example.com',
      'http://example.com/',
      'http://www.example.com/',
      'http://sub.domain.example.com/',
      'http://bbc.co.uk',
      'http://example.com?foo',
      'http://example.com?url=http://example.com',
      'http://example.com:8000',
      'http://www.sub.example.com/page.html?foo=bar&baz=%23#anchor',
      'http://user:pass@example.com',
      'http://user:@example.com',
      'http://example.com/~user',
      'http://example.xy',  # Not a real TLD, but we're fine with anything of 2-6 chars
      'http://example.museum',
      'http://1.0.255.249',
      'http://1.2.3.4:80',
      'HttP://example.com',
      'https://example.com',
      'http://räksmörgås.nu',  # IDN
      'http://xn--rksmrgs-5wao1o.nu',  # Punycode
      'http://www.xn--rksmrgs-5wao1o.nu',
      'http://foo.bar.xn--rksmrgs-5wao1o.nu',
      'http://example.com.',  # Explicit TLD root period
      'http://example.com./foo'
    ].each do |url|
      @model.homepage = url
      @model.valid?
      assert @model.errors[:homepage].empty?, "#{url.inspect} should have been accepted"
    end
  end
  
  def test_should_reject_invalid_urls
    [
      nil, 1, "", " ", "url",
      "www.example.com",
      "http://ex ample.com",
      "http://example.com/foo bar",
      'http://256.0.0.1',
      'http://u:u:u@example.com',
      'http://r?ksmorgas.com',
      
      # These can all be valid local URLs, but should not be considered valid
      # for public consumption.
      "http://example",
      "http://example.c",
      'http://example.toolongtld'
    ].each do |url|
      @model.homepage = url
      @model.valid?
      assert !@model.errors[:homepage].empty?, "#{url.inspect} should have been rejected"
    end
  end
  
  def test_allowed_protocol_list
    %w(ftp ftps).each do |protocol|
      @model.ftp_url = "#{protocol}://example.com"
      @model.valid?
      assert @model.errors[:ftp_url].empty?, "#{protocol.inspect} should have been accepted"
    end
    
    @model.ftp_url = "http://example.com"
    @model.valid?
    assert !@model.errors[:ftp_url].empty?, '"http" should have been rejected'
  end
  
  def test_allows_nil
    @model.ftp_url = nil
    @model.valid?
    assert @model.errors[:ftp_url].empty?, "nil should have been accepted"
  end
  
  def test_different_defaults_based_on_attribute_name
    @model.homepage = 'x'
    @model.my_UrL_hooray = 'x'
    @model.valid?
    assert_not_equal ValidatesUrlFormatOf::DEFAULT_MESSAGE, ValidatesUrlFormatOf::DEFAULT_MESSAGE_URL
    assert_equal [ValidatesUrlFormatOf::DEFAULT_MESSAGE], @model.errors[:homepage]
    assert_equal [ValidatesUrlFormatOf::DEFAULT_MESSAGE_URL], @model.errors[:my_UrL_hooray]
  end
  
  def test_can_override_defaults
    @model.custom_url = 'x'
    @model.valid?
    assert_equal ['custom message'], @model.errors[:custom_url]
  end
  
end
