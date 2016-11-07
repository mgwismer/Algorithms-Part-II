
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
    @values_array = Array.new(numItems+1){Array.new(capacity+1,0)}
  end

  def read_in_data
    infile = File.open(file,'r')
    line1 = infile.gets
    capacity, numItems = line1.split(" ") 
    @capacity = capacity.to_i
    @numItems = numItems.to_i
    infile.each_line do |line|
      v,w = line.split(" ")
      @values.push(v.to_i)
      @weights.push(w.to_i)
    end
  end
  
  def dynamically_fill_value_array
#    puts @weights.length, numItems
    (1..numItems).each do |i|
      (0..capacity).each do |x|
         v_im1x = @values_array[i-1][x]
         v_im1xmwi = @values_array[i-1][x-@weights[i-1]] + @values[i-1]
         if @weights[i-1] > x
           @values_array[i][x] = v_im1x
         else
	   @values_array[i][x] = [v_im1x, v_im1xmwi].max
         end
       end 
     end
  end

  def solve
    self.read_in_data
    self.initialize_value_array
    self.dynamically_fill_value_array
    puts "answer is #{@values_array[numItems][capacity]}" 
#    p @values_array[numItems]
  end

end

knapsack1 = Knapsack.new("KnapSack1.txt")
knapsack1.solve
