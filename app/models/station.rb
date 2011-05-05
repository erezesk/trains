# == Schema Information
# Schema version: 20110505174913
#
# Table name: stations
#
#  id         :integer         not null, primary key
#  number     :string(255)
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Station < ActiveRecord::Base
  attr_accessible :number, :name
  
  validates_presence_of   :number, :name
end
