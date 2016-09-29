#For solving the big cluster problem based on Hamming distances

def read_in_file
  infile = File.open("clustering_big.txt","r")

  line1 = infile.gets

  puts line1

  a,b = line1.split(" ")

  puts a
  puts b

  cluster = Hash.new
  ufClusterSize = Hash.new
  count = 0
  infile.each_line do |line|
    line.gsub!(/\s+/,"") #takes out the spaces
    if cluster[line] == nil
      cluster[line] = count
      ufClusterSize[line] = 1
      count += 1
    end
  end
return cluster, ufClusterSize
end

def change_bit(n)
   if (n == "0") 
      return "1"
   else 
      return "0"
   end
end

#These two loops create the nearest neighbor list and stores in alist
def find_neighbors(node1)
  alist = Array.new
  index = 0

  node1.each_char do |char|
    s = String.new(node1) #copies to new ins
    s[index] = change_bit(char)
    alist.push(s)
    index += 1
  end

  (0..node1.length-1).each do |i|
    (i+1..node1.length-1).each do |j|
       s = String.new(node1)
       char = s[i]
       s[i] = change_bit(char)
       char = s[j]
       s[j] = change_bit(char)
       alist.push(s)
     end
   end
   return alist
end

#This worked for all the small data sets but not the largest one.
#Need to redo so that if neighbor and parent have different keys all 
#the keys need to be reset. Keep track of cluster size. 
#This is the revision that checks whether neighbor and parent have different
#keys and resets all hash entries with that key. 
def find_new_cluster(cluster,clusterSize)
  cluster.each do |key,value|
    puts "node #{key} #{value}"
    neighbors = Array.new
    neighbors = find_neighbors(key)
    neighbors.each do |neighbor|
       clus_array = Array.new
       if (cluster[neighbor] != nil) and (cluster[neighbor] != value)
         if clusterSize[neighbor] == 1
            cluster[neighbor] = value
            clusterSize[neighbor] = 2
            clusterSize[key] += 1
         #union of two bigger clusters
         elsif clusterSize[neighbor] > clusterSize[key]
            #reset all cluster[key] to cluster[neighbor]
            #create an array of the nodes in cluster 'value'
            clus_array = Hash(cluster.select{|k,v| v == value}).keys
            #reset the values of all these nodes to cluster[neighbor]
            clus_array.each {|node| cluster[node] = cluster[neighbor]}
            newSize = clusterSize[key] + clusterSize[neighbor]
            clusterSize[key] = newSize
            clusterSize[neighbor] = newSize
         else
            #reset all cluster[neighbor] to cluster[key]
            #create an array of the nodes in cluster 'cluster[neighbor]'
            clus_array = Hash(cluster.select{|k,v| v == cluster[neighbor]}).keys
            #reset the values of all these nodes to 'value' 
            clus_array.each {|node| cluster[node] = value}
            newSize = clusterSize[key] + clusterSize[neighbor]
            clusterSize[key] = newSize
            clusterSize[neighbor] = newSize
         end
         #set everyone with neighbor's value (neigh_value) equal to value
         #neigh_value = cluster[neighbor]
         #Find everyone in cluster whose value is neigh_value
         #neigh_array = Hash(cluster.select{|k,v| v == neigh_value}).keys
         #neigh_array.each {|neigh| cluster[neigh] = value}
       end
    end
  end
  return cluster
end
cluster = Hash.new
ufClusterSize = Hash.new
neighbors = Array.new
values = Array.new
(cluster,ufClusterSize) = read_in_file
puts "cluster size #{cluster.size}"
new_cluster = Hash.new
#puts nodes with their closest neighbors
puts "old cluster last node #{cluster.to_a.last}"
puts "also last node #{cluster.keys.last}"
new_cluster = find_new_cluster(cluster,ufClusterSize)
#puts new_cluster
puts "new cluster last node #{new_cluster.to_a.last}"
puts "also last node #{new_cluster.keys.last}"
#The number of unique elements in this array is equal to the number of clusters
values = new_cluster.map { |key,value| value}
#The only way I can think to do it is to delete the duplicates and find the length of the resulting array.
puts "new cluster size #{new_cluster.size}"
values.uniq!
puts values.length







