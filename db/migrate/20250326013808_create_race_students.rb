class CreateRaceStudents < ActiveRecord::Migration[8.0]
  def change
    create_table :race_students do |t|
      t.references :race, null: false, foreign_key: true
      t.references :student, null: false, foreign_key: true
      t.integer :lane, null: false
      t.integer :place

      t.timestamps
    end

    add_index :race_students, [:race_id, :lane], unique: true
    add_index :race_students, [:race_id, :student_id], unique: true
    add_index :race_students, [:race_id, :place]
  end
end
