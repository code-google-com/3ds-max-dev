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
	
	
	global ro_MaxSpotlight
	rollout ro_MaxSpotlight "MaxSpotlight"
	(
		-- Local
		--------
		local _DragDropEffects = DotNetClass "System.Windows.Forms.DragDropEffects"
		local _DataFormats = DotNetClass "System.Windows.Forms.DataFormats"
		local _Keys = DotNetClass "System.Windows.Forms.Keys"
		
		
		-- won't clear the listener unless SelectField is initialized
		local _initSelectFieldFinished = false 
		local _dropped = false
		local _timer = 0
		
		
		local _config
		local _util
		
		
		local _MODE = (
			struct _MODE
			(
				DragDrop 	= 1,
				EnterKeyUp 	= 2,
				LostFocus 	= 3,
				TextChanged = 4
			)
			_MODE()
		)
		
		
		-- UI
		-----
		DotNetControl dntSelectField "System.Windows.Forms.RichTextBox" pos:[2,7] width:93 height:20
		Button btConfig "C" height:16 width:16 pos:[100,8]
		Timer tTypingTimer "Typing Timer" interval:0 active:false
		
		
		-- Function
		-----------
		
		-- public
		function createUI =
		(
			createDialog ::ro_MaxSpotlight escapeEnable:false width:120 height:34
			CUI.registerDialogBar ::ro_MaxSpotlight style:#(#cui_dock_horz, #cui_floatable, #cui_handles)
			CUI.dockDialogBar ::ro_MaxSpotlight #cui_dock_top
		)
		
		
		-- private
		function startTimer =
		(
			tTypingTimer.interval = _config.get #typingTimerInMs
			tTypingTimer.active = true
		)
		
		
		-- private
		function stopTimer =
		(
			tTypingTimer.active = false
		)
		
		
		-- private
		function isValidText txt =
		(
			return txt != "" and not isSpace txt and txt != (_config.get #defaultText)
		)
		
		
		-- private
		function canListenerBeCleared =
		(
			return (_config.get #clearListener) and _initSelectFieldFinished
		)
		
		
		-- private
		function logNodesWhichMatch txt =
		(
			/*
				Searches for all occurences of the TextBox text in object names and prints them out.
			 */
			
			local nodes = _util.getExactNodesOrNodesMatchingPattern txt
			local nodeNames = for nodeOn in nodes collect nodeOn.name
			
			if _config.get #showNames then
				_util.logNodeNames nodeNames (_config.get #lineLimit)
			
			if _config.get #showCount then
				_util.logFoundNumNodes nodeNames.count
		)
		
		
		-- private
		function initConfig =
		(
			_config.init()
			tTypingTimer.interval = _config.get #typingTimerInMs
		)
		
		
		-- private
		function logAndOrSelect mode txt =
		(
			/*
				@note: 	The different behavior sometimes vary so little, that it can be confusing.
						I am keeping all behaviors together here for better overview.
			 */
			
			if not _config.isValid() then
				initConfig()
			
			case mode of (
				(_MODE.DragDrop): (
					if not isValidText txt then (
						dntSelectField.text = _config.get #defaultText
						dntSelectField.selectAll()
						return Ok
					)
					
					local nodes = _util.selectNodeByName txt
					
					if not _config.get #silentOnDrop and _config.get #showSelectCount then
						_util.logSelectedNumNodes nodes.count
					
					dntSelectField.text = txt
					
					if _config.get #silentOnDrop then
						_dropped = true
					
					stopTimer()
				)
				
				(_MODE.EnterKeyUp): (
					if not isValidText txt then (
						dntSelectField.text = _config.get #defaultText
						dntSelectField.selectAll()
						return Ok
					)
					
					local nodes = _util.selectNodeByName txt
					
					if _config.get #showSelectCount then
						_util.logSelectedNumNodes nodes.count
					
					stopTimer()
					dntSelectField.selectAll()
				)
				
				(_MODE.LostFocus): (
					if not isValidText txt then (
						dntSelectField.text = _config.get #defaultText
						return Ok
					)
					
					if _config.get #lostFocusSelect then (
						local nodes = _util.selectNodeByName txt
						
						if _config.get #showSelectCount then
							_util.logSelectedNumNodes nodes.count
						
						stopTimer()
					)
				)
				
				(_MODE.TextChanged): (
					if _initSelectFieldFinished and not _dropped and isValidText txt then
						startTimer()
					else
						stopTimer()
					
					_dropped = false
				)
			)
		)
		
		
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
			
			_initSelectFieldFinished = true
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
			local Configurator = fileIn "config.ms"
			local logAndOrSelectUtil = fileIn "util.ms"
			
			_config = Configurator()
			_util = logAndOrSelectUtil()
			
			initSelectField()
		)
		
		
		on tTypingTimer tick do
		(
			if canListenerBeCleared() then 
				clearListener()
			
			logNodesWhichMatch dntSelectField.text
			
			if _config.get #autoSelect then (
				local nodes = _util.selectNodeByName dntSelectField.text
				
				if _config.get #showSelectCount then
					_util.logSelectedNumNodes nodes.count
			)
			
			stopTimer()
		)
		
		
		-- SelectField Events
		on dntSelectField TextChanged sender args do 
		(
			logAndOrSelect _MODE.TextChanged dntSelectField.text
		)
		
		
		on dntSelectField KeyUp sender args do
		(
			if args.KeyCode == _Keys.Enter then
				logAndOrSelect _MODE.EnterKeyUp dntSelectField.text
		)
		
		
		on dntSelectField LostFocus sender args do
		(
			logAndOrSelect _MODE.LostFocus dntSelectField.text
		)
		
		
		on dntSelectField DragDrop sender args do 
		( 
			local txt = args.data.GetData (_DataFormats.text)
			logAndOrSelect _MODE.DragDrop txt
		)
		
		
		on dntSelectField GotFocus sender args do
		(
			if dntSelectField.text == _config.get #defaultText then
				dntSelectField.text = ""
			
			dntSelectField.selectAll()
		)
		
		
		on dntSelectField DragEnter sender args do
		( 
			if args.Data.GetDataPresent (_DataFormats.Text) then
				args.Effect = _DragDropEffects.copy
		)
	)
	
	
	::ro_MaxSpotlight.createUI()
)