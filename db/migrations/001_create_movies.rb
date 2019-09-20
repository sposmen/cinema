Sequel.migration do
  change do
    create_table(:movies) do
      primary_key :id
      String :name, null: false
      String :description
      String :image_url
      String :days_shown
    end
  end
end
