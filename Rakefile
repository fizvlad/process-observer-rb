require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = Dir[ "test/**/test_*.rb" ]
end

task :doc do
  puts `yardoc`
end

task :default => :test
