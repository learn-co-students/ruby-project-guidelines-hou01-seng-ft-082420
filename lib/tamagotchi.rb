class Tamagotchi < ActiveRecord::Base
    has_many :devices
    has_many :users, through: :devices


    def self.most_happiness
        Tamagotchi.all.maximum(:happiness)
    end
end 