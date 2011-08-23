--------------------------------------------------------------------------------------------------
--	basicOutliner
--	author: Alessandro Ardolino
--	contact info: me@aardolino.com
--------------------------------------------------------------------------------------------------

--load the assembly
dotnet.loadassembly ((GetDir  #scripts) + "\\basicOutliner\\basicOutliner.dll")
global basicOutliner_class = dotNetObject  "basicOutliner.basicOutliner_class"

--run the main application form
basicOutliner_class.showForm()