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

  # findByOrder
  queryOrderWhere = findByOrder(params)
  queryOrderWhere.sub!(/and $/, '')
  queryOrderWhere.sub!(/or $/, '')
  query = "select * from `order` where " + queryOrderWhere + " order by orderDateTime desc limit #{params[:limit]}"
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
  # findByUser


  return ans
end

def findByOrder(params)
  query = ""
  if params.has_key?("findByOrderDateTimeGTE")
    query += "orderDateTime >= #{params[:findByOrderDateTimeGTE]} and "
  end
  if params.has_key?("findByOrderDateTimeLTE")
    query += "orderDateTime <= #{params[:findByOrderDateTimeLTE]} and "
  end
  if params.has_key?("findByOrderUserId")
    query += "orderUserId = '#{params[:findByOrderUserId]}' and "
  end
  if params.has_key?("findByOrderItemId")
    query += "orderItemId = '#{params[:findByOrderItemId]}' and "
  end
  if params.has_key?("findByOrderQuantityGTE")
    query += "orderQuantity >= #{params[:findByOrderQuantityGTE]} and "
  end
  if params.has_key?("findByOrderQuantityLTE")
    query += "orderQuantity <= #{params[:findByOrderQuantityLTE]} and "
  end
  if params.has_key?("findByOrderState")
    query += "orderState = '#{params[:findByOrderState]}' and "
  end
  if params.has_key?("findByOrderTagsIncludeAll")
    searchTags = params[:findByOrderTagsIncludeAll].split(',')
    searchTags.each do |tag|
      query += "FIND_IN_SET('#{tag}', orderTags) and "
    end
  end
  if params.has_key?("findByOrderTagsIncludeAny")
    searchTags = params[:findByOrderTagsIncludeAny].split(',')
    query += "("
    searchTags.each do |tag|
      query += "FIND_IN_SET('#{tag}', orderTags) or "
    end
    query.sub!(/or $/, '')
    query += ")"
  end
  return query
end

def findByUser(params)

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
              :orderTags     => order[:orderTags].split(',')
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
              :orderTags     => order[:orderTags].split(',')
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
