require 'json'
require 'redis'
require_relative 'lib/domain_information'
require_relative 'lib/domain_information_from_linux'

#
# Classe para acessar a API usando Redis (se o valor
# ja foi pesquisado, retorna valor da cache).
#
class DomainExplorer

  attr_reader :host, :port, :expire

  # Arquivo de configuracao default para os campos de informacao
  CONFIG = File.expand_path(File.join(File.dirname(__FILE__), 'config/information_config.json'))

  def initialize(domain_information_class=DomainInformationFromLinux)
    # Host default do Redis: localhost
    @host = ENV['REDIS_HOST'] || 'localhost'
    # Porta dafault do Redis: 6379
    @port = ENV['REDIS_PORT'] || 6379
    # Prazo default para expirar: 1h
    @expire = ENV['REDIS_EXPIRE'] || 3600

    @redis = Redis.new(:host => host, :port => port)
    @domain_information_class = domain_information_class
  end

  #
  # Retorna as informacoes do dominio, usando a cache,
  # em formato "parseado" e raw
  #
  def get_domain_information(domain, config=CONFIG)
    info_hash = cache(domain)
    config = JSON.parse(File.read(CONFIG))

    domain_info = DomainInformation.new(info_hash, config)
    
    {
      :parsed => domain_info.get_informations(), 
      :raw => domain_info.get_raw_information()
    }
  end

  private

  #
  # Se o valor estiver na cache, retorna ele.
  # Caso contrario, consulta os servidores
  # para obter as informacoes.
  #
  def cache(key)
    value = {}

    if @redis[key]
      value = JSON.parse(@redis.get(key))
    else
      value = @domain_information_class.to_hash(key)
      unless value.empty?
        @redis.set(key, value.to_json)
        @redis.expire(key, @expire)
      end
    end

    value
  end
end
