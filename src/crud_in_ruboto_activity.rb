require 'ruboto/widget'
require 'ruboto/util/stack'
require 'ruboto/util/toast'

require 'person'
require 'database'

ruboto_import_widgets :Button, :LinearLayout, :ListView, :RelativeLayout, :EditText

# http://xkcd.com/378/

class CrudInRubotoActivity
  def onCreate(bundle)
    super
    setTitle 'People'

    self.content_view = linear_layout :orientation => :vertical do
		relative_layout do
	  	  btn = button :text => 'new', :width => :wrap_content, :height => :wrap_content, :id => 43, :on_click_listener => proc { addNewPeople } 
		end

      @list_view = list_view :list => [], :on_item_click_listener => (proc{|av, v, p, i| displayPerson(p)})

    end
  end

  def onResume
    super

		i = getIntent
		puts i.getStringExtra('personmain')
    dialog = android.app.ProgressDialog.show(self, 'SQLite ActiveRecord Example', 'Loading...')
    Thread.with_large_stack 128 do
      
      Database.setup(self)
      run_on_ui_thread{dialog.message = 'Generating DB schema...'}


		#Person.all.length == 0


      Database.migrate(self)
      run_on_ui_thread{dialog.message = 'Populating table...'}
		     
	 # Person.create(:name => 'veerababu', :password => 'veeru', :fname => 'veerababu', :lname => 'e', :phnumber => '9989', :email => 'veeru4soft@gmail.com')

	 # Person.create(:name => 'suresh', :password => 'suresh', :fname => 'suresh', :lname => 'b', :phnumber => '9989', :email => 'suresh@gmail.com' )
     
	  people_names = Person.order(:name).all.map(&:name)

		puts "Records in the table are: "
		puts Person.all.length
      run_on_ui_thread do
        @list_view.adapter.add_all people_names
        dialog.dismiss
      end
    end
  end

   def addNewPeople
		intent = android.content.Intent.new('android.intent.action.NEWPERSON')
		startActivity(intent)
   end

   def displayPerson(position)
		puts "Entered"
		person_name = @list_view.getItemAtPosition(position)
		puts person_name
		puts position
		Thread.with_large_stack 128 do
			person_details = Person.find_by_name(person_name)
			puts "%%%%%%%%%%%%%%%%%%%"
			puts person_details.id		
			puts person_details.name
		
			
			@person_id = person_details.id
			@person_password = person_details.password
			@person_fname = person_details.fname
			@person_lname = person_details.lname
			@person_phnumber = person_details.phnumber
			@person_email =  person_details.email
			puts @person_id
			
			intent = android.content.Intent.new('android.intent.action.EDITPERSON')
			intent.putExtra('personid',person_details.id.to_s)
			intent.putExtra('username',person_details.name)
			intent.putExtra('password',@person_password)
			intent.putExtra('first_name',@person_fname)
			intent.putExtra('last_name',@person_lname)
			intent.putExtra('phone',@person_phnumber)
			intent.putExtra('email',@person_email)
			startActivity(intent)
	   end
   end

end
