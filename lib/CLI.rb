class Cli
$prompt = TTY::Prompt.new
attr_accessor :user, :new_device, :new_tama
@tama_arr = ["Fuwatsunotchi", "Kurupoyotchi", "Kuchipatchi", "Mokofuritchi", "Gozarutchi", "Nijifuwatchi", "Makimotchi", "Doyakentchi"]
@color_arr = ["Red", "Orange", "Yellow", "Green", "Blue", "Indigo", "Violet"]

    def initialize
        @new_tama = nil
        @new_device = nil
        @user = nil
    end

    def self.start
        puts "welcome to the Tamagotchi interface!"
        user_name = $prompt.ask("What is your name?") do |q|
            q.modify :down
          end
        @user = User.find_or_create_by(name: user_name)
        adopt
    end

    def self.adopt
        tama_question = $prompt.yes?("Would you like to adopt a Tamagotchi?") do |q|
             q.default false
            q.positive "Y"
            q.negative "N"
         end
        if tama_question == true
             create_device(@user)
        else
            user_tamagotchis
        end 
    end 

    def self.create_device(user)
        @new_device = Device.create
        @new_device.user = user
        @new_device.save
         puts "New device created!"
        create_tamagotchi(@new_device)
    end

    def self.create_tamagotchi(new_device)
        #arr = ["Fuwatsunotchi", "Kurupoyotchi", "Kuchipatchi"]
        @new_tama = Tamagotchi.create(name: @tama_arr.sample)
        @new_device.tamagotchi = @new_tama
        @new_device.save
        @new_tama.happiness = 5
        @new_tama.hunger = 5
        @new_tama.alive = true 
        @new_tama.color = @color_arr.sample
        @new_tama.save
        puts "Congratulations! You've adopted #{@new_tama.name}!"
            rename
    end

    def self.rename
         rename_prompt = $prompt.yes?("Would you like to rename your Tamagotchi?") do |q|
           q.default false
           q.positive "Y"
           q.negative "N"
        end
        if rename_prompt == true
            new_name = $prompt.ask("What is their new name?")
            @new_tama.name = new_name
            @new_tama.save
            activities
       else
            activities
       end 
    end 

    def self.activities
        if @new_tama == nil 
            puts "You need a Tamagotchi to access this hub"
            tama_options
        else
        activity = $prompt.select("Welcome to the activity hub!") do |menu|
            menu.choice "Play", 1
            menu.choice "Feed your Tamagotchi", 2
            menu.choice "Inspect Tamagotchi", 3
            menu.choice "View all your Tamagotchis", 4
            menu.choice "Exit", 5
          end
          if activity == 2
            food_menu
           elsif activity == 3
                inspect_tama_activities_menu
          elsif activity == 4
            user_tamagotchis
          elsif activity == 1
            play
          else 
            puts "Bye for now!"
          end 
        end 
    end 
   
    def self.play
        @play_arr = ["You and #{@new_tama.name} through a ball around! Their happiness has increased!", "You and #{@new_tama.name} start a new bookclub! Their happiness has increased!",
            "You and #{@new_tama.name} make up your own game! It's not particularly good. Their happiness has increased!", "You and #{@new_tama.name} make a cake! From scratch! No boxes or nothing!"]
        @new_tama.happiness = @new_tama.happiness + 1
                 x = @new_tama.happiness
                @new_tama.happiness = [x, 0, 10].sort[1]
        @new_tama.hunger = @new_tama.hunger + 1
                y = @new_tama.hunger
                 @new_tama.hunger = [y, 0, 10].sort[1]
        @new_tama.save
       puts @play_arr.sample
        activities
    end

    def self.food_menu
        food = $prompt.select("What would you like to feed your Tamagotchi?") do |menu|
            menu.choice "a snack", 1
            menu.choice "A hearty and healthy meal", 2
            menu.choice "Preposterously caustic junk food", 3
            menu.choice "Back to the activity hub", 4
        end 
            if food == 1
                @new_tama.hunger = @new_tama.hunger - 1
                x = @new_tama.hunger
                 @new_tama.hunger = [x, 0, 10].sort[1]
                 @new_tama.save
                 puts "Their hunger has decreased by 1 on the universaly recognized hunger index!"
                 food_menu
            elsif food == 2
                @new_tama.hunger = @new_tama.hunger - 2
                x = @new_tama.hunger
                @new_tama.hunger = [x, 0, 10].sort[1]
                @new_tama.save
                puts "Their hunger has decreased by 2 on the universaly recognized hunger index!"
                food_menu
            elsif food == 4
                activities
            else 
                feed
            end
    end 

    def self.feed
        question = $prompt.keypress("Press space to feed your tamagotchi? :countdown ...", timeout: 3, keys: [:space]) do |q|
        q.default false  
        end 
            if question == false

                    dead
            else 
                    feed
             end 
    end 

    def self.dead
        @new_tama.alive = false
        @new_tama.save
        puts "In a wave of neglegence and empty calories, you have killed #{@new_tama.name}."
        now_what = $prompt.yes?("Would you like to visit the graveyard?") do |q|
            q.default false
            q.positive "Y"
            q.negative "N"
        end
             if now_what == true
                visit_graveyard
            else
                  start
            end 
    end 

    def self.visit_graveyard
       graveyard = (Tamagotchi.all.select {|tama| tama.alive == false}).map{|tama| tama.name}
       puts "The Deceased:"
       puts graveyard
       answer = $prompt.yes?("would you like to try again?") do |q|
            q.default false
            q.positive "Y"
            q.negative "N"
        end
            if answer == true
                start
             else
                 puts "Bye for now!"
            end 
    end 

    def self.user_tamagotchis
       tamas = @user.tamagotchis #.map{|tama| tama.name}
       if tamas.empty? == true
        puts "You do not appear to have any Tamagotchis."
            adopt
        else
         p tamas
         tama_options
        end
    end

    def self.what_id
        id_number = $prompt.ask("What is the desired Tamagotchi's ID number?")
        change_tama(id_number)
    end

    def self.change_tama(id_number)
        @new_tama = Tamagotchi.find_by_id(id_number)
        if @new_tama == nil
            puts "Sorry, that doesn't appear to be a valid ID"
            what_id
        else
            puts "#{@new_tama.name} looks happy to see you!" 
             activities
        end
    end 

    def self.tama_options 
        opt = $prompt.select("What would you like to do?") do |menu|
            menu.choice "Change Tamagotchi", 1
            menu.choice "Inspect Tamagotchi", 2
            menu.choice "Delete Tamagatchi", 3
            menu.choice "Rename Tamagatchi", 4
            menu.choice "happiest Tamagatchi?", 5
            menu.choice "Adopt new Tamagatchi", 6
            menu.choice "Return to activities hub", 7
        end
        if opt == 1
            what_id
        elsif opt == 2
            inspect_tama
        elsif opt == 3
            delete_double_check
        elsif opt == 5
            happiest_tama
        elsif opt == 4
            rename
        elsif opt == 6
            adopt
        else
            activities
        end
    end 

    def self.delete_double_check
        check = $prompt.yes?("Are you positive you want to delete #{@new_tama.name}?") do |q|
            q.default false
           q.positive "Y"
           q.negative "N"
        end
        if check == true
            delete_tamagotchi
        else
            tama_options
        end
    end

    def self.delete_tamagotchi
        puts "After that my guess is that you will never hear from him again. The greatest trick the devil ever pulled was convincing the world he did not exist. And like that... #{@new_tama.name} is gone."
        @new_tama.destroy
        delete_prompt = $prompt.select("What would you like to do?") do |menu|
            menu.choice "Change Tamagotchi", 1
            menu.choice "Adopt new Tamagotchi", 2
        end
        if delete_prompt == 1
            user_tamagotchis
        else
            adopt
        end
    end 

    def self.inspect_tama
        p @new_tama
        puts "This is #{@new_tama.name}"
        puts  "They are a striking shade of #{@new_tama.color}"
        if @new_tama.hunger > 5
            puts "They appear rather hungry"
        else
            puts "They must have recently eaten"
        end
        puts  "And have a happiness of #{@new_tama.happiness}"
        tama_options
    end

    def self.inspect_tama_activities_menu
        p @new_tama
        puts "This is #{@new_tama.name}"
        puts  "They are a striking shade of #{@new_tama.color}"
        if @new_tama.hunger > 5
            puts "They appear rather hungry"
        else
            puts "They must have recently eaten"
        end
        puts  "And have a happiness of #{@new_tama.happiness}"
        activities
    end

    def self.happiest_tama
        happy_tama = Tamagotchi.where("happiness = ?", Tamagotchi.most_happiness).first
        puts "The happiest Tamagotchi:"
        p happy_tama
         tama_options
    end
end 



# def feed
#     $prompt.keypress("Press any key to feed your tamagotchi, resumes automatically in :countdown ...", timeout: 3)
#     if :countdown == 0
#         feed
#     end
# end 

# def feed
#     $prompt.keypress("Do you want to feed your tamagotchi? :countdown ...", timeout: 3, keys: [:space], default: 0)
#     while :countdown == 0
#         dead
    
#     end
# end 

# def feed
#     $prompt.select("Do you want to feed your tamagotchi?...",  %w(Yes No), convert: :boolean)
#     if false
#         dead
#     else 
#         feed
#     end 
# end 

# def feed
#     question = $prompt.yes?("Do you want to feed your tamagotchi? :countdown ...", timeout: 3) do |q|
#         q.default false
#         q.positive "Yup"
#         q.negative "Nope"
#     end
#         if question == false
#             dead
#         else 
#             feed
#         end 
# end 