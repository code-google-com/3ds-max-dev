------------------------------------------------------------------------------------------------------------------
--dotnet only interface
--split container for the bottom row of button and the top area for the tab control
	--panel1
		--there's a tab controls containing:
		--		-treeview for scene objects, outliner
	--panel2
		--buttons
------------------------------------------------------------------------------------------------------------------
--main split container
global globalSplitContainer = dotNetObject "System.Windows.Forms.SplitContainer"
globalSplitContainer.Dock = (dotNetClass "System.Windows.Forms.DockStyle").Fill
globalSplitContainer.Orientation = (dotNetClass "System.Windows.Forms.Orientation").Horizontal
globalSplitContainer.FixedPanel = (dotNEtClass "System.Windows.Forms.FixedPanel").Panel2
globalSplitContainer.Panel2MinSize = 36
globalSplitContainer.splitterDistance = 512
globalSplitContainer.isSplitterFixed = true
globalSplitContainer.splitterWidth = 1
--globalSplitContainer.Panel2.Padding.Top = (dotNetObject "System.Windows.Forms.Padding" 40)


--defining some buttons TBD...
expandAllBtn = dotNetObject "System.Windows.Forms.Button"
expandAllBtn.flatStyle = (dotNetClass "System.Windows.Forms.FlatStyle").Standard
expandAllBtn.width = 32
expandAllBtn.height = 32
expandAllBtn.location = (dotNetObject "System.Drawing.Point" 4 0)
globalSplitContainer.Panel2.controls.add expandAllBtn

/*
expandAllBtn2 = dotNetObject "System.Windows.Forms.Button"
expandAllBtn2.flatStyle = (dotNetClass "System.Windows.Forms.FlatStyle").System
expandAllBtn2.width = 32
expandAllBtn2.height = 32
expandAllBtn2.location = (dotNetObject "System.Drawing.Point" 40 0)
globalSplitContainer.Panel2.controls.add expandAllBtn2

helpBtn = dotNetObject "System.Windows.Forms.Button"
helpBtn.flatStyle = (dotNetClass "System.Windows.Forms.FlatStyle").System
helpBtn.width = 32
helpBtn.height = 32
helpBtn.text = "H"
--helpBtn.Dock = (dotNetClass "System.Windows.Forms.DockStyle").Right
helpBtn.location = (dotNetObject "System.Drawing.Point" 76 0)
globalSplitContainer.Panel2.controls.add helpBtn */

--tab Object
global mainTabCtrl = dotNetObject "System.Windows.Forms.TabControl"
mainTabCtrl.Dock = (dotNetClass "System.Windows.Forms.DockStyle").Fill
--tab pages
outlinerTabPage = dotNetObject "System.Windows.Forms.TabPage"
outlinerTabPage.text = "Outliner"
layerMngrTabPage = dotNetObject "System.Windows.Forms.TabPage"
layerMngrTabPage.text = "Layer Manager"
projectMngrTabPage = dotNetObject "System.Windows.Forms.TabPage"
projectMngrTabPage.text = "Project Manager"

mainTabCtrl.controls.add outlinerTabPage

--add the tab control to the panel1 of the globalSplitContainer
globalSplitContainer.Panel1.controls.add mainTabCtrl


--outliner tree view object
global outlinerTV = dotNetObject "System.Windows.Forms.TreeView"
--add to the right tab page
outlinerTabPage.controls.add outlinerTV
outlinerTV.height = 256
outlinerTV.width = 128
outlinerTV.location = dotNetObject "System.Drawing.Point" 4 4
outlinerTV.AllowDrop = on
outlinerTV.Sorted = on
outlinerTV.Dock = (dotNetClass "System.Windows.Forms.DockStyle").Fill
--last selected outliner treenode
global oTV_lastSelected = dotNetObject "System.Windows.Forms.TreeNode"
global outlinerTV_expanded = false


--the image list containing ALL the icons and images used in the tool
global imgList = dotNetObject "System.Windows.Forms.ImageList"
--load images, needs a fn!!!
imgList.Images.Add( (dotNetClass "System.Drawing.Image").FromFile("C:\\aa_icons\\00_aa_icon_drawed.png"))
imgList.Images.Add( (dotNetClass "System.Drawing.Image").FromFile("C:\\aa_icons\\01_aa_icon_hidden.png"))
imgList.Images.Add( (dotNetClass "System.Drawing.Image").FromFile("C:\\aa_icons\\02_aa_icon_geometry.png"))
imgList.Images.Add( (dotNetClass "System.Drawing.Image").FromFile("C:\\aa_icons\\03_aa_icon_selected.png"))
imgList.Images.Add( (dotNetClass "System.Drawing.Image").FromFile("C:\\aa_icons\\04_aa_icon_sceneRoot.png"))
imgList.Images.Add( (dotNetClass "System.Drawing.Image").FromFile("C:\\aa_icons\\05_aa_icon_light.png"))
imgList.Images.Add( (dotNetClass "System.Drawing.Image").FromFile("C:\\aa_icons\\06_aa_icon_expandAll.png"))
imgList.Images.Add( (dotNetClass "System.Drawing.Image").FromFile("C:\\aa_icons\\07_aa_icon_drive.png"))
imgList.Images.Add( (dotNetClass "System.Drawing.Image").FromFile("C:\\aa_icons\\08_aa_icon_folder.png"))

	
imgList.TransparentColor = (dotNetClass "system.drawing.color").white
--assignment
outlinerTV.imageList = imgList

expandAllBtn.image = imgList.images.item[5]



--the main dotnet form
global hForm = dotNetObject "MaxCustomControls.MaxForm"
hForm.text = "basic outliner"
hForm.height = 512
hForm.width = 256
hForm.controls.add globalSplitContainer --add the treeview to the Form
--hForm.topmost = true
hForm.IsMdiContainer = true
hform.formBorderStyle = (dotNetClass "System.Windows.Forms.FormBorderStyle").Sizable     
maxWinPtr = DotNetObject "System.IntPtr" (windows.getMAXHWND())
HWINDptr = DotNetObject "MaxCustomControls.Win32HandleWrapper" maxWinPtr
	
--custom colors from maxForm
/*layerMngrTabPage.BackColor = hForm.BackColor
projectMngrTabPage.BackColor = hForm.BackColor*/
	
global outlinerCM = dotNetObject "System.Windows.Forms.ContextMenu"
outlinerTV.ContextMenu = outlinerCM


--DnD fx global for all the treeviews?
global drag_effect = dotNetclass "System.Windows.Forms.DragDropEffects"
global tree_node = dotNetClass "System.Windows.Forms.TreeNode"

------------------------------------------------------------------------------------------------------------------------------------
--functions
------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------
--OUTLINER
-----------------------------------------------------
fn outlinerTV_addChildren theNode theChildren =
(
	for c in theChildren do
	(
		newNode = theNode.Nodes.add c.name --add to the parent!
		newNode.tag = dotNetMXSValue c --.tag can contain a MXS value
		newNode.name = c.name
		--node types
		type = classOf c
		if ((#(4113, 0) as string) == (c.classID as string)) then 
		(	newNode.imageIndex = 5; newNode.SelectedImageIndex = 5 )
		else
		(   newNode.imageIndex = 2; newNode.SelectedImageIndex = 2 )
		
		outlinerTV_addChildren newNode c.children --recursive call for new node
	)
)
	
fn outlinerTV_createNodes outlinerTV = 
(
	outlinerTV.BeginUpdate()
		outlinerTV.Nodes.Clear()
		theRoot = outlinerTV.Nodes.add "scene root" --add parent node
		theRoot.tag = dotNetMXSValue "root"
		theRoot.name = "rNode"
		theRoot.imageIndex = 4
		theRoot.SelectedImageIndex = 4
		
		rootNodes = for o in objects where o.parent == undefined collect o

		outlinerTV_addChildren theRoot rootNodes --no need to pass the TreeView

		rNode = outlinerTV.Nodes.Find "rNode" false
		rNode[1].Expand()
	outlinerTV.EndUpdate()
		
	--outlinerTV.SelectedNode = oTV_lastSelected
	--outlinerTV.SelectedNode.Expand()

)

fn outlinerTV_dragOver sender arg = 
(
	arg.effect = if arg.data.GetDataPresent tree_node then 
		(
			item = arg.data.GetData tree_node
			--print item.tag
			if item.treeview.equals outlinerTV then drag_effect.move else drag_effect.none
		)
		else drag_effect.none
)

fn outlinerTV_itemDrag sender arg = 
(
	outlinerTV.DoDragDrop arg.item drag_effect.move
)

fn outlinerTV_dragdrop sender arg = 
(
	p = outlinerTV.PointToClient (dotNetObject "System.Drawing.Point" arg.x arg.y)
	if (node = outlinerTV.GetNodeAt p.x p.y) != undefined then
	(
		--parenting arg-->child of node
		item = arg.data.GetData tree_node
		if (node.tag.value == "root") then item.tag.value.parent = undefined
		else item.tag.value.parent = node.tag.value
		
		--update
		outlinerTV_createNodes outlinerTV
	)
)
	
--fns to call when mouse is pressed
fn outlinerTV_leftClick outlinerTV arg = 
(
	hitNode = outlinerTV.GetNodeAt (dotNetObject "System.Drawing.Point" arg.x arg.y)
	if hitNode != undefined then
	( 
		if  hitNode.tag.value == "root" then try(select $*)catch(max select none) 
		else try(select hitNode.tag.value)catch(max select none) 
	)
	else
	(
		max select none
	)
	
	oTV_lastSelected = hitNode
)


--context menu actions
fn mi_delete_c sender arg = 
( undo on (delete $) )

---------------------------------------------------------------
--rename
---------------------------------------------------------------
fn mi_rename_c sender arg = 
(
	outlinerTV.SelectedNode = oTV_lastSelected
	outlinerTV.LabelEdit = true
	if(outlinerTV.SelectedNode.IsEditing == false) do
		outlinerTV.SelectedNode.BeginEdit()
)

fn outlinerTV_AfterLabelEdit sender arg = 
(
	outlinerTV.LabelEdit = false
	oTV_lastSelected.EndEdit(false)
	oTV_lastSelected.tag.value.name = arg.label
	
	--update again...
	outlinerTV_createNodes outlinerTV 
)

fn mi_exprtSel_c sender arg = 
(
	--ask for the path
	--select all the children of the current node, option??
	--exportFile $.name selectedOnly:true
	print "to be implemented..."
)

---------------------------------------------------------------
--CONSIDER CHILD NODES WITH A GLOBAL VAR!!!!!
--CHANGE ICON TOO!!!!
---------------------------------------------------------------
fn mi_hideSel_c sender arg = (undo on (hide $))
fn mi_unhideSel_C sender arg = (undo on (unhide $))

------------------------------------------------------------------------------------------------------------------------------------
-- RIGHT CLICK EVENT
------------------------------------------------------------------------------------------------------------------------------------
fn outlinerTV_rightClick outlinerTV arg =
(
	--select the item of the treeview
	hitNode = outlinerTV.GetNodeAt (dotNetObject "System.Drawing.Point" arg.x arg.y)
	if hitNode != undefined do --if a TreeView node was clicked,
		--...we try to select the object stored as value in the .tag
		try(select hitNode.tag.value)catch(max select none) 
	
	if hitNode != undefined and hitNode.tag.value == "root" do
		try(select $*)catch(max select none)
	
	oTV_lastSelected = hitNode
	
--sistemare....
if hitNode != undefined and hitNode.tag.value != "root" do(
--change the intems in the context menu
	--title, object based
	outlinerTV.ContextMenu.menuItems.clear()
	mi_header = dotNetObject "System.Windows.Forms.MenuItem"
	mi_header.text = hitNode.tag.value.name
	outlinerTV.ContextMenu.menuItems.add(mi_header)
	--separator
	mi_separator = dotNetObject "System.Windows.Forms.MenuItem"
	mi_separator.text = "-"
	outlinerTV.ContextMenu.menuItems.add(mi_separator)
--actions on context menu
	mi_delete = dotNetObject "System.Windows.Forms.MenuItem"
	mi_delete.text = "delete"
	outlinerTV.ContextMenu.menuItems.add(mi_delete)
	dotNet.addEventHandler mi_delete "Click" mi_delete_c
	
	mi_rename = dotNetObject "System.Windows.Forms.MenuItem"
	mi_rename.text = "rename"
	outlinerTV.ContextMenu.menuItems.add(mi_rename)
	dotNet.addEventHandler mi_rename "Click" mi_rename_c
	
	mi_hideSel = dotNetObject "System.Windows.Forms.MenuItem"
	mi_hideSel.text = "hide selected"
	outlinerTV.ContextMenu.menuItems.add(mi_hideSel)
	dotNet.addEventHandler mi_hideSel "Click" mi_hideSel_c
	
	mi_unhideSel = dotNetObject "System.Windows.Forms.MenuItem"
	mi_unhideSel.text = "unhide selected"
	outlinerTV.ContextMenu.menuItems.add(mi_unhideSel)
	dotNet.addEventHandler mi_unhideSel "Click" mi_unhideSel_c
	
	)--end do...delete!!
)


fn outlinerTV_mouseCheck sender arg =
(
	if arg.button==arg.button.left do outlinerTV_leftClick outlinerTV arg
	if arg.button==arg.button.right do outlinerTV_rightClick outlinerTV arg
)


------------------------------------------------------------------------------------------------------------------------------------
--buttons methods
------------------------------------------------------------------------------------------------------------------------------------

fn expandAllBtn_click sender arg = 
(
	if(outlinerTV_expanded == false) then
	(
		outlinerTV.ExpandAll()
		outlinerTV_expanded = true
	)
	else
	(
		outlinerTV.CollapseAll()
		outlinerTV_expanded = false
		outlinerTV_createNodes outlinerTV
	)
)


--operation on form closed event
fn mainFormClosed sender arg = 
(
	--delete all the callbacks!
	callbacks.RemoveScripts #sceneNodeAdded id:#nodeAdd_clbck
	callbacks.RemoveScripts #sceneNodeAdded id:#nodeDel_clbck
	callbacks.RemoveScripts #sceneNodeAdded id:#nodeRename_clbck
	callbacks.RemoveScripts #sceneNodeAdded id:#nodeClone_clbck
	callbacks.RemoveScripts #sceneNodeAdded id:#nodeMirror_clbck
	callbacks.RemoveScripts #sceneNodeAdded id:#undo_clbck
	callbacks.RemoveScripts #sceneNodeAdded id:#redo_clbck
)

------------------------------------------------------------------------------------------------------------------------------------
--Event Handlers:
------------------------------------------------------------------------------------------------------------------------------------
dotNet.addEventHandler hForm "Closed" mainFormClosed

dotNet.addEventHandler outlinerTV "mouseDown" outlinerTV_mouseCheck
dotNet.addEventHandler outlinerTV "DragOver" outlinerTV_dragOver
dotNet.addEventHandler outlinerTV "ItemDrag" outlinerTV_itemDrag
dotNet.addEventHandler outlinerTV "DragDrop" outlinerTV_dragdrop
dotNet.addEventHandler outlinerTV "AfterLabelEdit" outlinerTV_AfterLabelEdit

--dotNet.addEventHandler prjMngrTV "mouseDown" prjMngrTV_mouseClick

dotNet.addEventHandler expandAllBtn "Click" expandAllBtn_click

 
------------------------------------------------------------------------------------------------------------------------------------
--inits
------------------------------------------------------------------------------------------------------------------------------------
outlinerTV_createNodes outlinerTV
--layerMngr_createNodes layerMngrTV
--prjMngrTV_createNodes prjMngrTV


--callback for the update of the treeview --> need a system to remove it!
callbacks.addScript #sceneNodeAdded "outlinerTV_createNodes outlinerTV" id:#nodeAdd_clbck
callbacks.addScript #nodePostDelete "outlinerTV_createNodes outlinerTV" id:#nodeDel_clbck
callbacks.addScript #nodeRenamed "outlinerTV_createNodes outlinerTV" id:#nodeRename_clbck
callbacks.addScript #postNodesCloned "outlinerTV_createNodes outlinerTV" id:#nodeClone_clbck
callbacks.addScript #postMirrorNodes "outlinerTV_createNodes outlinerTV" id:#nodeMirror_clbck
callbacks.addScript #sceneUndo "outlinerTV_createNodes outlinerTV" id:#undo_clbck
callbacks.addScript #sceneRedo "outlinerTV_createNodes outlinerTV" id:#redo_clbck

--show the form
hForm.show(HWINDptr)



--delete
--showmethods ContextMenu