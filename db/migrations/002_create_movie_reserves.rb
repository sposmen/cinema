Sequel.migration do
  change do
    create_table(:movie_reserves) do
      primary_key([:movie_id, :date], name: :movie_date)
      Integer :movie_id, null: false
      Date :date, null: false
      String :person_list
    end
  end
end
