/*
 *	Copyright (c) 2012, Pixelbaker
 *	All rights reserved.
 *
 *	Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *		Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *		Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 *	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

(
	try(CUI.unRegisterDialogBar ::ro_MaxSpotlight) catch()
	try(destroyDialog ::ro_MaxSpotlight) catch()

	
	local MaxSpotlightConfig = fileIn "config.ms"
	local MaxSpotlightUtil = fileIn "util.ms"
	
	
	rollout ro_MaxSpotlight "MaxSpotlight"
	(
		-- Local
		--------
		local _DragDropEffects = DotNetClass "System.Windows.Forms.DragDropEffects"
		local _DataFormats = DotNetClass "System.Windows.Forms.DataFormats"
		local _Keys = DotNetClass "System.Windows.Forms.Keys"
		
		local _forceClearListener = false -- when rollout gets initiated, it won't clear the listener
		local _forceSelect = false
		local _verbosity = true
		local _focused = false
		
		local _config
		local _util
		
		
		-- UI
		-----
		DotNetControl dntSelectField "System.Windows.Forms.RichTextBox" pos:[2,7] width:93 height:20
		Button btConfig "C" height:16 width:16 pos:[100,8]
		
		
		-- Function
		-----------
		
		-- private
		function initSelectField =
		(
			local bgCol = colorMan.getColor #window * 255
			dntSelectField.BackColor = dntSelectField.BackColor.FromARGB bgCol[1] bgCol[2] bgCol[3]
			
			dntSelectField.AcceptsTab = false
			dntSelectField.AllowDrop = true
			dntSelectField.DetectUrls = false
			dntSelectField.MultiLine = false
			dntSelectField.Visible = true
			dntSelectField.RichTextShortcutsEnabled = false
			
			dntSelectField.Text = _config.get #defaultText
			
			dntSelectField.Update()
		)
		
		
		-- private
		function isValidText txt =
		(
			return txt != "" and not isSpace txt and txt != (_config.get #defaultText)
		)
		
		
		-- private
		function canShowSelectedNumNodes =
		(
			return _config.get #showSelectCount and _verbosity
		)
		
		
		-- private
		function canListenerBeCleared =
		(
			local listenerClear = _config.get #clearListener
			return listenerClear and _forceClearListener and _verbosity
		)
		
		
		-- private
		function canShowNames =
		(
			return _config.get #showNames and _verbosity
		)
		
		
		-- private
		function canShowCount =
		(
			return _config.get #showCount and _verbosity
		)
		
		
		-- private
		function doSelect txt =
		(
			if isValidText txt then (
				local nodes = _util.selectNodeByName txt
				
				if canShowSelectedNumNodes() then
					_util.logSelectedNumNodes nodes.count
			) else
				dntSelectField.text = _config.get #defaultText
			
			-- Reset
			_forceSelect = false
			_verbosity 	= true
		)
		
		
		-- private
		function showResult txt =
		(
			/*
				Searches for all occurences of the TextBox text in object names and prints them out.
			 */
			
			if canListenerBeCleared() then 
				clearListener()
			
			_forceClearListener = true
			
			local nodeNames = #()
			
			if isValidText txt then (
				local nodes = _util.getExactNodesOrNodesMatchingPattern txt
				nodeNames = for nodeOn in nodes collect nodeOn.name
			)
			
			if canShowNames() then
				_util.logResults nodeNames
			
			if canShowCount() then
				_util.logFoundNumNodes nodeNames.count
		)
		
		
		-- public
		function enter txt autoSelect:false silentMode:true =
		(
			/*
				Enters txt in the TextBox. 
			
				@note: Triggers event "TextChanged" on dntSelectField.
				
				@keyword silentMode: controls overall verbosity (clearListener, names, counts, selectionsCounts)
				@type silentMode: Bool
			 */
			
			if autoSelect then
				_forceSelect = true
			if silentMode then
				_verbosity = false
			
			dntSelectField.text = txt
			
			Ok
		)
		
		
		-- private
		function setCursorAtClickPosition pos =
		(
			local pt = DotNetObject "System.Drawing.Point" pos.x pos.y
			local index = dntSelectField.GetCharIndexFromPosition pt
			dntSelectField.Select index 0
			
			_focused = true
		)
		
		
		-- public
		function createUI =
		(
			createDialog ::ro_MaxSpotlight escapeEnable:false width:120 height:34
			CUI.registerDialogBar ::ro_MaxSpotlight style:#(#cui_dock_horz, #cui_floatable, #cui_handles)
			CUI.dockDialogBar ::ro_MaxSpotlight #cui_dock_top
		)
		
		
		-- Event
		--------
		on btConfig pressed do
		(
			_config.invalidateConfig()
			_config.showConfig()
		)
		
		
		on ro_MaxSpotlight open do 
		(
			_config = MaxSpotlightConfig()
			_util = MaxSpotlightUtil()
			
			initSelectField()
		)
		
		
		on dntSelectField TextChanged sender args do 
		(
			if not _config.isValid() then
				_config.init()
			
			showResult dntSelectField.text
			
			if _forceSelect or _config.get #autoSelect then
				doSelect dntSelectField.text
		)
		
		
		on dntSelectField Click sender args do
		(
			if not _focused then
				setCursorAtClickPosition args.location
		)
		
		
		on dntSelectField KeyUp sender args do
		(
			if args.KeyCode == _Keys.Enter then
				doSelect dntSelectField.text
		)
		
		
		on dntSelectField LostFocus sender args do
		(
			if isValidText dntSelectField.text then (
				if _config.get #lostFocusSelect then 
					doSelect dntSelectField.text
			) else
				dntSelectField.text = _config.get #defaultText
		)
		
		
		on dntSelectField DragDrop sender args do 
		( 
			if _config.get #silentOnDrop then 
				_verbosity = false
			
			local txt = args.data.GetData (_DataFormats.text)
			enter txt autoSelect:true silentMode:false
		)
		
		
		on dntSelectField GotFocus sender args do
		(
			if dntSelectField.text == _config.get #defaultText then
				dntSelectField.text = ""
			
			dntSelectField.SelectAll()
			
			if not _config.get #autoMarkAll then
				_focused = false -- invokes 'if-clause' in event "Click"
		)
		
		
		on dntSelectField DragEnter sender args do
		( 
			if args.Data.GetDataPresent (_DataFormats.Text) then
				args.Effect = _DragDropEffects.copy
		)
	)
	
	
	::ro_MaxSpotlight.createUI()
)