class Graph
  attr_accessor :file, :numNodes, :shortestPath, :dist, :maxDist, :allPairSP
  def initialize(filename)
     @maxDist = 2000000
     @file = filename
     @numNodes = 0
     @numEdges = 0
     @allPairSP = Array.new
  end
  
  def initializeArrays(s1)
    @dist = Array.new(@numNodes,@maxDist)
    @dist[s1] = 0 #distance to the source node is 0
    @shortestPath = Array.new(@numNodes, @maxDist)
    @X = [s1] #the list of nodes already considered
    @vertexVisited = Array.new(@numNodes, 0) #no vertex visited yet 
  end

  def nextNode
    minDist = @dist.min  #presumably this is where the heap data structure is useful
    u = @dist.index(minDist)
    return minDist, u
  end

  def addToVisitedNodes(u)
    @X.push(u)
  end

  def relax(u)
    @adjacencyList[u].each do |node,edge|
      if (@vertexVisited[node] == 0) #this node not visited
        alt = @dist[u] + edge
        @dist[node] = [alt, @dist[node]].min
      end
    end
  end

  def dijkstraShortestPath(s1)
    self.initializeArrays(s1) 
    minDist = 0
    while (@X.length < @numNodes) and (minDist < @maxDist-1)
      minDist,u = self.nextNode 
      puts "In dijkstra #{@X.length} #{minDist} node #{u}" 
      self.addToVisitedNodes(u)
      @vertexVisited[u] = 1
      @shortestPath[u] = minDist
      self.relax(u) #resets the dist values of nodes u points to
      @dist[u] = @maxDist+1
    end
#    puts @shortestPath
  end

  def read_in_data
    infile = File.open(file,'r')
    line1 = infile.readline
    numNodes, numEdges = line1.split(" ")
    @numNodes = numNodes.to_i
    @numEdges = numEdges.to_i
    @adjacencyList = []
    (0..@numNodes).each do |x| 
       @adjacencyList[x] = []
    end 
    infile.each_line do |line|      
      n1,n2,w = line.split(" ")
#   shift node 1 to node 0, all nodes shift down
      @adjacencyList[n1.to_i-1].push([n2.to_i-1,w.to_i])
    end
  end

  def solve(s1)
    self.read_in_data
    self.dijkstraShortestPath(s1)
    @shortestPath.delete_at(s1) #shortest path to s1 is 0 which is always the SP
    puts @shortestPath.join(" ")
    return @shortestPath.min
  end

#  def computeAPSP
#    (0..@numNodes-1).each |node|
#       @allPairSP[node] = solve(node)
#     end
#  end

end

graph1 = Graph.new("case1.txt")
puts "Shortest path for 6 #{graph1.solve(6)}"
#puts graph1.allPairSP.join(" ")
#puts graph1.dist
