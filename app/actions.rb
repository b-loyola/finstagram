helpers do
    def current_user
        User.find_by(id: session[:user_id])
    end
end

get '/' do
    @posts = Post.order(created_at: :desc)
    # @current_user = User.find_by(id: session[:user_id])
    erb :index
end

get '/signup' do
    @user = User.new
    erb :signup
end

post '/signup' do
    
    #collect user data from params hash
    email = params[:email]
    avatar_url = params[:avatar_url]
    username = params[:username]
    password = params[:password]
    
    @user = User.new({email: email, avatar_url: avatar_url, username: username, password: password})
    
    #if fields were entered correctly
    if @user.save
        redirect '/login'
    else
        erb :signup #display form
    end
end

get '/login' do
    if session[:logout_message]
        @logout_message = session[:logout_message]
        session[:logout_message] = nil
    end
    erb :login
end

post '/login' do
    
    username = params[:username]
    password = params[:password]
    
    user = User.find_by(username: username)
    
    if user && user.password == password
        
        session[:user_id] = user.id
        redirect(to('/'))

    else
        
        @error_message = "Login failed."
        erb :login
        
    end
    
end

get '/logout' do
    
    if current_user
        username = current_user.username
        session[:user_id] = nil
        session[:logout_message] = "User #{username} successfully logged out."
    end
    
    redirect(to('/login'))
end

get '/posts/new' do
    @post = Post.new
    erb(:"posts/new")
end

post '/posts' do
    photo_url = params[:photo_url]
    
    @post = Post.new({ photo_url: photo_url, user_id: current_user.id })
    
    if @post.save
        redirect(to('/'))
    else
        erb(:"posts/new")
    end
end

get '/posts/:id' do
    @post = Post.find(params[:id])
    erb(:"posts/show")
end
    
post '/comments' do
    comment_text = params[:text]
    post_id = params[:post_id]
    
    comment = Comment.new({text: comment_text, user_id: current_user.id, post_id: post_id})
    
    comment.save
    
    redirect(back)
    
end

post '/likes' do
    post_id = params[:post_id]
    
    like = Like.new({ user_id: current_user.id, post_id: post_id})
    
    like.save
    
    redirect(back)
    
end

delete '/likes/:id' do
    like = Like.find_by( id: params[:id])
    like.destroy
    
    redirect(back)
end
