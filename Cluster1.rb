#Solves Problem 1 of Assignment 2 of Algorithm 2 by Roughgarden
#Program determines the minimum spacing (distance between 2 closest
#clusters) when graph is broken into n clusters. Uses the union_find
#data structure to identify which nodes are in the same cluster
#if UFCluster[i] = UFCluster[j] i and j are in the same cluster. Main Class object
#is the Graph which has edges, UFCluster and ClusterSize and all the other data structures. 

class Graph
  #attr_accessor :NumNodes, :NumEdges, :edges, :ufCluster, :clusterSize, :numCluster, :k
attr_accessor :file
  def initialize(filename,ki)
    @file = filename
    @numNodes = 0
    @numEdges = 0
    @numCluster = 0
    @k = ki.to_i
    @edges = Array.new {Array.new} #[[n1,n2,cost], [n1,n3,cost], []...]
    @ufCluster = Array.new #initially 500 clusters
    @clusterSize = Array.new(501)
    @clusterSize.fill(1)  #initially all clusters have a size of 1
  end 

  def info
    puts "UFCluster #{@ufCluster[1]} and #{@ufCluster[500]}"
    puts "UFSize #{@clusterSize[0]} and #{@clusterSize[500]}"
  end

  def read_in_graph
    inFile = File.open(file,"r")
    @numNodes = inFile.readline
    @numCluster = @numNodes.to_i
    puts "num nodes read #{@numNodes} #{@numCluster}"
    @ufCluster = Array(0..@numCluster)
    inFile.each_line do |line|
       a,b,c = line.split(" ")
       edge = [a.to_i, b.to_i, c.to_i]
       @edges.push(edge)
    end #inFile.each
  end #end of read_in_graph

  def sort_edges
     @edges.sort_by! {|x,y,z|z}
#     puts @edges[1][0]
#     puts @edges[1][1]
#     puts @edges[1][2]
  end

  def separate_into_clusters
    i = 1
    puts "Clustering #{@k} #{@numCluster}"
    while (@numCluster > @k) do
      node1 = @ufCluster[@edges[i][0]]
      node2 = @ufCluster[@edges[i][1]]
      if node1 == node2 
         i += 1
      elsif @clusterSize[@edges[i][0]] < @clusterSize[@edges[i][1]]
         #this is the union step
         @ufCluster.map! {|x| (x == node1)? node2:x}
         newSize = @clusterSize[@edges[i][0]] + @clusterSize[@edges[i][1]]
         @clusterSize[@edges[i][0]] = newSize
         @clusterSize[@edges[i][1]] = newSize
         i += 1
         @numCluster -= 1
      else
         @ufCluster.map! {|x| (x == node2)? node1:x}
         newSize = @clusterSize[@edges[i][0]] + @clusterSize[@edges[i][1]]
         @clusterSize[@edges[i][0]] = newSize
         @clusterSize[@edges[i][1]] = newSize
         i += 1
         @numCluster -= 1
      end 
    end #end of while
    node1 = @ufCluster[@edges[i][0]]
    node2 = @ufCluster[@edges[i][1]]
    puts "Found spacing i #{i}"
#    print @ufCluster.join(" ")
    spacing = 0
    while (spacing == 0)
      if @ufCluster[@edges[i][0]] == @ufCluster[@edges[i][1]]
        i += 1
      else 
        spacing = @edges[i][2]
      end
    end
  return spacing 
  end #end separate_into_clusters
end #end of class

graph1 = Graph.new("clustering.txt",4)
graph1.read_in_graph
graph1.sort_edges
puts "successful read and sort"
puts "Spacing #{graph1.separate_into_clusters}"


