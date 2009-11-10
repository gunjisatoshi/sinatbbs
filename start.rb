require 'rubygems'
require 'sinatra'
require 'model/comment.rb'

helpers do
  include Rack::Utils; alias_method :h, :escape_html

  def pagination_links(collection)
    html = ['Page:']
    if collection.page > 1
      html << "<a href=\"?page=#{collection.page - 1}\">&lt;</a>"
    end
    (1..collection.num_pages).each do |page|
      if page == collection.page
        html << "<span style=\"font-weight: bold;\">#{page}</span>"
      else
        html << "<a href=\"?page=#{page}\">#{page}</a>"
      end
    end
    if collection.page < collection.num_pages
      html << "<a href=\"?page=#{collection.page + 1}\">&gt;</a>"
    end
    html.join(' ')
  end
end

get '/style.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :style
end

get '/' do
  @comments = Comments.paginate({
    :order => [:posted_date.desc],
    :per_page => 5,
    :page => params[:page],
  })
  haml :index
end

put '/comment' do
  Comments.create({
    :name => request[:name],
    :title => request[:title],
    :message => request[:message],
    :posted_date => Time.now,
  })
  redirect '/'
end

get '/comment/:id' do
  @comment = Comments.get(params[:id])
  haml :comment
end

get '/comment/:id/' do
  redirect "/comment/#{params[:id]}", 301
end
