# Tamagotchi 2.0
Welcome to Tamagotchi 2.0! In this project, we have resurrected the classic game in our own style by using CLI command prompts, ActiveRecord, and objected oriented models, all done in Ruby. This app is intended to harken back to the late 90s, a time when virtual pets flooded the market and taught children everywhere that they are nowhere near ready to accept the awesome responsibility of taking care of an actual pet. We hope to recapture that childhood feeling of caring for a virtual pet until it inevitably shuffles off this mortal coil.
## Installation instructions
1. Fork and clone this repository.
2. From there, run rake db:migrate to create your tables
Note:
After you've ran db:migrate, you can declutter the CLI and mask the database updates by commenting in `ActiveRecord::Base.logger.level = 1 ` in  `config/enviroment.rb`, all for a more user friendly experience.
3. To start Tamagotchi 2.0, type out `ruby bin/run.rb` in your terminal

User Stories: 
1. As a user, you can create a user name or find an existing one upon startup (Create/Read)
2. As a user, you can create a new instance of a device and the instance of the Tamagotchi contained with it in. (Create)
3. As a user, you can access an array of all your existing Tamagotchis associated with your User name and ID. (Read)
4. As a user, you can view the stats of a given instance of a Tamagotchi. (Read)
5. As a user, you can assign a custom name to your Tamagotchi (It will however initialize with a random name). (Update)
6. As a user, you can update the integers reflecting your Tamagotchi's happiness and hunger, based upon choices made    within the app. (Update)
7. As a user, you can update the boolean value of the age old question "Alive?". (Update)
8. As a user, you can delete any unwanted Tamagotchi. (Delete)





license: https://github.com/IainLR/ruby-project-guidelines-hou01-seng-ft-082420/blob/master/LICENSE.md