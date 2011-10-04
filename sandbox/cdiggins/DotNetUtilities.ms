function VisitNodes n f = 
(  
  f n 
  for i = 0 to n.NumberOfChildren - 1 do 
     VisitNodes (n.GetChildNode i) f
)

function NodeNamePrinter n = print n.Name

VisitNodes i.RootNode NodeNamePrinter
