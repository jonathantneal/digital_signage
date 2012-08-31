class DropDefaultDelayForSlides < ActiveRecord::Migration
  def up
    change_column_default(:slides, :delay, nil)
  end

  def down
    change_column_default(:slides, :delay, 5)
  end
end
