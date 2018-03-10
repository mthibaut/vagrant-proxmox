require 'rake'
require 'rake/clean'
require 'rubygems'
require 'bundler/setup'
require 'rubygems/gem_runner'
require 'rspec/core/rake_task'
require 'geminabox_client'
require 'yaml'

gemspec = eval(File.read 'vagrant-proxmox.gemspec')

desc 'Build the project'
task :build do
  Gem::GemRunner.new.run ['build', "#{gemspec.name}.gemspec"]
end

RSpec::Core::RakeTask.new

desc 'Run RSpec code examples with coverage'
RSpec::Core::RakeTask.new('spec_coverage') do |_|
  ENV['RUN_WITH_COVERAGE'] = 'true'
end

require 'github_changelog_generator/task'

GitHubChangelogGenerator::RakeTask.new :changelog do |config|
  config.since_tag = 'v0.0.10'
  config.future_release = 'v0.2.0'
end

task :release_local do
  rake_config = YAML::load(File.read("#{ENV['HOME']}/.rake/rake.yml")) rescue {}
  GeminaboxClient.new(rake_config['geminabox']['url']).push "#{gemspec.name}-#{gemspec.version}.gem", overwrite: true
  puts "Gem #{gemspec.name} pushed to #{rake_config['geminabox']['url']}"
end

task :release_rubygems  do
  `gem push "#{gemspec.name}-#{gemspec.version}.gem"`
end

task release_all: [:release_local, :release_rubygems]

namespace :jenkins do
  task job: [:build, :spec_coverage, :release_all]
end

namespace :test do

  desc 'Run all tests (enable coverage with COVERAGE=y)'
  task :all do
    Rake::Task['test:rspec'].invoke
    Rake::Task['test:cucumber'].invoke
  end

  desc 'Run all rspec tests (enable coverage with COVERAGE=y)'
  task :rspec do
    require 'rspec/core/rake_task'
    RSpec::Core::RakeTask.new(:_specs) do |task|
      task.verbose = false
    end
    Rake::Task['_specs'].invoke
  end

  desc 'Run all cucumber tests (enable coverage with COVERAGE=y)'
  task :cucumber do
    require 'cucumber/rake/task'

    Cucumber::Rake::Task.new(:_features) do |task|
      task.cucumber_opts = '--quiet --format progress --require features features'
    end
    Rake::Task['_features'].invoke
  end

end
