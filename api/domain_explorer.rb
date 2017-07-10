#$: File.expand_path(File.join(File.dirname(__FILE__), ".."))

require 'json'
require 'redis'

require_relative 'lib/domain_information'
require_relative 'lib/domain_information_from_linux'

class DomainExplorer

  attr_reader :host, :port, :expire

  # Arquivo de configuracao default para os campos de informacao
  CONFIG = File.expand_path(File.join(File.dirname(__FILE__), 'config/information_config.json'))

  # Se nao houver a variavel de ambiente REDIS_HOST,
  # entao assume localhost
  # Se nao houver a variavel de ambiente REDIS_PORT,
  # entao assume porta 6379

  def initialize(domain_information_class=DomainInformationFromLinux)
    @host = ENV['REDIS_HOST'] || 'localhost'
    @port = ENV['REDIS_PORT'] || 6379
    @expire = ENV['REDIS_EXPIRE'] || 3600

    @redis = Redis.new(:host => host, :port => port)
    @domain_information_class = domain_information_class
  end

  def get_domain_information(domain, config=CONFIG)
    info_hash = cache(domain)
    config = JSON.parse(File.read(CONFIG))

    domain_info = DomainInformation.new(info_hash, config)
    domain_info.get_informations()
  end

  private

  def cache(key)
    value = {}

    if @redis[key]
      value = JSON.parse(@redis.get(key))
    else
      value = @domain_information_class.to_hash(key)
      @redis.set(key, value.to_json)
      @redis.expire(key, @expire)
    end

    value
  end
end
