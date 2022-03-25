configure :production, :development do
    db = URI.parse(ENV['REDISTOGO_URL'] || 'redis://redistogo:86b2fe34c1932e19a382104bc32260aa@dory.redistogo.com:10094/')

    ActiveRecord::Base.establish_connection(
        :adapter => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
        :host => db.host,
        :username => db.user,
        :password => db.password,
        :database => db.path[1..-1],
        :encoding => 'utf8'
    )
end