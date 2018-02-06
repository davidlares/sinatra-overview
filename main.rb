require "sinatra"

#route
get '/' do
  @valor = 10
  erb :home, layout: :main 
end

get '/feed' do 
	@files = Dir.entries('feeds') 
	# arreglo con los txts -> guardados en una var de instancia

	# server side
	# @files.each do |file|
	# 	"The file found is: #{file}"
	# end

	#web client side -> ver feeds.erb
	erb :feeds, layout: :main 
end

get '/workshop/:workshop' do 
	@workshop = params['workshop'] # variante: param[:workshop]
	@description = workshop_content(params[:workshop])
	erb :workshop, layout: :main 
end

get '/create' do
	erb :create, layout: :main 
end

get '/:feed/edit' do
	@workshop = params["feed"]
	@description = workshop_content(@workshop)
	erb :edit, layout: :main 
end


post '/create' do 
	# params.name -> metodo para traer los parametros
	@name = params["feed"]
	@description = params["description"]
	# guardar archivo txt
	save_workshop(@name,@description)
	# hay que definir un return, ya que sino Ruby toma la ultima linea
	#return "<p>Feed: #{@name} - Description: #{@description}</p>"
	erb :success, layout: :main 
end

put '/:feed/edit' do
	save_workshop(params[:feed], params[:description])
	redirect URI.escape("/workshop/#{params[:feed]}")
end


delete '/delete/:feed' do
	@feed = params[:feed]
	delete_workshop(@feed)
	@message = "Feed deleted Successfully"
	erb :deleted, layout: :main  # same message file for diferent statuses
end

# this is a independent function

def workshop_content(name)
	File.read("feeds/#{name}.txt")
rescue Errno::ENOENT
	return nil
end

def save_workshop(name,desc)
	File.open("feeds/#{name}.txt", "w") do |file|
		file.print(desc)
	end
end

def delete_workshop(name)
	File.delete("feeds/#{name}.txt")
end