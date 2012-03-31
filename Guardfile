# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard :test do
  watch(%r{^lib/(.+)\.rb$}) { |m| "test/#{m[1]}_test.rb" }
  watch(%r{^test/.+_test\.rb$})
  watch('test/test_helper.rb') { "test" }

  # Rails example
  watch(%r{^app/models/(.+)\.rb$}) { |m| "test/unit/#{m[1]}_test.rb" }
  # watch(%r{^app/controllers/(.+)\.rb$}) { |m| "test/integration/#{m[1]}_test.rb" }
  # watch(%r{^app/controllers/admin/(.+)\.rb$}) { |m| "test/integration/admin#{m[1]}_test.rb" }
  watch(%r{^app/views/.+\.rb$}) { "test/integration/admin" }
  #watch('app/controllers/application_controller.rb') { ["test/functional",   #"test/integration"] }
end

guard :spork, :test_unit => false, :test_unit_env => { 'RAILS_ENV' => 'test' } do
  watch('config/application.rb')
  watch('config/environment.rb')
  watch(%r{^config/environments/.+\.rb$})
  watch(%r{^config/initializers/.+\.rb$})
  watch('Gemfile')
  watch('Gemfile.lock')
  watch('test/test_helper.rb') { :test_unit }
end
