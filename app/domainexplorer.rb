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

  domain_explorer = DomainExplorer.new
  @domain_infos = domain_explorer.get_domain_information(@domain)

  erb :show
end

__END__

@@ index
<h1>Explorador de domínios</h1>
<h3>Informe um domínio para saber informações de seu registro</h3>
<form action="/" method="post" id="search_form">
  <label>Domínio:</label>
  <input name="info" type="text">
  <button type='submit' class='btn btn-primary'>Buscar</button>
</form>
<div id="domain""></div>

@@ show
<h3>Domínio: <%= @domain %></h3>
<p>Infos: <%= @domain_infos %></p>
