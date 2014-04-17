namespace :sync do
  desc "Sync down all data for all integrations"
  task :all => :environment do
    Integration.find_each do |integration|
      service = Wunderlist.new(integration.access_token)
      worker = SyncWorker.new(service)
      worker.call
    end
  end
end
