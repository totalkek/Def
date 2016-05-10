require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
#require 'active_record'
require 'mysql2'

#для скачивания страницы
require 'net/http'
require 'uri'

# this takes a hash of options, almost all of which map directly
# to the familiar database.yml in rails
# See http://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/MysqlAdapter.html
client = Mysql2::Client.new(:host => "149.154.66.33",
                            :username => "base",
                            :password => 'gfhfvfeyn4',
                            :database => 'book_base')
configure do
  enable :sessions
end

helpers do
  def username
    session[:identity] ? session[:identity] : 'Привет, искатель!'
  end
end

before '/secure/*' do
  unless session[:identity]
    session[:previous_url] = request.path
    @error = 'Вам нужно пройти авторизацию для посещения профиля ' + request.path
    halt erb(:login_form)
  end
end

get '/' do
  erb 'Слабо попасть в <a href="/secure/place">профиль</a>, придурок??'
end

get '/login/form' do
  erb :login_form
end

post '/login/attempt' do
  if params[:username] == 'admin' && params[:password] == '123'
  session[:identity] = params['username']
  end
  where_user_came_from = session[:previous_url] || '/'
  redirect to where_user_came_from
end

get '/logout' do
  session.delete(:identity)
  erb "<div class='alert alert-message'>Logged out</div>"
end

get '/secure/place' do
  erb 'Это личная страница пользователя <%=session[:identity]%>!'
end

get '/about' do
	erb :about
end

get '/contacts' do
	erb :contacts
end

post '/contacts' do
	@messenge = params[:messege]
	@email = params[:email]
	f = File.open './public/messege.txt', 'a'
	f.write "E-mail: #{@email}\nСообщение: #{@messenge}\n"
	f.close
	@messege = "Спасибо за обращение!"
	erb :contacts
end

get '/visit' do
	erb :visit
end

post '/visit' do
	@namec = params[:namec]
	@phone = params[:phone]
	@datetime = params[:datetime]
	@master = params[:master]
	f = File.open './public/users.txt', 'a'
	f.write "User: #{@namec}, Phone #{@phone}, Date #{@datetime}, Мастер #{@master}\n"
	f.close
	@messege = "Спасибо, вы записаны"
	erb :visit
end

get '/catalog' do
  erb :catalog
end

post '/catalog' do
	@bookurl = params[:bookurl]
	f = File.open './public/users.txt', 'a'
	f.write "Book: #{@bookurl}\n"
	f.close

  #uri = URI(@bookurl)
  #res = Net::HTTP.get(uri)

  if open(@bookurl).read =~ "/512/"
  @messege = "Спасибо, вы записаны"
end

	#@messege = "Спасибо, вы записаны"
	erb :catalog
end

get '/catalog' do
  erb :catalog
end
