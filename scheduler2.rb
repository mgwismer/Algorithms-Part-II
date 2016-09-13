#Algorithms 2 class with Roughgarden
#Greedy job scheduler based on weight - length (of job)

class Job
    attr_accessor :weight, :length, :score
    def initialize weight, length, score
       @weight = weight.to_f
       @length = length.to_f
       @score = weight.to_f/length.to_f
    end
end

def findWeightedScore(sortedArray)
   totalLength = 0
   totalWeight = 0
   sortedArray.each do |job|
     totalLength = totalLength + job.length
     totalWeight = totalWeight + job.weight*totalLength
   end
   return totalWeight
end

#Have to figure out how to put all this stuff into a class
   
jobArray = Array.new
sortedArray = Array.new
file = File.open("jobs.txt",'r')
numJobs = file.readline.to_i
i = 0
file.each_line do |line|
   a,b = line.split(" ")
   jobArray[i] = Job.new a, b, "0"
   i += 1
end

#sort array 
sortedArray = jobArray.sort_by{|job| [job.score]}

weightedAvg = findWeightedScore(sortedArray.reverse)
puts "Weighted Avg #{weightedAvg}"
#file1 = File.open("sortedJobs.txt",'w')
#sortedArray.each do |job|
#  file1 << job.score << " " << job.weight << " " << job.length << "\n"
#end
