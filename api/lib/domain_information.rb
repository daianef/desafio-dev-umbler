
class DomainInformation

  TITLE = 'title'
  SECTION = 'section_values'
  UNIQUE = 'unique_values'
  MULTIPLE = 'multiple_values'

  def initialize(domain_informations, info_config)
    @infos = domain_informations
    @config = info_config
  end

  def get_informations
    infos = []
    @config.keys.each do |key|
      infos << get_section(key)
    end

    infos
  end

  def get_section(key)
    return {} unless @config.has_key? key

    section = @config[key]

    infos = {}
    infos[TITLE] = get_title(section)
    infos[SECTION] = get_unique_values(section)
    infos[SECTION].merge!(get_multiple_values(section))

    infos
  end

  private

  def get_title(section)
    (section.has_key? TITLE)? section[TITLE] : ""
  end

  def get_unique_values(section)
    return {} unless section.has_key? UNIQUE

    values = {}
    section[UNIQUE].each do |key|
      if @infos.has_key? key
        hash = (@infos[key].respond_to? :keys)? @infos[key] : @infos[key].first
        name, value = hash.keys.first, hash.values.first
        values[name] = value
      end
    end

    values
  end

  def get_multiple_values(section)
    return {} unless section.has_key? MULTIPLE

    values = {}
    section[MULTIPLE].each do |key|
      if @infos.has_key? key
        if @infos[key].respond_to? :keys
          name, value = @infos[key].keys.first, @infos[key].values.first
          values[name] = value
        else  
          name = @infos[key].first.keys.first
          values[name] = get_values(@infos[key], name)
        end
      end
    end

    values
  end

  def get_values(infos, key)
    values = []
    infos.each do |hash|
      value = hash.values.first
      selected = values.select {|v| !v.match(/#{value}/i).nil? }
      values << value if selected.empty?
    end

    values
  end
end