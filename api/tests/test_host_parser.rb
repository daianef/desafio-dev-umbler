require "minitest/autorun"
require 'mocha/mini_test'
require_relative "../lib/parsers"

class TestHostParser < Minitest::Test

  def setup
    @output_ipv4 = <<BLOCK
test.com has address 1.1.1.1
test.com mail is handled by 99 test.com.1.
BLOCK

    @output_ipv6 = <<BLOCK
test.com has address 1.1.1.1
test.com has IPv6 address 1111:222:0:ffff:000:99:888:999
test.com mail is handled by 99 test.com.1.
BLOCK

    @output_invalid = "abcdef"

    @expected_ipv4 = {
      "ipv4" => {"Host IPv4" => "1.1.1.1"}
    }

    @expected_ipv6 = {
      "ipv4" => {"Host IPv4" => "1.1.1.1"},
      "ipv6" => {"Host IPv6" => "1111:222:0:ffff:000:99:888:999"}
    }

    @expected_invalid = {}
  end

  def test_parse_ipv4
    assert_equal(@expected_ipv4, HostParser.parse(@output_ipv4))
  end

  def test_parse_ipv6
    assert_equal(@expected_ipv6, HostParser.parse(@output_ipv6))
  end

  def test_parse_invalid
    assert_equal(@expected_invalid, HostParser.parse(@output_invalid))
  end
end
