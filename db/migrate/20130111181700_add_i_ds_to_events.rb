class AddIDsToEvents < ActiveRecord::Migration
  def change
    add_column :events , :google_event_id, :string
    add_column :events, :survey_url, :string
  end
end
