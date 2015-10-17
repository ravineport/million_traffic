# coding:utf-8
require 'active_record'
require 'mysql2'
require 'sinatra'

# DB設定ファイルの読み込み
# ActiveRecord::Base.configurations = YAML.load_file('./config/database.yml')
# ActiveRecord::Base.establish_connection('development')

get '/hello' do
  "Hello!"
end
