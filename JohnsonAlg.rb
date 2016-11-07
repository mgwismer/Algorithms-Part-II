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
#      puts "In dijkstra #{@X.length} #{minDist} node #{u}" 
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
    @adjacencyList = []  #used with Dijkstra
    @reverseAdjacencyList = [] #used with Bellman-Ford
    (0..@numNodes).each do |x| 
       @adjacencyList[x] = []
       @reverseAdjacencyList[x] = []
    end 
    infile.each_line do |line|      
      n1,n2,w = line.split(" ")
#   shift node 1 to node 0, all nodes shift down
      @adjacencyList[n1.to_i-1].push([n2.to_i-1,w.to_i])
      @reverseAdjacencyList[n2.to_i-1].push([n1.to_i-1,w.to_i])
    end
  end

  def solve(s1,weights)
    self.dijkstraShortestPath(s1)
    self.unweightShortestPaths(s1,weights)
    return @shortestPath.min
  end

  def initializeMinDistArray(s1, numN)
    newArray = Array.new(2) {Array.new(numN, @maxDist)}
    newArray[0][s1] = 0 #shortest distance to source node, s1, is zero.
    return newArray
  end
    
  def computeMinDistArray(minDistArray,numN)
     tempArray = []
     (0..numN-1).each do |n2| #loop through all nodes
       tempArray.push(minDistArray[0][n2])
       @reverseAdjacencyList[n2].each do |n1, edge|
          tempArray.push(minDistArray[0][n1]+edge)
       end #loop through  nodes for which v is the head
       minDistArray[1][n2] = tempArray.min
       tempArray = []
     end #loop through nodes
  end

  def bellmanFord(s1, numN)
    minDistArray = initializeMinDistArray(s1, numN) #minDistArray is 2D so can't use dist
    (1..numN-1).each do |i| 
      self.computeMinDistArray(minDistArray,numN)
      minDistArray[0] = minDistArray[1].dup
    end #loop through increasing edge count  
    self.computeMinDistArray(minDistArray,numN)
    if (minDistArray[1] == minDistArray[0])
       minDistArray[1].pop #don't include ghost node
       @shortestPath = minDistArray[1].dup
    else
       puts "negative cycle"
       return false
    end    
    return true
  end

  def createGhostNode  #in reverseAdjacencyList for Bellman Ford
    (0..@numNodes).each do |n2|
       @reverseAdjacencyList[n2].push([@numNodes,0]) #the "ghost node" is @numNodes
    end
  end

  def johnsonAlg(weights)
    self.reweightEdgeLengths(weights)
    (0..@numNodes-1).each do |node|
       @allPairSP[node] = solve(node,weights)
#       puts "In Johnson loop #{node} #{@allPairSP[node]}"
    end
    puts @allPairSP.min
  end

  def reweightEdgeLengths(p)
    puts "before reweight"
    puts p.join(" ")
    puts "edges " 
    puts @adjacencyList[0].join(" ")
    (0..@numNodes-1).each do |n1|
       @adjacencyList[n1] = @adjacencyList[n1].map {|n2,edge| [n2,edge += p[n1]-p[n2]]}
    end
    puts "after reweight"
    puts @adjacencyList[0].join(" ")
  end

  def unweightShortestPaths(n1,p)
    @shortestPath = @shortestPath.each_with_index.map {|path,n2| path -= p[n1] - p[n2]}   
  end

  def computeAPSP
    self.read_in_data
    self.createGhostNode
    weights = []
    if (self.bellmanFord(@numNodes,@numNodes+1)) #ghost node is the highest node number
       weights = @shortestPath #doesn't include ghost node
#       puts weights.join(" ")
       self.johnsonAlg(weights)
       return true
    else
       return false
    end
  end
 
end

graph1 = Graph.new("g4.txt")
graph1.computeAPSP
#puts graph1.dist
