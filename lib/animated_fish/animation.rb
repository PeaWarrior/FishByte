#https://medium.com/@yisroelm/how-to-make-animations-in-a-cli-app-f228d925244c
#example code of what the file should look like
def animation
    10.times do #however many times you want it to go for
    i = 1     
     while i <= 35 #20 gif instances starting from 0
        print "\033[2J" 
                   #the folder path     #the iterating file 
                              #  |               |     
         File.foreach("lib/animated_fish/fish/#{i}.rb") { |f| puts f }
        sleep(0.05) #how long it is displayed for
        i += 1
      end
    end
  end

