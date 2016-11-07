#Assignment 1 of Algorithms 2. Implementation of Prim's algorithms
#for determing MST (minimal spanning tree)
#Data structure edgeList = [[v1,v2,cost], [v1,v2,cost],....]
#must put everything in a Graph class

file = File.open("edges.txt","r")
line1 = file.readline

a,b,c = line1.split(" ") #not sure why program needs to read in three values when there are only two in file. 

numNodes = b.to_i
numEdges = c.to_i
numNodesInSpan = 0
spanTree = Array.new #array of edge (just index) in the MST
vertexIn = Array.new(numNodes+1, 0) #true if vertex i in current tree

puts numNodes
puts numEdges

edges = Array.new {Array.new}
remEdges = [*0..numEdges - 1] #initially non of the edges are in tree
edge = Array.new
file.each_line do |line|
   a,b,c = line.split(" ") #a is vertex 1, b vertex 2, c the cost
   edge = [a.to_i, b.to_i, c.to_i]
   edges.push(edge)
end

#puts "total edges "
#puts edges
def edgeCross(currEdge,vertexIn)
   if (vertexIn[currEdge[0]] == 1) and (vertexIn[currEdge[1]] == 0)
      return true
   elsif (vertexIn[currEdge[0]] == 0) and (vertexIn[currEdge[1]] == 1)
      return true
   else
      return false
   end
end

#initialize start at vertex 1, vertex 1 is in tree
vertexIn[1] = 1   
numNodesInSpan = 1
#main while loop
while numNodesInSpan < numNodes do
   minCost = 1000e6
   newEdge = 0
   remEdges.each do |edge|
      if edgeCross(edges[edge],vertexIn)
         if edges[edge][2] < minCost
            minCost = edges[edge][2] #cost is stored in last index
            newEdge = edge
         end
      end
   end
   numNodesInSpan += 1
   remEdges.delete(newEdge)
   spanTree.push(newEdge)
   vertexIn[edges[newEdge][0]] = 1 #the vertices on both sides of edge are in 
   vertexIn[edges[newEdge][1]] = 1 #the MST
end

#compute total cost of MST
minCost = 0
spanTree.each do |edge|
   minCost += edges[edge][2]
end
puts "Cost "
puts minCost

   
