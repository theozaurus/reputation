require 'rubygems'
require 'bundler/setup'
require 'spec/rake/spectask'

Spec::Rake::SpecTask.new(:spec => ["generator:cleanup", "generator:reputation"])
Bundler::GemHelper.install_tasks

task :default => :spec

namespace :generator do
  desc "Cleans up the test app before running the generator"
  task :cleanup do
    FileList["spec/rails_root/db/migrate/*_reputation_create_tables.rb","spec/rails_root/db/*.sqlite3"].each do |each|
      FileUtils.rm_rf(each)
    end

    FileUtils.rm_rf("spec/rails_root/vendor/plugins/reputation")
    FileUtils.mkdir_p("spec/rails_root/vendor/plugins")
    reputation_root = File.expand_path(File.dirname(__FILE__))
    system("ln -s #{reputation_root} spec/rails_root/vendor/plugins/reputation")
  end

  desc "Run the reputation generator"
  task :reputation do
    system "cd spec/rails_root && ./script/generate reputation && rake db:migrate db:test:prepare"
  end
end