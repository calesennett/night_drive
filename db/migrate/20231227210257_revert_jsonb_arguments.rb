class RevertJsonbArguments < ActiveRecord::Migration[7.1]
  def change
    change_column :solid_queue_jobs, :arguments, :text
  end
end
