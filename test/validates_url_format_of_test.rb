require 'rubygems'
require 'test/unit'
require 'active_record'
require "#{File.dirname(__FILE__)}/../init"

class Model
  # ActiveRecord validations without database
  # Thanks to http://www.prestonlee.com/archives/182
  def save() end
  def save!() end
  def update_attribute() end
  def new_record?() false end
  def initialize() @errors = ActiveRecord::Errors.new(self) end
  include ActiveRecord::Validations
  
  extend ValidatesUrlFormatOf

  attr_accessor :url
  validates_url_format_of :url
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
      'http://example.com?foo',
      'http://example.com?url=http://example.com',
      'http://example.com:8000',
      'http://www.sub.example.com/page.html?foo=bar&baz=%23#anchor',
#      'http://user:pass@example.com',
      'http://example.com/~user',
      'http://example.co',  # not a real TLD, but we're fine with anything of 2+ chars
      'http://example.museum',
      'http://1.0.255.249',
      'http://1.2.3.4:80',
      'HttP://example.com',
      'https://example.com'
    ].each do |url|
      @model.url = url
      @model.save
      assert !@model.errors.on(:url), "#{url.inspect} should have been accepted"
    end
  end
  
  def test_should_reject_invalid_urls
    [
      nil, 1, "", " ", "url",
      "www.example.com",
      "http://ex ample.com",
      "http://example",
      "http://example.c",
      'http://example.toolongtld',
      'http://256.0.0.1'
    ].each do |url|
      @model.url = url
      @model.save
      assert @model.errors.on(:url), "#{url.inspect} should have been rejected"
    end
  end
  
end
