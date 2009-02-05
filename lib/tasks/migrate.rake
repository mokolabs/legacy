require 'migration_helper'
require 'text_helper'

namespace :db do

  namespace :migrate do
  
    desc 'Migrates legacy content'
    task :legacy => ["architects", "styles"]
    
    desc 'Migrates styles'
    task :styles => :environment do
      migrate :styles
    end
    
    desc 'Migrates theaters'
    task :theaters => :environment do
      migrate :theaters
      # migrate :theaters, :helper => :migrate_theaters
    end
    
	end
end

# COMPLEX MIGRATION HELPERS

def migrate_theaters
  
  # Delete all theaters if delete_all=true
  Theater.delete_all if ENV['delete_all']

  # Set default conditions
  conditions = ["status_publish = 'Yes' AND location_address1 != '' AND location_address1 IS NOT NULL"]
  unless ENV['country_id'].blank?
    conditions.first << " AND country_id = ?"
    conditions << ENV['country_id']
  end

  # Set counters to monitor migration
  success, failure, skipped = 0, 0, 0
  
  # Migrate theaters
  puts "\nMigrating #{number_of_records || "all"} theaters #{"after #{offset_for_records}\n\n" if offset_for_records}"
  LegacyTheater.find(:all, with(:conditions => conditions)).each_with_index do |record, i|

    # Migrate theater
    new_record = record.migrate
    address_parts = [new_record.address1, new_record.city_name, new_record.state_id, new_record.country_id]
    message = "#{new_record.name} (#{record.id}): #{address_parts.join ', '}"

    if Theater.exists?(record.id)
      puts "#{i+1} SKIP #{message}\n\n"
      skipped += 1
    elsif new_record.save
      puts "#{i+1} PASS #{message}\n\n"
      success += 1
    else
      puts "#{i+1} FAIL #{message}\n#{new_record.inspect}\n\n"
      failure += 1
    end
    
    # Save legacy data
    new_record = Legacy.new(:theater_id => record.id,
                            :name => record.name_present.squish,
                            :status_id => record.status_id,
                            :submit_email => record.submit_email.squish,
                            :submit_name => record.submit_name.squish,
                            :submit_comments => record.submit_comments.squish,
                            :photo => record.photo,
                            :photo_caption => record.photo_caption.squish,
                            :photo_source => record.photo_source.squish,
                            :photo_email => record.photo_email.squish,
                            :photo_website => record.photo_website.squish,
                            :photo_card => record.photo_card.squish,
                            :date_built => record.date_built.squish,
                            :date_renovated => record.date_renovated.squish,
                            :date_closed => record.date_closed.squish,
                            :date_demolished => record.date_demolished.squish,
                            :landmark_status => record.landmark_status.squish,
                            :landmark_date => record.landmark_date.squish,
                            :legal_agree => record.legal_agree,
                            :legal_version => record.legal_version,
                            :allow_comments => record.allow_comments,
                            :user_id => record.user_id)
    new_record.save
  end

  # Batch stats
  percentage = (failure.to_f / number_of_records.to_f).to_f * 100
  puts "BATCH: #{number_of_records} theaters => #{success} passed, #{failure} failed (#{percentage.truncate}%), #{skipped} skipped (already imported)"
  
  # Total stats
  success = Theater.count(:all)
  failure = InvalidTheater.count(:all)
  percentage = (failure.to_f / (failure + success)).to_f * 100
  puts "\nTOTAL: #{failure + success} theaters => #{success} passed, #{failure} failed (#{percentage.truncate}%)"
end
