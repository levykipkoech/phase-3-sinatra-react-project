class ApplicationController < Sinatra::Base
  
    get '/memes/new' do
      erb :'memes/new'
    end
    
    post '/memes' do
      @meme = Meme.new(params[:meme])
      
      if @meme.save
        redirect '/memes'
      else
        erb :'memes/new'
      end
    end
  
  

end
