require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'appraisal'

RSpec::Core::RakeTask.new(:spec)

if !ENV["APPRAISAL_INITIALIZED"] && !ENV["TRAVIS"]
  task :default => :appraisal
else
  task :default => :spec
end

desc 'Run specs for all adapters'
task :spec_all do
  %w[active_record mongoid].each do |model_adapter|
    puts "ADAPTER = #{model_adapter}"
    system "ADAPTER=#{model_adapter} rake"
  end
end
