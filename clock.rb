require './config/boot'
require './config/environment'
require 'rails'

loop do
  puts 'SINCRONIZANDO OS BOLETOS'
  KobanaJob.perform_later('update_base')
  sleep(1800) #30 minutos
end
