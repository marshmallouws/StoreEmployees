# Defining custom String class
class String
  # Integer checks if input only contains numbers 
  def integer?
    [
      /^[-+]?[0-9]([0-9]*)?$/, # decimal
    ].each do |match_pattern|
      return true if self =~ match_pattern
    end
    return false
  end
end

require 'json'

#Reading from .json file
f = File.new("Employees.json", "r")

#Reading file into new variable
h = JSON.load(f)

# Checks if there are curlybrackets in json file. Adds if not.
if h.nil?
  h = Hash.new
end
f.close

# Function for writing new data into file
def writeToFile(h)
  f = File.new("Employees.json", "w") # Truncates f.
  JSON.dump(h,f) # Takes input h and dumps it as json format to file.
end

def putMainMenu
  puts "Type 1 to enter a new employee \nType 2 to search for employee by number \nType 3 to exit program"
end

# Not used yet
def isLength(l, n, t)
  until l.integer? and l.length == n
    puts "#{t} must consist of #{n} numbers!"
    l = gets.chomp
  end
  return l
end

# Will always start while-loop except if failure occur beforehand.
while true
  putMainMenu
  option = gets.chomp.to_i

  if option == 3
    break
  end

  if option == 1
    while true
      # Enter new employee by number, name and date of birth
      puts "Enter ID. Must be 5 numbers:"
      id = gets.chomp

      # Checks if ID is five digtits. Loops until true
      id = isLength(id,5,"ID")

      #Checks if ID is already in db
      if h.has_key?(id)
        puts "The ID is already entered in the database"
        next
      else
        break
      end
    end

    puts "Enter name:"
    name = gets.chomp

    puts "Enter date of birth (ddmmyyyy):"
    birthday = gets.chomp

    # Checks if birthday is right format!
    birthday = isLength(birthday,8,"Birthday")

    #Creates hash with input data
    h[id]={"Name" => name, "Date of birth" => birthday}
    writeToFile(h)

  elsif option == 2
    # Find employee by number
    puts "Type ID to search for employee"
    id = gets.chomp

    #Checks if key exits
    if h.has_key?(id)
      #Prints data
      puts "ID ".ljust(15) + "- \t #{id}"
      h[id].each do |key, value|
        puts "#{key.ljust(15)} - \t #{value}"
      end
    else
      puts "ID not found"
    end
  else
    next
  end
end
f.close
