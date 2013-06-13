require 'ruboto/widget'
require 'ruboto/util/toast'
require 'ruboto/util/stack'
require 'database'
require 'person'

ruboto_import_widgets :Button, :LinearLayout, :TextView

# http://xkcd.com/378/

$user_id = 3
class Editperson
  def onCreate(bundle)
    super
    set_title 'Updating and Deleting the Person'
	self.setContentView(Ruboto::R::layout::edit_person)
			

	puts "########################## Printing user id value $$$$$$$$$$$$$$$$"
			# gathering values
	i = getIntent()
	userid = i.getStringExtra('personid')
	puts userid
	puts userid.class
	$user_id = userid.to_i
	@uname = i.getStringExtra('username')
	puts "############ Printing Username ##################"
	puts @uname
	puts $user_id
	puts $user_id.class
	@pwd = i.getStringExtra('password')
	@fname = i.getStringExtra('first_name')
	@lname = i.getStringExtra('last_name')
	@ph = i.getStringExtra('phone')
	@email = i.getStringExtra('email')

		
		#gathering text fields 
	person_name = findViewById(Ruboto::R::id::edit_Username)
	person_password = findViewById(Ruboto::R::id::edit_Password)
	person_firstname = findViewById(Ruboto::R::id::edit_FirstName)
	person_lastname = findViewById(Ruboto::R::id::edit_Lastname)
	person_phone = findViewById(Ruboto::R::id::edit_Phone)
	person_email = findViewById(Ruboto::R::id::edit_Email)


		#setting values to the textfields
	puts @uname
	person_name.setText(@uname)
	person_password.setText(@pwd)
	person_firstname.setText(@fname)
	person_lastname.setText(@lname)
	person_phone.setText(@ph)
	person_email.setText(@email)

		#taking buttons and applying events to the button
	btn_edit = 	findViewById(Ruboto::R::id::bt_Edit)
	btn_delete = findViewById(Ruboto::R::id::bt_Delete)
	btn_edit.setOnClickListener(OnClickListener.new(self))
	btn_delete.setOnClickListener(OnClickListener.new(self))		
  end
end

	
class OnClickListener
	def initialize(activity)
		@activity = activity
	end

	def onClick(view)

		case view.getText().to_s
			when 'Edit'
				@person_name = @activity.findViewById(Ruboto::R::id::edit_Username)
				@person_password = @activity.findViewById(Ruboto::R::id::edit_Password)
				@person_firstname = @activity.findViewById(Ruboto::R::id::edit_FirstName)
				@person_lastname = @activity.findViewById(Ruboto::R::id::edit_Lastname)
				@person_phone = @activity.findViewById(Ruboto::R::id::edit_Phone)
				@person_email = @activity.findViewById(Ruboto::R::id::edit_Email)

				username_value = @person_name.getText().to_s
				password_value = @person_password.getText().to_s
				firstname_value = @person_firstname.getText().to_s
				lastname_value = @person_lastname.getText().to_s
				phone_value = @person_phone.getText().to_s
				email_value = @person_email.getText().to_s
				
				dialog = android.app.ProgressDialog.show(@activity, 'Updating Person', 'Loading...')
				Thread.with_large_stack 128 do
				  Person.update($user_id, :name => username_value, :password => password_value, :fname => firstname_value, :lname => lastname_value, :phnumber => phone_value, :email => email_value)
	
				i = android.content.Intent.new
				i.setClassName($package_name, 'org.ruboto.rubotocrud.crud_in_ruboto.CrudInRubotoActivity')
				i.putExtra('personmain',"hello")
				@activity.startActivity(i)	
				  dialog.dismiss
				end
			
		when 'Delete'			
				puts $user_id
				dialog = android.app.ProgressDialog.show(@activity, 'Deleting Person', 'Loading...')
				Thread.with_large_stack 128 do
				  Person.destroy($user_id)

				i = android.content.Intent.new
				i.setClassName($package_name, 'org.ruboto.rubotocrud.crud_in_ruboto.CrudInRubotoActivity')
				i.putExtra('personmain',"hello")
				@activity.startActivity(i)
				@activity.finish()

				  dialog.dismiss
				end
		end
	end
	
end
