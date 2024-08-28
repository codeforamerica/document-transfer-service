# frozen_string_literal: true

Sequel.migration do
  up do
    create_table(:jobs) do
      primary_key :id
      Integer :priority, default: 0
      Integer :attempts, default: 0
      String :handler, text: true
      DateTime :run_at
      DateTime :locked_at
      String :locked_by, text: true
      DateTime :failed_at
      String :last_error, text: true
      String :queue, size: 128
      String :cron

      index [:locked_at], name: :index_delayed_jobs_locked_at
      index %i[priority run_at], name: :index_delayed_jobs_run_at_priority
    end
  end

  down do
    drop_table(:jobs)
  end
end
