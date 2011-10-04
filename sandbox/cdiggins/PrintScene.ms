fn OutputNode n indent = (
	print (indent + n.name)
	for n2 in n.children do OutputNode n2 (indent + "  ")
)
roots = for o in objects where o.parent == undefined collect o
for n in roots do OutputNode n ""
