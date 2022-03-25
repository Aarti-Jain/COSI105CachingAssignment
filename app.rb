require "redis"
require "sinatra/base"

require "sinatra"
require "sinatra/reloader"
require "sinatra/activerecord"
require "active_record"
require "sinatra/flash"
require_relative "./models/user.rb"

redis = Redis.new(url: "redis://redistogo:86b2fe34c1932e19a382104bc32260aa@dory.redistogo.com:10094/")

get '/home' do
    erb(:home)
end




get '/register' do 
    erb :signup, :layout => false
end

post '/signup' do 
    newUser = User.new({username: params[:username],display_name: params[:display_name],email: params[:email],password: params[:password],active: true})
    if(newUser.valid? and (params[:password] == params[:pw_confirm]))
        my_password = BCrypt::Password.create(params[:password])
        #redis.hset("user", "age", 30)
        redis.hset(params[:username],"username", params[:username])
        redis.hset(params[:username],"display_name",params[:display_name])
        redis.hset(params[:username],"email",params[:email])
        redis.hset(params[:username],"password",params[:password])
        redis.hset(params[:username],"active", true)
        redis.save()

        redirect "/home"
    else 
        if((params[:password] != params[:pw_confirm]))
            flash[:notice] = newUser.errors.full_messages.join("\r\n") + " Passwords do not match. Please try again."
        else  
            flash[:notice] = newUser.errors.full_messages.join("\r\n")
        end
        redirect '/register'
    end

end 





#User.create({username: params[:username],display_name: params[:display_name],email: params[:email],password: my_password,active: true})
        #session[:user] = newUser