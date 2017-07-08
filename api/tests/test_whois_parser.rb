require "minitest/autorun"
require 'mocha/mini_test'
require_relative "../lib/parsers"

class TestWhoisParser < Minitest::Test

  def setup
    @output_whois = <<BLOCK
Test 1: abc
Test 2: def
Test 3: ghi
Abc: 123
BLOCK

    @expected_whois = {
      "test_1" => {"Test 1" => "abc"},
      "test_2" => {"Test 2" => "def"},
      "test_3" => {"Test 3" => "ghi"},
      "abc" => {"Abc" => "123"},
    }

    @output_invalid = "abcdef"

    @expected_invalid = {}
  end

  def test_parse
    assert_equal(@expected_whois, WhoisParser.parse(@output_whois))
  end

  def test_parse_invalid
    assert_equal(@expected_invalid, WhoisParser.parse(@output_invalid))
  end
end
