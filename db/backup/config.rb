Backup::Model.new(:widget_library, 'OAE Widget Library database and assets') do

  # Back up the mysql database
  database MySQL do |db|
    db.name               = 'db-name'
    db.username           = 'username'
    db.password           = 'password'
    db.host               = "myhost"
    db.additional_options = ['--single-transaction', '--quick']
    db.socket             = "mysql/socket/directory/mysql.sock"
  end

  # Archive the user data (avatars, bundles, codes, icons and images)
  archive :user_data do |archive|
    archive.add '../../public/system'
  end

  # compress the database with Gzip
  compress_with Gzip do |compression|
    compression.best = true
  end

  # store files at .path and .keep 5 backups at a time
  store_with Local do |local|
    local.path = './backups/'
    local.keep = 5
  end

end