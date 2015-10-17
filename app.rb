# coding:utf-8
require 'active_record'
require 'mysql2'
require 'sinatra'

#DB設定ファイルの読み込み
ActiveRecord::Base.configurations = YAML.load_file('./config/database.yml')
ActiveRecord::Base.establish_connection('development')

class User < ActiveRecord::Base
  self.table_name = "user"
end

class Item < ActiveRecord::Base
  self.table_name = "Item"
end

class Order < ActiveRecord::Base
  self.table_name = "order"
end

get '/hello' do
  "Hello!"
end

get '/getOrder/:orderId' do
  if !Order.exists?(:orderId => params[:orderId])
    ans = {:result => false,
           :data => nil
          }
    return JSON.pretty_generate(ans)
  end
  ans = {:result => true}
  order = Order.where(:orderId => params[:orderId]).first
  p order
  data = {:orderId => order[:orderId],
          :orderDateTime => order[:orderDateTime],
          :orderUserId => order[:orderUserId],
          :orderItemId => order[:orderItemId],
          :orderQuantity => order[:orderQuantity],
          :orderState => order[:orderState],
          :tags => order[:orderTags],
         }
  ans[:data] = data
  return JSON.pretty_generate(ans)
end

get '' do

end

get '' do

end
