# coding:utf-8
require 'active_record'
require 'mysql2'
require 'sinatra'

#DB設定ファイルの読み込み
ActiveRecord::Base.configurations = YAML.load_file('./config/database.yml')
ActiveRecord::Base.establish_connection(:development)

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
          :orderDateTime => order[:orderDateTime].to_i,
          :orderUserId => order[:orderUserId],
          :orderItemId => order[:orderItemId],
          :orderQuantity => order[:orderQuantity],
          :orderState => order[:orderState],
          :tags => order[:orderTags],
         }
  ans[:data] = data
  return JSON.pretty_generate(ans)
end

get '/searchOrder' do
  ans = JSON.parse('{}')
  params[:limit] = 100 if params[:limit] == nil
  if params.has_key?("findByOrderDateTimeGTE")
    ans = findByOrderDateTimeGTE(params)
  elsif params.has_key?("findByOrderDateTimeLTE")
    ans = findByOrderDateTimeLTE(params)
  elsif params.has_key?("findByOrderUserId")
    ans = findByOrderUserId(params)
  elsif params.has_key?("findByOrderItemId")
    ans = findByOrderItemId(params)
  end

  return ans
end

def findByOrderDateTimeGTE(params)
  ans = {:result => true}

  orders = Order.limit(params[:limit])
           .where("orderDateTime >= ?", params[:findByOrderDateTimeGTE])
           .order("orderDateTime DESC")
  data = []
  orders.each do |order|
    detail = {:orderId       => order[:orderId],
              :orderDateTime => order[:orderDateTime].to_i,
              :orderUserId   => order[:orderUserId],
              :orderItemId   => order[:orderItemId],
              :orderQuantity => order[:orderQuantity],
              :orderState    => order[:orderState],
              :tags          => order[:orderTags].split(',')
             }
    data << detail
  end
  ans[:data] = data
  return JSON.pretty_generate(ans)
end

def findByOrderDateTimeLTE(params)
  ans = {:result => true}

  orders = Order.limit(params[:limit])
           .where("orderDateTime <= ?", params[:findByOrderDateTimeLTE])
           .order("orderDateTime DESC")
  data = []
  orders.each do |order|
    detail = {:orderId       => order[:orderId],
              :orderDateTime => order[:orderDateTime].to_i,
              :orderUserId   => order[:orderUserId],
              :orderItemId   => order[:orderItemId],
              :orderQuantity => order[:orderQuantity],
              :orderState    => order[:orderState],
              :tags          => order[:orderTags].split(',')
             }
    data << detail
  end
  ans[:data] = data
  return JSON.pretty_generate(ans)
end

def findByOrderUserId(params)
  oUId = params[:findByOrderUserId]

  ans = {:result => true}
  orders = Order.limit(params[:limit]).where(:orderUserId => oUId)
           .order("orderDateTime DESC")
  data = []
  orders.each do |order|
    detail = {:orderId       => order[:orderId],
              :orderDateTime => order[:orderDateTime].to_i,
              :orderUserId   => order[:orderUserId],
              :orderItemId   => order[:orderItemId],
              :orderQuantity => order[:orderQuantity],
              :orderState    => order[:orderState],
              :tags          => order[:orderTags].split(',')
             }
    data << detail
  end

  ans[:data] = data
  return JSON.pretty_generate(ans)
end

def findByOrderItemId(params)
  iUId = params[:findByOrderItemId]

  ans = {:result => true}
  orders = Order.limit(params[:limit]).where(:orderItemId => iUId)
           .order("orderDateTime DESC")
  data = []
  orders.each do |order|
    detail = {:orderId       => order[:orderId],
              :orderDateTime => order[:orderDateTime].to_i,
              :orderUserId   => order[:orderUserId],
              :orderItemId   => order[:orderItemId],
              :orderQuantity => order[:orderQuantity],
              :orderState    => order[:orderState],
              :tags          => order[:orderTags].split(',')
             }
    data << detail
  end

  ans[:data] = data
  return JSON.pretty_generate(ans)
end
