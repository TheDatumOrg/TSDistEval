function label = HierarchicalClustering_Complete(D, Num_Cluster)
	D2 = squareform(D);
	L = linkage(D2, 'complete');
	label = cluster(L, 'maxclust', Num_Cluster);
end