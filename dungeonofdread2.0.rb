puts "Welcome to my dungeon, the DUNGEON OF DREAD!! This is a short adventure to test your wit and knowledge. Be sure to carefully look around the rooms!" 
puts "With enough skill you're sure to make it out alive! Type inv to view your inventory."


class Dead
	@@loser = [
			"I'm REALLY sorry you didn't make it out of my Dungeon of Dread. Hope you'll try again!",
			"The Dungeon of Dread is filled with perils. But try again, and you're sure to survive!",
			"Were you expecting the Dungeon of Dread to be more forgiving? MWAHAHA. Try again."
			]
	
	def enter()
		puts @@loser[rand(0...3)]
		exit(1)
	end
end

class Shared
	
	@@inventory = ["lit candle"]
	
	def printinv()
		puts @@inventory
	end
	
	def appendinv(item)
		@@inventory.push(item)
	end
end


class Engine

	def initialize(maplink)
		@maplink = maplink
	end
	
	def play()
		
		current_scene = @maplink.game_opening()
		
		final_scene = @maplink.room_locator('finale')
		
		while current_scene != final_scene
			next_scene_name = current_scene.enter()
			current_scene = @maplink.room_locator(next_scene_name)
		end
		
		current_scene.enter()
	end
end

class Room1 < Shared
	

	def enter()		
		puts "\nYou find yourself in a dark and empty cellar. The candle you hold in front of you
provides some illumination. In front of you are two crates. The first is marked 'OPEN ME,' and the second is
marked 'NO, OPEN ME! He's a trap.' What do you do?"
		
		controller = false
		
		while true	
			print "> "
			look = $stdin.gets.chomp.downcase
				if look.include? "look"
					puts "You can barely see a thing in this damned cellar. Squinting, you see a door to your left and a door to your right, just beyond the two crates."
				
				elsif look == "first" or look == "1"
					puts "Opening the first crate, you see a severed hand inside."
					puts "Do you want to take the hand? Yes or no?"
					print "> "
					while true
					take = $stdin.gets.chomp.downcase						
						if take == "no" 
							puts "You decide against taking the hand and step away from the box."
							break
						elsif take == "yes"
							puts "The hand leaps at you. Now that it's a little closer you have time to see its haunted nails piercing your jugular."
							return 'dead'
						else
							puts "Please give me a yes or no answer!"
						end
					end
				
				elsif look == "second" or look == "2" && !controller 
					puts "Opening the crate you see a ghastly sharpened stake casting a shadow in the foreground of the box. Do you want to take the stake? yes or no"
					print "> "
					take = $stdin.gets.chomp.downcase
						if take == "yes"
							puts "OK. You take the stake. It is now in your inventory."
							appendinv("sharpened stake")
							controller = true
						elsif take == "no"
							puts "OK, you step away from the crate without picking up the stake."
						end
				elsif look == "second" && controller
					puts "No need to look in there again. You already have the stake."
				elsif look.include? "left" 
					return 'room2'
				elsif look.include? "right"
					if @@inventory.include? "silver key"
						puts "Turning the silver key in the keyhole, the door creaks open."
						return 'room3'
					else 
						puts "It's hopeless. The door won't budge and you're not carrying the key."
					end
				elsif look.include? "inv"
					printinv()
				else
					puts "Sorry, I can't understand you."
				end
		end
	end
end


class Room2 < Shared
	
	def enter()
		puts "This room contains a large circular diving pool. A glimmer of moonlight shines into the center of the pool, illuminating a SILVER KEY. What do you do?"
		controller1 = false
		controller2 = false
		while true
			print "> "
			decision = $stdin.gets.chomp.downcase
			if decision == "look" or decision == "look room" and controller1
				puts "You already drank from the bottle. Only the cool, undulating waters of the pool beckon to you now!"
			elsif decision == "look" or decision == "look room" and !controller1 
				puts "Taking a closer look at the room, you notice a bottle of blue liquid by the corner of the room. It looks like a mermaid with big teeth is painted on the bottle. Drink? Yes or no?"
				print "> "
				liquid = $stdin.gets.chomp.downcase
				if liquid == "yes"
					puts "You consume the liquid and keep the bottle as a souvenir."
					appendinv("bottle")
					controller1 = true
				elsif liquid != "no"
					puts "You decide against drinking the liquid for now."
				end
			elsif decision == "pool" or decision == "swim" or decision == "look pool" or decision == "dive" and !controller2
				if @@inventory.include? "bottle"
					puts "You approach the pool and dive in. Along the way, a mermaid swims up to you and kisses you. That
					liquid must have been a love potion! She helps you swim to the bottom; you grab the key, and you emerge from the depths."
					appendinv("silver key")
					controller2 = true
				else 
					puts "You approach the water, and a beautiful mermaid lunges grabs you, pulling you under!" 
					puts "She likes you! Gasping for breath, you fill your lungs with the brackish water."
					return 'dead'
				end
			elsif decision == "look pool" or decision == "pool" or decision == "dive" or decision == "swim" and controller2
				puts "No way! You're not going in there again."
			elsif decision == "leave" or decision == "back" or decision == "right" 
				puts "You wisely decide to return to the previous room."
				return 'room1'	
			elsif decision.include? "inv"
				printinv
			else 
				puts "Sorry, I don't know what you want."
			end
		end
	end
end

class Room3 < Shared


	def enter()
	puts "As soon as you enter the room with the key that you retrieved from the mermaid's lair, the cellar caves in behind you, sealing you in the room. No escape now! What do you do?"
		while true
			print "> "
			choice = $stdin.gets.chomp.downcase
			if choice == "Ravenloft"
				dead("Your scream causes the coffin in the far corner of the room to softly slide open. 'Good evening,' I am Strahd, says the old vampire. You're suddenly
				looking very pale indeed as the Barovian vampire sinks his fangs into your neck.")
			elsif choice.include? "look"
				puts "This room is horrible. Bodies lie around the center of the room haphazardly. A coffin lies still in the center of the room. Hope you brought your survival gear!"
			elsif choice.include? "coffin"
				puts "Trembling, you approach the coffin and slide off the lid! Count Dracula's eyes pop open! He utters a gutteral laugh. 'Welcome to my domain!' You only have one chance: what do you do??"
				if @@inventory.include? "sharpened stake"
					print "> "
					finale = $stdin.gets.chomp.downcase
					if finale == "stake" or finale == "stab" or finale == "use stake" or finale == "kill"
						puts "You drive the stake into Count Dracula over and over again! Once might have been sufficient; he's quite dead now. Or at least as dead as such a creature can be.
The wall in front of you slides up, revealing a massive staircase. You follow the staircase up through the exit of a mausoleam. Daylight!"
						return 'finale'
					else 
						puts "Well, that sucks. You turn a ghostly white as Dracula enjoys his dinner: YOU."
						return 'dead'
					end
				else
					print "> "
					$stdin.gets.chomp.downcase
					puts "That didn't work at all! Dracula laughs and sinks his fangs into you. He later writes a review on Grubhub praising the direct-to-your-coffin delivery service."
					return 'dead'
				end
			elsif choice.include? "inv"
				printinv
			else
				puts "Try again, please. I don't understand."
			end
		end	
	end
end


class Finale < Shared

	def enter
		puts "Congratulations! You survived the Dungeon of Dread! Thanks so much for playing."
		exit(1)
	end
end
	
class Map
	@@rooms = {
				'room1' => Room1.new(),	
				'room2' => Room2.new(),
				'room3' => Room3.new(),
				'dead' => Dead.new(),
				'finale' => Finale.new()
				}
	
	def initialize(first_room)
		@first_room = first_room
	end
	
	
	def room_locator(room_name)
		room = @@rooms[room_name]
		return room
	end
	
	def game_opening()
		return room_locator(@first_room)
	end
end	


	
a_map = Map.new('room1')
a_game = Engine.new(a_map)
a_game.play


		