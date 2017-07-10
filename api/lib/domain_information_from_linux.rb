require_relative 'parsers'

class DomainInformationFromLinux

  COMMANDS = {
    :whois => "whois",
    :host => "host"
  }

  def self.whois(domain)
    output = `#{COMMANDS[:whois]} #{domain}`
    WhoisParser.parse output
  end

  def self.host(domain)
    output = `#{COMMANDS[:host]} #{domain}`
    HostParser.parse output
  end

  def self.to_hash(domain)
    infos = {}
    infos.merge!(whois(domain))
    infos.merge!(host(domain))

    infos
  end
end
