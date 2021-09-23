class ChangeColumnNameOfBug < ActiveRecord::Migration[5.2]
  def change
    rename_column :bugs, :bug_type, :bugtype
  end
end
