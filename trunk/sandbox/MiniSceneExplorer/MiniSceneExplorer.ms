------------------------------------------------------------------------------------------------------------------
-- This script creates a mini scene explorer.
-- Original author: Alessandro Ardolino
-- Modifications: Christopher Diggins
------------------------------------------------------------------------------------------------------------------

-- Main split container
global globalSplitContainer = dotNetObject "System.Windows.Forms.SplitContainer"
globalSplitContainer.Dock = (dotNetClass "System.Windows.Forms.DockStyle").Fill
globalSplitContainer.Orientation = (dotNetClass "System.Windows.Forms.Orientation").Horizontal
globalSplitContainer.FixedPanel = (dotNetClass "System.Windows.Forms.FixedPanel").Panel2
globalSplitContainer.Panel2MinSize = 36
globalSplitContainer.splitterDistance = 512
globalSplitContainer.isSplitterFixed = true
globalSplitContainer.splitterWidth = 1

-- Defining some buttons 
expandAllBtn = dotNetObject "System.Windows.Forms.Button"
expandAllBtn.flatStyle = (dotNetClass "System.Windows.Forms.FlatStyle").Standard
expandAllBtn.width = 32
expandAllBtn.height = 32
expandAllBtn.location = (dotNetObject "System.Drawing.Point" 4 0)
globalSplitContainer.Panel2.controls.add expandAllBtn

-- Tab Object
global mainTabCtrl = dotNetObject "System.Windows.Forms.TabControl"
mainTabCtrl.Dock = (dotNetClass "System.Windows.Forms.DockStyle").Fill

-- Tab page
explorerTabPage = dotNetObject "System.Windows.Forms.TabPage"
explorerTabPage.text = "explorer"
mainTabCtrl.controls.add explorerTabPage

-- Add the tab control to the panel1 of the globalSplitContainer
globalSplitContainer.Panel1.controls.add mainTabCtrl

-- explorer tree view object
global explorerTV = dotNetObject "System.Windows.Forms.TreeView"

--add to the right tab page
explorerTabPage.controls.add explorerTV
explorerTV.height = 256
explorerTV.width = 128
explorerTV.location = dotNetObject "System.Drawing.Point" 4 4
explorerTV.AllowDrop = on
explorerTV.Sorted = on
explorerTV.Dock = (dotNetClass "System.Windows.Forms.DockStyle").Fill

-- Last selected explorer treenode
global oTV_lastSelected = dotNetObject "System.Windows.Forms.TreeNode"
global explorerTV_expanded = false

-- The image list containing ALL the icons and images used in the tool
global imgList = dotNetObject "System.Windows.Forms.ImageList"

fn loadImg fileName =
(
   imgList.Images.Add( (dotNetClass "System.Drawing.Image").FromFile("C:\\aa_icons\\" + fileName))
)

loadImg("00_aa_icon_drawed.png")
loadImg("01_aa_icon_hidden.png")
loadImg("02_aa_icon_geometry.png")
loadImg("03_aa_icon_selected.png")
loadImg("04_aa_icon_sceneRoot.png")
loadImg("05_aa_icon_light.png")
loadImg("06_aa_icon_expandAll.png")
loadImg("07_aa_icon_drive.png")
loadImg("08_aa_icon_folder.png")
	
imgList.TransparentColor = (dotNetClass "system.drawing.color").white
explorerTV.imageList = imgList
expandAllBtn.image = imgList.images.item[5]

-- The main dotnet form
global hForm = dotNetObject "MaxCustomControls.MaxForm"
hForm.text = "basic explorer"
hForm.height = 512
hForm.width = 256
hForm.controls.add globalSplitContainer --add the treeview to the Form
hForm.IsMdiContainer = true
hform.formBorderStyle = (dotNetClass "System.Windows.Forms.FormBorderStyle").Sizable     
maxWinPtr = DotNetObject "System.IntPtr" (windows.getMAXHWND())
HWINDptr = DotNetObject "MaxCustomControls.Win32HandleWrapper" maxWinPtr
		
global explorerCM = dotNetObject "System.Windows.Forms.ContextMenu"
explorerTV.ContextMenu = explorerCM

-- Drag and drop fx global for all the treeviews
global drag_effect = dotNetclass "System.Windows.Forms.DragDropEffects"
global tree_node = dotNetClass "System.Windows.Forms.TreeNode"

------------------------------------------------------------------------------------------------------------------------------------
-- Functions

fn explorerTV_addChildren theNode theChildren =
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
		( newNode.imageIndex = 2; newNode.SelectedImageIndex = 2 )
		
		explorerTV_addChildren newNode c.children --recursive call for new node
	)
)
	
fn explorerTV_createNodes explorerTV = 
(
	  explorerTV.BeginUpdate()
		explorerTV.Nodes.Clear()
		theRoot = explorerTV.Nodes.add "scene root" --add parent node
		theRoot.tag = dotNetMXSValue "root"
		theRoot.name = "rNode"
		theRoot.imageIndex = 4
		theRoot.SelectedImageIndex = 4
		
		rootNodes = for o in objects where o.parent == undefined collect o

		explorerTV_addChildren theRoot rootNodes --no need to pass the TreeView

		rNode = explorerTV.Nodes.Find "rNode" false
		rNode[1].Expand()
	  explorerTV.EndUpdate()	
)

-- On drag over event
fn explorerTV_dragOver sender arg = 
(
	arg.effect = if arg.data.GetDataPresent tree_node then 
		(
			item = arg.data.GetData tree_node
			--print item.tag
			if item.treeview.equals explorerTV then drag_effect.move else drag_effect.none
		)
		else drag_effect.none
)

-- Item drag event
fn explorerTV_itemDrag sender arg = 
(
	explorerTV.DoDragDrop arg.item drag_effect.move
)

-- Item drop event
fn explorerTV_dragdrop sender arg = 
(
	p = explorerTV.PointToClient (dotNetObject "System.Drawing.Point" arg.x arg.y)
	if (node = explorerTV.GetNodeAt p.x p.y) != undefined then
	(
		--parenting arg-->child of node
		item = arg.data.GetData tree_node
		if (node.tag.value == "root") then item.tag.value.parent = undefined
		else item.tag.value.parent = node.tag.value
		
		--update
		explorerTV_createNodes explorerTV
	)
)
	
-- Function called when the left mouse button is pressed
fn explorerTV_leftClick explorerTV arg = 
(
	hitNode = explorerTV.GetNodeAt (dotNetObject "System.Drawing.Point" arg.x arg.y)
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


-- Context menu actions
fn mi_delete_c sender arg = 
( undo on (delete $) )

---------------------------------------------------------------
-- Rename

fn mi_rename_c sender arg = 
(
	explorerTV.SelectedNode = oTV_lastSelected
	explorerTV.LabelEdit = true
	if(explorerTV.SelectedNode.IsEditing == false) do
		explorerTV.SelectedNode.BeginEdit()
)

fn explorerTV_AfterLabelEdit sender arg = 
(
	explorerTV.LabelEdit = false
	oTV_lastSelected.EndEdit(false)
	oTV_lastSelected.tag.value.name = arg.label
	
	--update again...
	explorerTV_createNodes explorerTV 
)

fn mi_exprtSel_c sender arg = 
(
	--ask for the path
	--select all the children of the current node, option??
	--exportFile $.name selectedOnly:true
	print "to be implemented..."
)

---------------------------------------------------------------

fn mi_hideSel_c sender arg = (undo on (hide $))
fn mi_unhideSel_C sender arg = (undo on (unhide $))

------------------------------------------------------------------------------------------------------------------------------------
-- Right click event

fn explorerTV_rightClick explorerTV arg =
(
	--select the item of the treeview
	hitNode = explorerTV.GetNodeAt (dotNetObject "System.Drawing.Point" arg.x arg.y)
	if hitNode != undefined do --if a TreeView node was clicked,
		--...we try to select the object stored as value in the .tag
		try(select hitNode.tag.value)catch(max select none) 
	
	if hitNode != undefined and hitNode.tag.value == "root" do
		try(select $*)catch(max select none)
	
	oTV_lastSelected = hitNode
	
  if hitNode != undefined and hitNode.tag.value != "root" do(

  --change the intems in the context menu
	--title, object based
	explorerTV.ContextMenu.menuItems.clear()
	mi_header = dotNetObject "System.Windows.Forms.MenuItem"
	mi_header.text = hitNode.tag.value.name
	explorerTV.ContextMenu.menuItems.add(mi_header)
	
	--separator
	mi_separator = dotNetObject "System.Windows.Forms.MenuItem"
	mi_separator.text = "-"
	explorerTV.ContextMenu.menuItems.add(mi_separator)

  --actions on context menu
	mi_delete = dotNetObject "System.Windows.Forms.MenuItem"
	mi_delete.text = "delete"
	explorerTV.ContextMenu.menuItems.add(mi_delete)
	dotNet.addEventHandler mi_delete "Click" mi_delete_c
	
	mi_rename = dotNetObject "System.Windows.Forms.MenuItem"
	mi_rename.text = "rename"
	explorerTV.ContextMenu.menuItems.add(mi_rename)
	dotNet.addEventHandler mi_rename "Click" mi_rename_c
	
	mi_hideSel = dotNetObject "System.Windows.Forms.MenuItem"
	mi_hideSel.text = "hide selected"
	explorerTV.ContextMenu.menuItems.add(mi_hideSel)
	dotNet.addEventHandler mi_hideSel "Click" mi_hideSel_c
	
	mi_unhideSel = dotNetObject "System.Windows.Forms.MenuItem"
	mi_unhideSel.text = "unhide selected"
	explorerTV.ContextMenu.menuItems.add(mi_unhideSel)
 	dotNet.addEventHandler mi_unhideSel "Click" mi_unhideSel_c
	
	)--end do...delete!!
)


fn explorerTV_mouseCheck sender arg =
(
	if arg.button==arg.button.left do explorerTV_leftClick explorerTV arg
	if arg.button==arg.button.right do explorerTV_rightClick explorerTV arg
)

------------------------------------------------------------------------------------------------------------------------------------
-- Button methods

fn expandAllBtn_click sender arg = 
(
	if(explorerTV_expanded == false) then
	(
		explorerTV.ExpandAll()
		explorerTV_expanded = true
	)
	else
	(
		explorerTV.CollapseAll()
		explorerTV_expanded = false
		explorerTV_createNodes explorerTV
	)
)

-- On form closed event
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
-- Event Handlers:

dotNet.addEventHandler hForm "Closed" mainFormClosed
dotNet.addEventHandler explorerTV "mouseDown" explorerTV_mouseCheck
dotNet.addEventHandler explorerTV "DragOver" explorerTV_dragOver
dotNet.addEventHandler explorerTV "ItemDrag" explorerTV_itemDrag
dotNet.addEventHandler explorerTV "DragDrop" explorerTV_dragdrop
dotNet.addEventHandler explorerTV "AfterLabelEdit" explorerTV_AfterLabelEdit
dotNet.addEventHandler expandAllBtn "Click" expandAllBtn_click

------------------------------------------------------------------------------------------------------------------------------------
-- Initializers

explorerTV_createNodes explorerTV

--callback for the update of the treeview --> need a system to remove it!
callbacks.addScript #sceneNodeAdded "explorerTV_createNodes explorerTV" id:#nodeAdd_clbck
callbacks.addScript #nodePostDelete "explorerTV_createNodes explorerTV" id:#nodeDel_clbck
callbacks.addScript #nodeRenamed "explorerTV_createNodes explorerTV" id:#nodeRename_clbck
callbacks.addScript #postNodesCloned "explorerTV_createNodes explorerTV" id:#nodeClone_clbck
callbacks.addScript #postMirrorNodes "explorerTV_createNodes explorerTV" id:#nodeMirror_clbck
callbacks.addScript #sceneUndo "explorerTV_createNodes explorerTV" id:#undo_clbck
callbacks.addScript #sceneRedo "explorerTV_createNodes explorerTV" id:#redo_clbck

--show the form
hForm.show(HWINDptr)
