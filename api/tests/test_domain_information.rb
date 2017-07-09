require "minitest/autorun"
require 'mocha/mini_test'
require_relative "../lib/domain_information"

class TestHostParser < Minitest::Test

  def test_get_section_with_only_unique_values
    infos = {
      "domain_name" => [
        {"Domain Name"=>"TEST.COM"}, {"Domain Name"=>"TEST.COM"}
      ], 
      "updated_date" => {"Updated Date" => "08-jul-2017"}
    }

    config = {
      "domain_section" => {
        
        "title" => "Informações do Domínio",

        "unique_values" => [
          "domain", "domain_name", "registry_domain_id", "ownerid",
          "sponsoring_registrar_iana_id", "updated_date", "changed",
          "creation_date", "created", "expiration_date", "expires",
          "registrar", "ipv4", "ipv6"
        ],

        "multiple_values" => []
      }
    }

    expected = {
      "title" => "Informações do Domínio",
      "section_values" => {
        "Domain Name" => "TEST.COM",
        "Updated Date" => "08-jul-2017"
      }
    }

    domain_info = DomainInformation.new(infos, config)
    assert_equal(expected, domain_info.get_section("domain_section"))
  end

  def test_get_section_with_only_multiple_values
    infos = {
      "name_server" => [
        {"Name Server" => "test1.com"}, 
        {"Name Server" => "test2.com"}, 
        {"Name Server" => "test3.com"}, 
        {"Name Server" => "TEST1.COM"}
      ], 
      "status" => {"Status" => "abc"},
    }

    config = {
      "test_section" => {
        
        "title" => "Test",

        "unique_values" => [
          "domain", "domain_name"
        ],

        "multiple_values" => [
          "status",
          "name_server"
        ]
      }
    }

    expected = {
      "title" => "Test",
      "section_values" => {
        "Name Server" => ["test1.com", "test2.com", "test3.com"],
        "Status" => "abc"
      }
    }

    domain_info = DomainInformation.new(infos, config)
    assert_equal(expected, domain_info.get_section("test_section"))
  end

  def test_get_section_no_existent
    
  end

  def test_get_section_empty

  end
end
