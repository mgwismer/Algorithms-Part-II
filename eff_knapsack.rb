#Similar to the knapsack code but uses only the two columns in the values_array
class Knapsack
  attr_accessor :file, :capacity, :numItems
  def initialize(filename)
    @file = filename
    @capacity = 0
    @numItems = 0
    @values = Array.new
    @weights = Array.new
  end

  def initialize_value_array
    puts "capacity test #{capacity} #{numItems}"
    @values_array = Array.new(2){Array.new(capacity+1,0)}
  end

  def read_in_data
    infile = File.open(file,'r')
    line1 = infile.readline
    p line1
    capacity, numItems = line1.split(" ") 
    @capacity = capacity.to_i
    @numItems = numItems.to_i
    puts "test read #{@capacity} #{@numItems}"
    infile.each_line do |line|
      p line
      v,w = line.split(" ")
      puts "in read file #{v.to_i} #{w.to_i}"
      @values.push(v.to_i)
      @weights.push(w.to_i)
    end
  end
  
  def dynamically_fill_value_array
    puts @weights.length, numItems
#    p @values
#    p @weights
    (1..numItems).each do |i|
#       @values_array[1].map! {|v| v = 0}
#       puts "zero and one arrays after"
#       print @values_array[0]
#       print @values_array[1]
#       puts "item #{i} "
      (0..capacity).each do |x|
         v_im1x = @values_array[0][x]
         v_im1xmwi = @values_array[0][x-@weights[i-1]] + @values[i-1]
         if @weights[i-1] > x
	   @values_array[1][x] = v_im1x
         else
           @values_array[1][x] = [v_im1x, v_im1xmwi].max
         end
       end 
       @values_array[0] = @values_array[1].dup
#       puts "item #{i-1} zero and one arrays before"
#       print @values_array[0]
#       print @values_array[1]
#       puts
     end
  end

  def solve
    self.read_in_data
    self.initialize_value_array
    self.dynamically_fill_value_array
#    p @values_array[1]
    puts "answer is #{@values_array[1][capacity]}"
  end

end

knapsack1 = Knapsack.new("bigsack1.txt")
knapsack1.solve
