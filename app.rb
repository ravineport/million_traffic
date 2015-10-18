# coding:utf-8
require 'active_record'
require 'mysql2'
require 'sinatra'

#DB設定ファイルの読み込み
ActiveRecord::Base.configurations = YAML.load_file('./config/database.yml')
ActiveRecord::Base.establish_connection(:development)

$client = Mysql2::Client.new(:host => 'localhost', :username => 'root', :password => '', :database => 'million_traffic')

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
  # 1
  if params.has_key?("findByOrderDateTimeGTE")
    ans = findByOrderDateTimeGTE(params)
  elsif params.has_key?("findByOrderDateTimeLTE")
    ans = findByOrderDateTimeLTE(params)
  elsif params.has_key?("findByOrderUserId")
    ans = findByOrderUserId(params)
  elsif params.has_key?("findByOrderItemId")
    ans = findByOrderItemId(params)
  elsif params.has_key?("findByOrderQuantityGTE")
    ans = findByOrderQuantityGTE(params)
  elsif params.has_key?("findByOrderQuantityLTE")
    ans = findByOrderQuantityLTE(params)
  elsif params.has_key?("findByOrderState")
    ans = findByOrderState(params)
  elsif params.has_key?("findByOrderTagsIncludeAll")
    ans = findByOrderTagsIncludeAll(params)
  elsif params.has_key?("findByOrderTagsIncludeAny")
    ans = findByOrderTagsIncludeAny(params)
  # 2
  elsif params.has_key?("findByUserCompany")
    ans = findByUserCompany(params)
  elsif params.has_key?("findByUserDiscountRateGTE")
    ans = findByUserDiscountRateGTE(params)
  elsif params.has_key?("findByUserDiscountRateLTE")
    ans = findByUserDiscountRateLTE(params)
  # 3
  elsif params.has_key?("findByItemSupplier")
    ans = findByItemSupplier(params)
  elsif params.has_key?("findByItemStockQuantityGTE")
    ans = findByItemStockQuantityGTE(params)
  elsif params.has_key?("findByItemStockQuantityLTE")
    ans = findByItemStockQuantityLTE(params)
  elsif params.has_key?("findByItemBasePriceGTE")
    ans = findByItemBasePriceGTE(params)
  elsif params.has_key?("findByItemBasePriceLTE")
    ans = findByItemBasePriceLTE(params)
  elsif params.has_key?("findByItemTagsIncludeAll")
    ans = findByItemTagsIncludeAll(params)
  elsif params.has_key?("findByItemTagsIncludeAny")
    ans = findByItemTagsIncludeAny(params)
  end

  return ans
end

def findByOrderDateTimeGTE(params)
  ans = {:result => true}

  orders = Order
           .where("orderDateTime >= ?", params[:findByOrderDateTimeGTE])
           .order("orderDateTime DESC")
           .limit(params[:limit])
  data = []
  orders.each do |order|
    detail = {:orderId       => order[:orderId],
              :orderDateTime => order[:orderDateTime].to_i,
              :orderUserId   => order[:orderUserId],
              :orderItemId   => order[:orderItemId],
              :orderQuantity => order[:orderQuantity],
              :orderState    => order[:orderState],
              :orderTags     => order[:orderTags].split(',')
             }
    data << detail
  end
  ans[:data] = data
  return JSON.pretty_generate(ans)
end

def findByOrderDateTimeLTE(params)
  ans = {:result => true}

  orders = Order
           .where("orderDateTime <= ?", params[:findByOrderDateTimeLTE])
           .order("orderDateTime DESC")
           .limit(params[:limit])
  data = []
  orders.each do |order|
    detail = {:orderId       => order[:orderId],
              :orderDateTime => order[:orderDateTime].to_i,
              :orderUserId   => order[:orderUserId],
              :orderItemId   => order[:orderItemId],
              :orderQuantity => order[:orderQuantity],
              :orderState    => order[:orderState],
              :orderTags          => order[:orderTags].split(',')
             }
    data << detail
  end
  ans[:data] = data
  return JSON.pretty_generate(ans)
end

def findByOrderUserId(params)
  oUId = params[:findByOrderUserId]

  ans = {:result => true}
  orders = Order
           .where(:orderUserId => oUId)
           .order("orderDateTime DESC")
           .limit(params[:limit])
  data = []
  orders.each do |order|
    detail = {:orderId       => order[:orderId],
              :orderDateTime => order[:orderDateTime].to_i,
              :orderUserId   => order[:orderUserId],
              :orderItemId   => order[:orderItemId],
              :orderQuantity => order[:orderQuantity],
              :orderState    => order[:orderState],
              :orderTags          => order[:orderTags].split(',')
             }
    data << detail
  end

  ans[:data] = data
  return JSON.pretty_generate(ans)
end

def findByOrderItemId(params)
  iUId = params[:findByOrderItemId]

  ans = {:result => true}
  orders = Order
           .where(:orderItemId => iUId)
           .order("orderDateTime DESC")
           .limit(params[:limit])
  data = []
  orders.each do |order|
    detail = {:orderId       => order[:orderId],
              :orderDateTime => order[:orderDateTime].to_i,
              :orderUserId   => order[:orderUserId],
              :orderItemId   => order[:orderItemId],
              :orderQuantity => order[:orderQuantity],
              :orderState    => order[:orderState],
              :orderTags          => order[:orderTags].split(',')
             }
    data << detail
  end

  ans[:data] = data
  return JSON.pretty_generate(ans)
end

def findByOrderQuantityGTE(params)
  ans = {:result => true}

  orders = Order
           .where("orderQuantity >= ?", params[:findByOrderQuantityGTE])
           .order("orderDateTime DESC")
           .limit(params[:limit])
  data = []
  orders.each do |order|
    detail = {:orderId       => order[:orderId],
              :orderDateTime => order[:orderDateTime].to_i,
              :orderUserId   => order[:orderUserId],
              :orderItemId   => order[:orderItemId],
              :orderQuantity => order[:orderQuantity],
              :orderState    => order[:orderState],
              :orderTags          => order[:orderTags].split(',')
             }
    data << detail
  end
  ans[:data] = data
  return JSON.pretty_generate(ans)
end

def findByOrderQuantityLTE(params)
  ans = {:result => true}

  orders = Order
           .where("orderQuantity <= ?", params[:findByOrderQuantityLTE])
           .order("orderDateTime DESC")
           .limit(params[:limit])
  data = []
  orders.each do |order|
    detail = {:orderId       => order[:orderId],
              :orderDateTime => order[:orderDateTime].to_i,
              :orderUserId   => order[:orderUserId],
              :orderItemId   => order[:orderItemId],
              :orderQuantity => order[:orderQuantity],
              :orderState    => order[:orderState],
              :orderTags          => order[:orderTags].split(',')
             }
    data << detail
  end
  ans[:data] = data
  return JSON.pretty_generate(ans)
end

def findByOrderState(params)
  state = params[:findByOrderState]

  ans = {:result => true}
  orders = Order
           .where(:orderState => state)
           .order("orderDateTime DESC")
           .limit(params[:limit])
  data = []
  orders.each do |order|
    detail = {:orderId       => order[:orderId],
              :orderDateTime => order[:orderDateTime].to_i,
              :orderUserId   => order[:orderUserId],
              :orderItemId   => order[:orderItemId],
              :orderQuantity => order[:orderQuantity],
              :orderState    => order[:orderState],
              :orderTags          => order[:orderTags].split(',')
             }
    data << detail
  end

  ans[:data] = data
  return JSON.pretty_generate(ans)
end

def findByOrderTagsIncludeAll(params)
  searchTags = params[:findByOrderTagsIncludeAll].split(',')
  query = "select * from `order` where "
  searchTags.each do |tag|
    query += "FIND_IN_SET('#{tag}', orderTags) and "
  end
  query.sub!(/and $/, '')
  query += "order by orderDateTime desc limit #{params[:limit]}"

  data = []
  orders = $client.query(query)
  orders.each do |order|
    order["orderDateTime"] = order["orderDateTime"].to_i
    order["orderTags"] = order["orderTags"].split(',')
    data << order
  end

  ans = {:result => true}
  ans[:data] = data
  return JSON.pretty_generate(ans)
end

def findByOrderTagsIncludeAny(params)
  searchTags = params[:findByOrderTagsIncludeAny].split(',')
  query = "select * from `order` where "
  searchTags.each do |tag|
    query += "FIND_IN_SET('#{tag}', orderTags) or "
  end
  query.sub!(/or $/, '')
  query += "order by orderDateTime desc limit #{params[:limit]}"

  data = []
  orders = $client.query(query)
  orders.each do |order|
    order[:orderDateTime] = order["orderDateTime"].to_i
    order[:orderTags] = order["orderTags"].split(',')
    data << order
  end

  ans = {:result => true}
  ans[:data] = data
  return JSON.pretty_generate(ans)
end

# 2
def findByUserCompany(params)
  ans = {:result => true}

  query = "select `order`.orderId, `order`.orderDateTime, `order`.orderUserId, `order`.orderItemId, `order`.orderQuantity, `order`.orderState, `order`.orderTags from `order` inner join user on user.userId=`order`.orderUserId where user.userCompany='#{params[:findByUserCompany]}' order by orderDateTime desc limit #{params[:limit]}"

  data = []
  orders = $client.query(query)
  orders.each do |order|
    order[:orderDateTime] = order["orderDateTime"].to_i
    order[:orderTags] = order["orderTags"].split(',')
    data << order
  end

  ans = {:result => true}
  ans[:data] = data
  return JSON.pretty_generate(ans)
end

def findByUserDiscountRateGTE(params)
  ans = {:result => true}

  query = "select `order`.orderId, `order`.orderDateTime, `order`.orderUserId, `order`.orderItemId, `order`.orderQuantity, `order`.orderState, `order`.orderTags from `order` inner join user on user.userId=`order`.orderUserId where user.userDiscountRate>=#{params[:findByUserDiscountRateGTE]} order by orderDateTime desc limit #{params[:limit]}"

  data = []
  orders = $client.query(query)
  orders.each do |order|
    order[:orderDateTime] = order["orderDateTime"].to_i
    order[:orderTags] = order["orderTags"].split(',')
    data << order
  end

  ans = {:result => true}
  ans[:data] = data
  return JSON.pretty_generate(ans)
end

def findByUserDiscountRateLTE(params)
  ans = {:result => true}

  query = "select `order`.orderId, `order`.orderDateTime, `order`.orderUserId, `order`.orderItemId, `order`.orderQuantity, `order`.orderState, `order`.orderTags from `order` inner join user on user.userId=`order`.orderUserId where user.userDiscountRate<=#{params[:findByUserDiscountRateLTE]} order by orderDateTime desc limit #{params[:limit]}"

  data = []
  orders = $client.query(query)
  orders.each do |order|
    order[:orderDateTime] = order["orderDateTime"].to_i
    order[:orderTags] = order["orderTags"].split(',')
    data << order
  end

  ans = {:result => true}
  ans[:data] = data
  return JSON.pretty_generate(ans)
end


# 3
def findByItemSupplier(params)
  ans = {:result => true}

  query = "select `order`.orderId, `order`.orderDateTime, `order`.orderUserId, `order`.orderItemId, `order`.orderQuantity, `order`.orderState, `order`.orderTags from `order` inner join item on item.itemId=`order`.orderItemId where item.itemSupplier='#{params[:findByItemSupplier]}' order by orderDateTime desc limit #{params[:limit]}"

  data = []
  orders = $client.query(query)
  orders.each do |order|
    order[:orderDateTime] = order["orderDateTime"].to_i
    order[:orderTags] = order["orderTags"].split(',')
    data << order
  end

  ans = {:result => true}
  ans[:data] = data
  return JSON.pretty_generate(ans)
end

def findByItemStockQuantityGTE(params)
  ans = {:result => true}

  query = "select `order`.orderId, `order`.orderDateTime, `order`.orderUserId, `order`.orderItemId, `order`.orderQuantity, `order`.orderState, `order`.orderTags from `order` inner join item on item.itemId=`order`.orderItemId where item.itemStockQuantity>=#{params[:findByItemStockQuantityGTE]} order by orderDateTime desc limit #{params[:limit]}"

  data = []
  orders = $client.query(query)
  orders.each do |order|
    order[:orderDateTime] = order["orderDateTime"].to_i
    order[:orderTags] = order["orderTags"].split(',')
    data << order
  end

  ans = {:result => true}
  ans[:data] = data
  return JSON.pretty_generate(ans)
end

def findByItemStockQuantityLTE(params)
  ans = {:result => true}

  query = "select `order`.orderId, `order`.orderDateTime, `order`.orderUserId, `order`.orderItemId, `order`.orderQuantity, `order`.orderState, `order`.orderTags from `order` inner join item on item.itemId=`order`.orderItemId where item.itemStockQuantity<=#{params[:findByItemStockQuantityLTE]} order by orderDateTime desc limit #{params[:limit]}"

  data = []
  orders = $client.query(query)
  orders.each do |order|
    order[:orderDateTime] = order["orderDateTime"].to_i
    order[:orderTags] = order["orderTags"].split(',')
    data << order
  end

  ans = {:result => true}
  ans[:data] = data
  return JSON.pretty_generate(ans)
end

def findByItemBasePriceGTE(params)
  ans = {:result => true}

  query = "select `order`.orderId, `order`.orderDateTime, `order`.orderUserId, `order`.orderItemId, `order`.orderQuantity, `order`.orderState, `order`.orderTags from `order` inner join item on item.itemId=`order`.orderItemId where item.itemBasePrice>=#{params[:findByItemBasePriceGTE]} order by orderDateTime desc limit #{params[:limit]}"

  data = []
  orders = $client.query(query)
  orders.each do |order|
    order[:orderDateTime] = order["orderDateTime"].to_i
    order[:orderTags] = order["orderTags"].split(',')
    data << order
  end

  ans = {:result => true}
  ans[:data] = data
  return JSON.pretty_generate(ans)
end

def findByItemBasePriceLTE(params)
  ans = {:result => true}

  query = "select `order`.orderId, `order`.orderDateTime, `order`.orderUserId, `order`.orderItemId, `order`.orderQuantity, `order`.orderState, `order`.orderTags from `order` inner join item on item.itemId=`order`.orderItemId where item.itemBasePrice<=#{params[:findByItemBasePriceLTE]} order by orderDateTime desc limit #{params[:limit]}"

  data = []
  orders = $client.query(query)
  orders.each do |order|
    order[:orderDateTime] = order["orderDateTime"].to_i
    order[:orderTags] = order["orderTags"].split(',')
    data << order
  end

  ans = {:result => true}
  ans[:data] = data
  return JSON.pretty_generate(ans)
end

def findByItemTagsIncludeAll(params)
  searchTags = params[:findByItemTagsIncludeAll].split(',')
  query = "select `order`.orderId, `order`.orderDateTime, `order`.orderUserId, `order`.orderItemId, `order`.orderQuantity, `order`.orderState, `order`.orderTags from `order` inner join item on item.itemId=`order`.orderItemId where "
  searchTags.each do |tag|
    query += "FIND_IN_SET('#{tag}', item.itemTags) and "
  end
  query.sub!(/and $/, '')
  query += "order by orderDateTime desc limit #{params[:limit]}"

  data = []
  orders = $client.query(query)
  orders.each do |order|
    order["orderDateTime"] = order["orderDateTime"].to_i
    order["orderTags"] = order["orderTags"].split(',')
    data << order
  end

  ans = {:result => true}
  ans[:data] = data
  return JSON.pretty_generate(ans)
end

def findByItemTagsIncludeAny(params)
  searchTags = params[:findByItemTagsIncludeAny].split(',')
  query = "select `order`.orderId, `order`.orderDateTime, `order`.orderUserId, `order`.orderItemId, `order`.orderQuantity, `order`.orderState, `order`.orderTags from `order` inner join item on item.itemId=`order`.orderItemId where "
  searchTags.each do |tag|
    query += "FIND_IN_SET('#{tag}', item.itemTags) or "
  end
  query.sub!(/or $/, '')
  query += "order by orderDateTime desc limit #{params[:limit]}"

  p query

  data = []
  orders = $client.query(query)
  orders.each do |order|
    order["orderDateTime"] = order["orderDateTime"].to_i
    order["orderTags"] = order["orderTags"].split(',')
    data << order
  end

  ans = {:result => true}
  ans[:data] = data
  return JSON.pretty_generate(ans)
end
