namespace :curation_concerns do
  desc 'Print a count of each object type'
  task count: [:environment] do
    Rails.application.eager_load!
    puts "Number of objects in fedora:"
    ActiveFedora::Base.descendants.each do |model|
      puts "  #{model}: #{model.count}"
    end
  end
  namespace :migrate do
    desc "Migrate collections"
    task collections: :index do
      Collection.all.each do |collection|
        collection.members.each do |member|
          member.member_of_collections << collection
          member.save
        end
        collection.members = []
        collection.save
      end
    end
  end
end
namespace :curation_concerns do
  namespace :solr do
    desc "Enqueue a job to resolrize the repository objects"
    task reindex: :environment do
      ResolrizeJob.perform_later
    end
  end
end
