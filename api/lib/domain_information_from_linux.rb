require_relative 'parsers'

#
# Abstrai a execucao e leitura dos dados
# a partir de comandos do Linux.
#
class DomainInformationFromLinux

  # Comandos utilizados
  COMMANDS = {
    :whois => "whois",
    :host => "host"
  }

  #
  # Executa o comando 'whois domain', retornando
  # a saida interpretada.
  #
  def self.whois(domain)
    output = `#{COMMANDS[:whois]} #{domain}`
    WhoisParser.parse output
  end

  #
  # Executa o comando 'host domain', retornando
  # a saida interpretada.
  #
  def self.host(domain)
    output = `#{COMMANDS[:host]} #{domain}`
    HostParser.parse output
  end

  #
  # Executa todos os comandos e retorna
  # a saida interpretada.
  #
  def self.to_hash(domain)
    infos = {}
    infos.merge!(whois(domain))
    infos.merge!(host(domain))

    infos
  end
end
