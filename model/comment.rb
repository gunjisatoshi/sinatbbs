gem "dm-core", "0.9.11"

require 'dm-core'
require 'dm-aggregates'
require 'dm-types'
require 'dm-datastore-adapter/datastore-adapter'

DataMapper.setup(:datastore,
                 :adapter => :datastore,
                 :database => 'comments')

class Comments
  include DataMapper::Resource
  def self.default_repository_name; :datastore end
  property :id,         Serial
  property :name,       String
  property :title,       String
  property :message,       Text,     :lazy => false
  property :posted_date, DateTime

  def date
    (self.posted_date.new_offset(Rational(3, 8))).strftime("%Y-%m-%d %H:%M:%S")
  end

  def formatted_message
    Rack::Utils.escape_html(self.message).gsub(/\n/, "<br>")
  end
end
