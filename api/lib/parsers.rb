
class WhoisParser

  # Expressao regular para obter os dados de interesse
  # (informacoes do dominio) em cada linha
  LINE_REGEXP = /^([ A-Za-z0-9-]+):(.+)$/

  # Separador para parsear a saida do comando de whois
  SPLIT_CHARACTER = "\n"

	#
  # Metodo que obtem, de cada linha, as informacoes
  # do dominio e retorna em um Hash
  #
  def self.parse(output)
    whois = {}

    output.split(SPLIT_CHARACTER).each do |line|
      line_re = line.match(LINE_REGEXP)
      next unless line_re

      label = line_re[1].strip
      value = line_re[2].strip
      hash = {label => value}
      key = label.downcase.gsub(" ", "_")

      if whois.has_key? key 
        if whois[key].respond_to? :<<
          whois[key] << hash
        else
          whois[key] = [whois[key], hash]
        end
      else    
        whois[key] = hash
      end
    end

    whois
  end
end

class HostParser

  IPV4_REGEXP = /has address (.+)$/
  IPV4_KEY = "ipv4"
  IPV4_TITLE = "Host IPv4"
  IPV6_REGEXP = /has IPv6 address (.+)$/
  IPV6_KEY = "ipv6"
  IPV6_TITLE = "Host IPv6"


  def self.parse(output)
    host = {}

    result = output.match(IPV4_REGEXP)
    host[IPV4_KEY] = {IPV4_TITLE => result[1]} if result

    result = output.match(IPV6_REGEXP)
    host[IPV6_KEY] = {IPV6_TITLE => result[1]} if result

    host
  end
end
