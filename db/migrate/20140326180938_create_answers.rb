class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.column :answers, :string
      t.column :question_id, :integer

      t.timestamps
    end
  end
end
