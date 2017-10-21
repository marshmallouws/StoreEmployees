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

# Checks if input has right length and type.
def isLength(l, n, t)
  until l.integer? and l.length == n
    puts "#{t} must consist of #{n} numbers!"
    l = gets.chomp
  end
  return l
end

# Checks if leap year
def isLeap(year)
  if (year % 400 == 0) or (year % 4 and ! % 100 == 0)
    return true
  end
  return false
end

# Method to check if the date is legit
def checkDate(date)
  # Slicing user input into array of integers
  day = date.slice(0,2).to_i
  month = date.slice(2,2).to_i
  year = date.slice(4,4).to_i

  if year < 1900 and year > 2000
    return false
  end

  # Checks which month and if dates are complying
  case month
  when 1,3,5,7,8,10,12
    return !(day > 31)
  when 4,6,9,11
    return !(day > 30)
  when 2
    if isLeap(year)
      return !(day > 29)
    else
      return !(day > 28)
    end
  else
    return false
  end
  return true
end

# Will always start while-loop except if failure occur beforehand.
while true
  putMainMenu
  option = gets.chomp.to_i

  if option == 3
    break
  end

  if option == 1
    # Looping to get ID until it it the right format AND is not already used
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

    while true
      puts "Enter date of birth (ddmmyyyy):"
      birthday = gets.chomp

      # Checks if birthday is right format!
      birthday = isLength(birthday,8,"Birthday")

      if !checkDate(birthday)
        puts "The date is not correct"
        next
      else
        break
      end
    end
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
      puts "ID ".ljust(15) + " - \t #{id}"
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
