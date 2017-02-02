module Spotlight
  ##
  # a log entry representing an attempt to reindex some number of records in an exhibit
  class ReindexingLogEntry < ActiveRecord::Base
    enum job_status: { unstarted: 0, in_progress: 1, succeeded: 2, failed: 3 }

    belongs_to :exhibit, class_name: 'Spotlight::Exhibit'
    belongs_to :user, class_name: '::User'

    # null start times sort to the top, to more easily surface pending reindexing
    default_scope { order('start_time IS NOT NULL, start_time DESC') }
    scope :recent, -> { limit(5) }

    after_save do
      Spotlight::ExhibitIndexingChannel.broadcast_to(exhibit, ReindexProgress.new(self))
    end

    def duration
      end_time - start_time if end_time
    end

    def in_progress!
      self.start_time = Time.zone.now
      super
    rescue
      Rails.logger.error "unexpected error updating log entry to :in_progress from #{caller}"
    end

    def succeeded!
      self.end_time = Time.zone.now
      super
    rescue
      Rails.logger.error "unexpected error updating log entry to :succeeded from #{caller}"
    end

    def failed!
      self.end_time = Time.zone.now
      super
    rescue
      Rails.logger.error "unexpected error updating log entry to :failed from #{caller}"
    end
  end
end
