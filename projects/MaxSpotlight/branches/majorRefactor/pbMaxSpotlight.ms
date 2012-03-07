/*
 *	Copyright (c) 2012, Pixelbaker
 *	All rights reserved.
 *
 *	Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *		Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *		Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 *	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

--************************************************************************************
--              **** Pixelbaker ****
-- Name:              	MaxSpotlight
-- Create By:         	André Schaarschmidt
-- Creation Time:     	18:50 Tuesday, February 02, 2010
-- Version:				1.6.3
--
-- Description:	 	Tool for selecting objects by name, with a quick and spotlight-like search behavior.
--					Open the listener to see search results.
--					Supports wild cards. (eg.:Sph*re)
--					SettingsFile must be located in the same directory as the ms file.
--
-- Annotation:		If you wanna input text from another tool into MaxSpotlight you can use:
--					pbMaxSpotlight.Enter "Sph*re" autoSelect:true silentMode:true
--************************************************************************************
-- Version:
--	2010/04/09: separated the settings from the program code (by André Schaarschmidt)
--	2010/04/05: Replaced EditText with a DotNet-RichTextBox component (by André Schaarschmidt)

global pbMaxSpotlight
try(cui.UnRegisterDialogBar pbMaxSpotlight) catch()
try(DestroyDialog pbMaxSpotlight) catch()

(
	-- Function
	local settingPath = GetFilenamePath( GetThisScriptFilename() ) + "pbMaxSpotlight.ini"
	function GetSetting key = (GetINISetting settingPath #Settings key)

	
	-- Init
	local appLabel 			= if GetSetting #appLabel 		!= "" 	then GetSetting #appLabel 			else "<MaxSpotlight>"
	local defaultText 		= if GetSetting #defaultText 	!= "" 	then GetSetting #defaultText 		else "MaxSpotlight*"
	local _autoSelect		= if GetSetting #autoSelect 	!= "" 	then (GetSetting #autoSelect) 		as BooleanClass else false
	local _clearListener 	= if GetSetting #clearListener 	!= "" 	then (GetSetting #clearListener) 	as BooleanClass else true
	local _showNames		= if GetSetting #showNames 		!= "" 	then (GetSetting #showNames) 		as BooleanClass else true
	local _showCount		= if GetSetting #showCount 		!= "" 	then (GetSetting #showCount) 		as BooleanClass else true
	local _showSelectCount	= if GetSetting #showSelectCount != "" 	then (GetSetting #showSelectCount) 	as BooleanClass else true
	local _lostFocusSelect	= if GetSetting #lostFocusSelect != "" 	then (GetSetting #lostFocusSelect) 	as BooleanClass else true
	local silentOnDrop		= if GetSetting #silentOnDrop 	!= "" 	then (GetSetting #silentOnDrop) 	as BooleanClass else true
	local autoMarkAll		= if GetSetting #autoMarkAll	!= "" 	then (GetSetting #autoMarkAll) 		as BooleanClass else true
	local largeToolbar 		= if GetSetting #largeToolbar 	!= "" 	then (GetSetting #largeToolbar) 	as BooleanClass else false
	
	local heightBar = if largeToolbar then 39 else 30
	
	
	-- Rollout 
	rollout pbMaxSpotlight "MaxSpotlight"
	(
		-- Local Variable
		---------------------------------------------------------------------------------------------------------
		local dragDropEffect 	= DotNetClass "System.Windows.Forms.DragDropEffects"
		local dataFormats 		= DotNetClass "System.Windows.Forms.DataFormats"
		local netKeys 			= DotNetClass "System.Windows.Forms.Keys"
		local pos				= [2,2]
		local forceSelect		= false
		local forceNoClear		= true	/* when rollout gets initiated, it won't clear the listener */
		local verbosity			= true
		local isFocused			= false
		
		-- UI
		----------------------------
		DotNetControl dntSelectField "System.Windows.Forms.RichTextBox" text:defaultText pos:pos height:20
		
		
		-- Function
		----------------------------
		function SetControlProp=
		(
			/*
			 *	<void>SetControlProp
			 *	After the rollout gets created this function
			 *	sets the properties of the TextBox
			 */
			
			local bgCol = ColorMan.GetColor #window * 255
			
			dntSelectField.AcceptsTab 		= false
			dntSelectField.AllowDrop		= true
			dntSelectField.DetectUrls 		= false
			dntSelectField.MultiLine		= false
			dntSelectField.Visible 			= true
			dntSelectField.BackColor 		= dntSelectField.BackColor.FromArgb bgCol[1] bgCol[2] bgCol[3]
			dntSelectField.RichTextShortcutsEnabled = false
			
			dntSelectField.Update()
		)
		
		
		function isValidText txt =
		(
			/*
			 *	<BooleanClass> <String>txt
			 *	Checks a string against some equations.
			 */
			
			if txt != "" AND txt != " " AND txt != defaultText then true else false
		)
		
		
		function DoSelect =
		(
			/*
			 *	<void>DoSelect
			 *	Checks if a node with the exact TextBox text is in scene and selects it.
			 *	It does this even if other nodes include that text but also more.
			 *	If no exact match, it selects all objects which includes the text.
			 */
			
			local txt = dntSelectField.text
			
			if isValidText txt then
			(
				if GetNodeByName txt != undefined then
					local objArr = #(GetNodeByName txt)
				else
					local objArr = for objOn in objects where MatchPattern objOn.name pattern:("*"+txt+"*") collect objOn
				
				Select objArr
				
				if _showSelectCount AND verbosity then
					Format "\n% Selected: % object(s)\n" appLabel objArr.count
			)
			else
				dntSelectField.text = defaultText
			
			-- Reset forceSelect and verbosity
			forceSelect = false
			verbosity 	= true
		)
		
		
		function ShowResult forceSelect:false =
		(
			/*
			 *	<void>ShowResult 
			 *	Searches for all occurences of the TextBox text
			 *	in object names and prints them out.
			 */
			
			local txt = dntSelectField.text
			
			if _clearListener AND NOT forceNoClear AND verbosity then 
				ClearListener()
			
			forceNoClear = false
			
			if txt != "" AND txt != " " AND txt != defaultText then
			(
				local count 	= 0
				local outputTxt = ""
				
				if txt[1]=="*" then 
					txt = Substring txt 2 txt.count
				if txt[txt.count]=="*" then 
					txt = Substring txt 1 (txt.count-1)
				
				for objOn in objects where MatchPattern objOn.name pattern:("*"+txt+"*") do
				(
					if _showNames then
						Append outputTxt (appLabel+" "+objOn.name+"\n")
					
					if _showCount then
						count += 1
				)
				
				if _showNames AND verbosity then
					Format "%" outputTxt
				
				if _showCount AND verbosity then
					Format "\n% Found: % object(s)\n" appLabel count
			)
			
			if forceSelect OR _autoSelect then
				DoSelect()
		)
		
		
		function Enter txt autoSelect:false silentMode:false =
		(
			/*
			 *	<void>Enter <String>txt <BooleanClass>autoSelect: <BooleanClass>silentMode: 
			 *	Enters txt in the TextBox and will start the ShowResult function.
			 *	autoSelect determines if the Results should be automatically selected as well.
			 *	silentMode will stop all verbosity (clearListener, names, counts, selectionsCounts)
			 */
			
			if isKindOf txt String then
			(
				if isKindOf autoSelect BooleanClass then
				(
					if autoSelect then
						forceSelect = true
					if silentMode then
						verbosity = false
					
					dntSelectField.text = txt
				)
			)
			Ok
		)
		
		
		-- Event
		----------------------------
		on pbMaxSpotlight open do 
		(
			SetControlProp()
		)
		
		
		on pbMaxSpotlight resized p do
		(
			if pbMaxSpotlight.dialogBar then
			( 
				local dockState = cui.getDockState pbMaxSpotlight
				local newPos = if dockState == #cui_floatable then [12,4] else pos
				dntSelectField.pos = newPos
			)
		)
		
		
		on dntSelectField TextChanged sender args do 
		(
			ShowResult forceSelect:forceSelect
		)
		
		
		on dntSelectField Click sender args do
		(
			-- only run when the RichTextBox gets focused
			-- sets the cursor at the click position
			if NOT isFocused then
			(
				local mPos 	= args.location
				local pt 	= DotNetObject "System.Drawing.Point" mPos.x mPos.y
				local index = dntSelectField.GetCharIndexFromPosition pt
				dntSelectField.Select index 0
				isFocused = true
			)
		)
		
		
		on dntSelectField KeyUp sender args do
		(
			if args.KeyCode == netKeys.Enter then
				DoSelect()
		)
		
		
		on dntSelectField LostFocus sender args do
		(
			local txt = dntSelectField.text
			
			if isValidText txt then
			(
				if _lostFocusSelect then DoSelect()
			)
			else
				dntSelectField.text = defaultText
		)
		
		
		on dntSelectField DragDrop sender args do 
		( 
			local data = args.data.GetData(dataFormats.text)
			
			if silentOnDrop then verbosity = false
			Enter data autoSelect:true
		)
		
		
		on dntSelectField GotFocus sender args do
		(
			if dntSelectField.text == defaultText then
				dntSelectField.text = ""
			
			if autoMarkAll then
				dntSelectField.SelectAll()
			else
			(
				dntSelectField.SelectAll()
				isFocused = false			/* will invoke 'if-clause' in OnClick to run */
			)
		)
		
		
		on dntSelectField DragEnter sender args do
		( 
			if args.Data.GetDataPresent(DataFormats.Text) then 
			(
				args.Effect = dragDropEffect.copy
			)
		)
		
	) -- End of pbMaxSpotlight rollout

	
	-- Docking
	CreateDialog 			pbMaxSpotlight escapeEnable:false width:120 height:heightBar
	cui.RegisterDialogBar 	pbMaxSpotlight minSize:[115,heightBar] maxSize:[115,heightBar] style:#(#cui_dock_horz, #cui_floatable, #cui_handles)
	cui.DockDialogBar 		pbMaxSpotlight #cui_dock_top
)