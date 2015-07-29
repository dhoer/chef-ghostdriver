require 'rspec_helper'

describe 'ghostdriver port', unless: /darwin/ =~ RUBY_PLATFORM do
  before(:all) do
    @selenium = Selenium::WebDriver.for(:remote, url: 'http://localhost:8911')
    @selenium.manage.window.size = Selenium::WebDriver::Dimension.new(1280, 1024)
  end

  after(:all) do
    @selenium.quit
  end

  it 'Should return display resolution of 1280x1024' do
    @selenium.get 'http://google.com/'
    @selenium.save_screenshot('screenshot.png')
    file_info = `file screenshot.png`.chomp
    expect(file_info).to eq('screenshot.png: PNG image data, 1280 x 1024, 8-bit/color RGBA, non-interlaced')
  end
end

describe 'ghostdriver selenium node' do
  before(:all) do
    @selenium = Selenium::WebDriver.for(:remote, desired_capabilities: :phantomjs)
    # cannot set display resolution on selenium node
    # @selenium.manage.window.size = Selenium::WebDriver::Dimension.new(1280, 1024)
  end

  after(:all) do
    @selenium.quit
  end

  it 'Should return display resolution of 1024 x 768' do
    @selenium.get 'http://www.whatismyscreenresolution.com/'
    element = @selenium.find_element(:id, 'resolutionNumber')
    expect(element.text).to eq('1024 x 768')
  end
end
