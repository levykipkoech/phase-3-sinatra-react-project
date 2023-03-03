# class ApplicationController < Sinatra::Base
#   enable :sessions
#   set :session_secret, 'my_secret_key'

#   def authenticate_user!
#     if !current_user
#       flash[:error] = "You need to be logged in to access this page."
#       redirect '/login'
#     end
#   end

#   def current_user
#     @current_user ||= User.find_by(id: session[:user_id])
#   end

#   before do
#     redirect '/login' unless logged_in?
#   end

#   get '/memes/new' do
#     memes = Meme.new 
#     memes.new
#     puts "new memes"
#   end

#   post '/memes' do
#     meme = Meme.new(params[:meme])

#     if meme.save
#       redirect '/memes'
#     else
#       flash[:error] = "Meme could not be created."
#     end
#   end

#   get '/memes' do
#     if current_user
#       memes = current_user.memes
#     else
#       memes = Meme.all
#     end

#     puts "I love memes"
    
#   end

#   get '/memes/search' do
#     if params[:query].present?
#       memes = Meme.where("title LIKE ?", "%#{params[:query]}%").or(Meme.where("published_date LIKE ?", "%#{params[:query]}%"))
#     else
#       memes = []
#     end
#     erb :'memes/search'
#   end

#   get '/memes/:id/edit' do
#     meme = current_user.memes.find_by(id: params[:id])
#     if meme
      
#     else
#       redirect '/memes'
#     end
#   end

#   put '/memes/:id' do
#     meme = current_user.memes.find_by(id: params[:id])
#     if meme
#       if meme.update(params[:meme])
#         redirect "/memes/#{meme.id}"
#       else
#         redirect '/memes'
#       end
#     end
#   end

#   delete '/memes/:id' do
#     meme = Meme.find(params[:id])
#     if meme.user_id == current_user.id # check if the user who added the meme is the current user
#       meme.destroy
#       redirect '/memes'
#     else
#       flash[:error] = "You can only delete memes that you added."
#       redirect back
#     end
#   end
# end


class MemeController < ApplicationController

  set :views, './app/views'

  
  get '/home' do
      "Welcome To the meme app"
  end

   
  post '/memes/create' do
      begin
          memes = Meme.create( self.data(create: true) )
          json_response(code: 201, data: memes)
      rescue => e
          json_response(code: 422, data: { error: e.message })
      end
  end

   
  get '/memes' do
      memes = Meme.all
      json_response(data: memes)
  end

  # @view: Renders an erb file which shows all TODOs
  # erb has content_type because we want to override the default set above
  # get '/' do
  #     @todos = Todo.all.map { |todo|
  #       {
  #         todo: todo,
  #         badge: todo_status_badge(todo.status)
  #       }
  #     }
  #     @i = 1
  #     erb_response :todos
  # end

   
  put '/memes/update/:id' do
      begin
          memes = Meme.find_by(self.memes_id)
          memes.update(self.data)
          json_response(data: { message: "memes updated successfully" })
      rescue => e
          json_response(code: 422 ,data: { error: e.message })
      end
  end

   get '/memes/search' do
        if params[:query].present?
          memes = Meme.where("title LIKE ?", "%#{params[:query]}%").or(Meme.where("published_date LIKE ?", "%#{params[:query]}%"))
        else
          memes = []
        end
         json_response(data: memes)
      end
   
  delete '/memes/destroy/:id' do
      begin
          memes = Meme.find(self.memes_id)
          memes.destroy
          json_response(data: { message: "Meme deleted successfully" })
      rescue => e
        json_response(code: 422, data: { error: e.message })
      end
  end


  private

   
  def data(create: false)
      payload = JSON.parse(request.body.read)
      if create
          payload["createdAt"] = Time.now
      end
      payload
  end

   
  def memes_id
      params['id'].to_i
  end

   
  def memes_status_badge(status)
      case status
          when 'CREATED'
              'bg-info'
          when 'ONGOING'
              'bg-success'
          when 'CANCELLED'
              'bg-primary'
          when 'COMPLETED'
              'bg-warning'
          else
              'bg-dark'
      end
  end


end
