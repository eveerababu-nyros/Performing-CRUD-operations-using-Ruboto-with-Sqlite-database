require 'active_record'
require 'android_logger'

class Database
  def self.setup(context)
    ActiveRecord::Base.logger = AndroidLogger

    db_dir = "#{context.files_dir.path}/my_db.sqlite"
    connection_options = {
        :adapter => 'jdbcsqlite3',
        :driver => 'org.sqldroid.SQLDroidDriver',
        :url => "jdbc:sqldroid:#{db_dir}",
        :database => db_dir,
        :pool => 30,
        :timeout => 25000,
    }

    ActiveRecord::Base.configurations = {
        :production => connection_options,
    }

    ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations[:production])


	puts "*****************************"
	puts db_dir
  end

  def self.migrate(context)
    src_dir = 'file:' + context.package_manager.getApplicationInfo($package_name, 0).sourceDir + '!/'
    migration_path = File.expand_path("#{src_dir}/migrate")

	puts "########################################"
	puts migration_path
    puts "Looking for migration scripts in #{migration_path}"
    migrator = ActiveRecord::Migrator.new(:up, migration_path)
    if migrator.pending_migrations.size > 0
      puts "Found #{migrator.pending_migrations.size} migrations."
      migrator.migrate
    end
  end
end
