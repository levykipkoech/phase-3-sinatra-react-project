class MemesController < Sinatra::Base

  before do
    redirect '/login' unless logged_in?
  end

  
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
      
    get '/memes' do
      @memes = Meme.all
      erb :'memes/index'
    end

    get '/memes' do
      if current_user
        @memes = current_user.memes
      else
        @memes = Meme.all
      end
      erb :'memes/index'
    end

    get '/memes/search' do
      if params[:query].present?
        @memes = Meme.where("title LIKE ?", "%#{params[:query]}%").or(Meme.where("published_date LIKE ?", "%#{params[:query]}%"))
      else
        @memes = []
      end
      erb :'memes/search'
    end

    get '/memes/:id/edit' do
      @meme = current_user.memes.find_by(id: params[:id])
      if @meme
        erb :'memes/edit'
      else
        redirect '/memes'
      end
    end

    put '/memes/:id' do
      @meme = current_user.memes.find_by(id: params[:id])
      if @meme
        if @meme.update(params[:meme])
          redirect "/memes/#{meme.id}"
        else
          erb :'memes/edit'
        end
      else
        redirect '/memes'
      end
    end

    delete '/memes/:id' do
      @meme = Meme.find(params[:id])
      if @meme.user_id == current_user.id # check if the user who added the meme is the current user
        @meme.destroy
        redirect '/memes'
      else
        flash[:error] = "You can only delete memes that you added."
        redirect back
      end
    end
    


end
