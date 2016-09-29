# Algorithms-Part-II
Assignment based on Coursera course by Roughgarden

Cluster1.rb reads in a list of edges and their cost and finds the minimum distances between clusters when n clusters are formed. User can define the number of clusters. Uses the union-find data structure to keep track of clusters. Algorithm is based on 
Kruskal theory. 

Cluster2a.rb reads in a list of nodes, each node 24 bits wide (for the final case). Determines how many clusters can be formed if the minimum spacing between clusters is 3. That is every node in a cluster must have a spacing to another node in that cluster of 
2 or fewer (1 or 2) The spacing between nodes is defined as the Hamming distance, adjacent nodes must have all but 1 or 2 bits 
in common. Solution requires the use of a union-find Hash table using the 24 bit nodes as the key. 
