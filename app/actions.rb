helpers do
    def current_user
        User.find_by(id: session[:user_id])
    end
end

get '/' do
    @posts = Post.order(created_at: :desc)
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
    erb :login
end

post '/login' do
    
    username = params[:username]
    password = params[:password]
    
    user = User.find_by(username: username)
    
    if user && user.password == password
        
        session[:user_id] = user.id
        redirect '/'

    else
        
        @error_message = "Login failed."
        erb :login
        
    end
    
end

get '/logout' do
    session[:user_id] = nil
    redirect '/login'
end

