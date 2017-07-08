require "minitest/autorun"
require 'mocha/mini_test'
require_relative "../lib/domain_information_from_linux"
require_relative "../lib/parsers"

class TestDomainInformationFromLinux < Minitest::Test

  def setup
    @output_whois = <<BLOCK
Test 1: abc
Test 2: def
Test 3: ghi
Abc: 123
BLOCK

    @output_host = <<BLOCK
test.com has address 1.1.1.1
test.com mail is handled by 99 test.com.1.
BLOCK
  end

  def test_whois
    DomainInformationFromLinux.expects(:`).with('whois test.com').returns(@output_whois)
    WhoisParser.expects(:parse).with(@output_whois).returns({})

    assert_equal({}, DomainInformationFromLinux.whois('test.com'))
  end

  def test_host
    DomainInformationFromLinux.expects(:`).with('host test.com').returns(@output_host)
    HostParser.expects(:parse).with(@output_host).returns({})

    assert_equal({}, DomainInformationFromLinux.host('test.com'))
  end

  # def test_to_hash
  #   class_mock = mock()
  #   DomainInformationFromLinux.expects(:class).returns(class_mock)

  #   class_mock.expects(:whois).with("test.com").returns({})
  #   class_mock.expects(:host).with("test.com").returns({})

  #   assert_equal({}, DomainInformationFromLinux.to_hash("test.com"))
  # end
end