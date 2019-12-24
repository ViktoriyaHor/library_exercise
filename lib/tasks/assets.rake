# namespace :assets do
#   # Prepend the assets:precompile_prepare task to assets:precompile.
#   task :precompile => :precompile_prepare
#
#   # This task will be called before assets:precompile to optimize the
#   # compilation, i.e. to prevent any DB calls.
#   task 'precompile_prepare' do
#     # Without this assets:precompile will call itself again with this var set.
#     # This basically speeds things up.
#     uri = 'mongodb://heroku_lpkgwvk4:u05tsb93gsraseu3olla83sg4h@ds253418.mlab.com:53418/heroku_lpkgwvk4?retryWrites=false'
#   end
# end

Rake::Task['assets:precompile'].enhance do
  Rake::Task['webpacker:compile'].invoke
end