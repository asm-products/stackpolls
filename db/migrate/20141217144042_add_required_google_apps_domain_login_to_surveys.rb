class AddRequiredGoogleAppsDomainLoginToSurveys < ActiveRecord::Migration
  def change
    add_column :surveys, :required_google_apps_domain_login, :string
  end
end
