namespace :setup do
  desc "Setup the development environment"
  task :dev => :environment do
    paths = Dir.glob(File.join(Rails.root, 'public/system', '*'))
    paths.each do |path|
      FileUtils.remove_dir(path)
    end
    # drop actually deletes the .sqlite3 file, which is not what we want on test
    unless ENV['RAILS_ENV'].eql? "test"
      Rake::Task["db:drop"].invoke
    end
    Rake::Task["db:setup"].invoke
    Rake::Task["db:seed"].invoke
    Rake::Task["db:populate"].invoke
  end
end
