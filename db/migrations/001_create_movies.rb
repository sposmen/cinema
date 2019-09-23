# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:movies) do
      primary_key :id
      String :name, null: false
      String :description
      String :image_url
      Integer :days_shown, null: false, default: 0
    end
  end
end
