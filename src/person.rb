require 'active_record'

class Person < ActiveRecord::Base
	attr_accessible :name, :password, :fname, :lname, :phnumber, :email
end
