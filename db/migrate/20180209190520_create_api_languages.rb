class CreateApiLanguages < ActiveRecord::Migration[5.1]
  def change
    create_table :api_languages do |t|

      t.timestamps
    end
  end
end
