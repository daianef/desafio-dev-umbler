#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra'
require 'redis'

require_relative '../api/domain_explorer'

get '/' do
  erb :index
end

get '/search_domain' do
  @domain = params[:info]
  update_cache = params[:update_key]

  if @domain.empty?
    @message = "Digite um domínio para pesquisar."
    erb :empty

  else
    domain_explorer = DomainExplorer.new
    infos = domain_explorer.get_domain_information(@domain, update_cache)

    @domain_infos = infos[:parsed]
    @raw = infos[:raw].to_s

    if @domain_infos.empty?
      @message = "Nenhum resultado disponível."
      erb :empty
    else
      erb :show
    end

  end
end

__END__

@@ index
<div class="jumbotron">
  <h1>Explorador de domínios</h1>
  <p>Informe um domínio para saber detalhes sobre seu registro</p>
  <form action="/" method="post" id="search_form">
    <p><input name="info" type="text"></p>
    <p><button type='submit' class='btn btn-lg btn-dafault'>Buscar</button></p>
  </form>
</div>
<div id="loading"></div>
<div id="domain""></div>
<p id="update_button" style="display:none;"><button type='submit' id="search_update" class='btn btn-lg btn-dafault'>Atualizar</button></p>

@@ show
<div class="header clearfix">
  <h3 class="text-muted">Domínio: <%= @domain %></h3>
</div>
<% for section in @domain_infos %>
  <div class="panel panel-default">
    <div class="panel-heading">
      <h3 class="panel-title"><%= section['title'] %></h3>
    </div>
    <div class="panel-body">
      <% section['section_values'].each_pair do |key, value| %>
        <% if value.respond_to? :join %>
          <p><b><%= key %></b>:</p>
          <ul>
          <% for value_of_list in value %>
            <li><%= value_of_list %></li>
          <% end %>
          </ul>
        <% else %>  
          <p><b><%= key %></b>: <%= value %></p>
        <% end %>
      <% end %>
    </div>
  </div>
<% end %>
  <div class="panel panel-default">
    <div class="panel-heading">
      <h3 class="panel-title">Informações em formato raw (whois)</h3>
    </div>
    <div class="panel-body">
      <%= @raw.gsub(/\n/, '<br />') %>
    </div>
  </div>

@@empty
<div class="alert alert-warning" role="alert">
  <strong>Atenção:</strong> <%= @message %>
</div>
