class DepartmentUser < ActiveRecord::Base

  belongs_to :department
  belongs_to :user
  
  attr_accessible :department_id, :user_id
  
end
