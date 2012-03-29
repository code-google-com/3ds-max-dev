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
	local GUIWrapper
	struct GUIWrapper
	(
		/*
			Wraps the rollout to allow for advanced configuration.
			Mainly for configuration which must be done after a dialog was created,
			like configuration of the config directory.
		 */
		
		private _configDir = (getDir #userScripts),
		
		
		private _roMain = (
			rollout _roMain "MaxSpotlight"
			(
				/*
					The input text field for querying nodes in the current scene.
					@note: when dialog is created,
					immediately call initConfig with a path to where the ini should be stored.
				 */
				
				-- Local
				--------
				local _Configurator = (fileIn "config.ms")
				local _config
				local _util = (fileIn "util.ms")()
				
				local _DragDropEffects = DotNetClass "System.Windows.Forms.DragDropEffects"
				local _DataFormats = DotNetClass "System.Windows.Forms.DataFormats"
				local _Keys = DotNetClass "System.Windows.Forms.Keys"
				
				local _initSelectFieldFinished = false -- Won't clear the listener unless SelectField is initialized
				local _dragDropTriggered = false -- DragDrop Event needs this to tell TextChanged not to start the timer
				
				
				-- UI
				-----
				DotNetControl dncSelectField "System.Windows.Forms.RichTextBox" pos:[2,7] width:93 height:20
				Button btConfig "C" height:16 width:16 pos:[100,8]
				Timer tTypingTimer "Typing Timer" interval:0 active:false
				
				
				-- Function
				-----------
				
				
				-- private
				function isValidText txt =
				(
					return txt != "" and not isSpace txt and txt != (_config.get #defaultText)
				)
				
				
				-- private
				function canTimerStart =
				(
					return _initSelectFieldFinished and not _dragDropTriggered and isValidText dncSelectField.text
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
				function canListenerBeCleared =
				(
					return (_config.get #clearListener) and _initSelectFieldFinished
				)
				
				
				-- private
				function logNodesWhichMatch txt =
				(
					local nodeNames = _util.getNodeNamesWithExactOrPatternMatch txt
					
					if _config.get #showNames then
						_util.logNodeNames nodeNames (_config.get #lineLimit)
					
					if _config.get #showCount then
						_util.logFoundNumNodes nodeNames.count
				)
				
				
				-- private
				function resetToSelectedDefaultText =
				(
					dncSelectField.text = _config.get #defaultText
					dncSelectField.selectAll()
				)
				
				
				-- private
				function selectAndOptionalLog txt withLog =
				(
					if withLog then
						_util.selectNodesAndLog txt
					else
						_util.selectNodes txt
				)
				
				
				-- private
				function loadConfigIfInvalid =
				(
					if not _config.isValid() then (
						_config.init()
						tTypingTimer.interval = _config.get #typingTimerInMs
					)
				)
				
				
				-- private
				function initSelectField =
				(
					local bgCol = colorMan.getColor #window * 255
					dncSelectField.BackColor = dncSelectField.BackColor.FromARGB bgCol[1] bgCol[2] bgCol[3]
					
					dncSelectField.AcceptsTab = false
					dncSelectField.AllowDrop = true
					dncSelectField.DetectUrls = false
					dncSelectField.MultiLine = false
					dncSelectField.Visible = true
					dncSelectField.RichTextShortcutsEnabled = false
					
					if _config != undefined then 
						dncSelectField.Text = _config.get #defaultText
					
					dncSelectField.Update()
					
					_initSelectFieldFinished = true
				)
				
				
				-- public
				function initConfig inConfigDir =
				(
					_config = _Configurator inConfigDir
					initSelectField()
				)
				
				
				-- private
				function initConfigAndUtil =
				(
					local Configurator = fileIn "config.ms"
					_config = Configurator()
					
					local SelectAndLogUtil = fileIn "util.ms"
					_util = SelectAndLogUtil()
				)
				
				
				-- Event
				--------
				on _roMain open do 
				(
					initSelectField()
				)
				
				
				on _roMain close do
				(
					_config.disableFileSystemWatcher()
				)
				
				
				on btConfig pressed do
				(
					_config.showConfig()
				)
				
				
				on tTypingTimer tick do
				(
					if canListenerBeCleared() then 
						clearListener()
					
					logNodesWhichMatch dncSelectField.text
					
					if _config.get #autoSelect then
						selectAndOptionalLog dncSelectField.text (_config.get #showSelectCount)
					
					stopTimer()
				)
				
				
				-- SelectField Events
				on dncSelectField DragDrop sender args do 
				( 
					local txt = args.data.GetData (_DataFormats.text)
					if isValidText txt then (
						local withLogFlag = not _config.get #silentOnDrop and _config.get #showSelectCount
						selectAndOptionalLog dncSelectField.text withLogFlag
						
						if _config.get #silentOnDrop then
							_dragDropTriggered = true
						
						-- Triggers Even TextChanged
						dncSelectField.text = txt
						
						stopTimer()
					) else
						resetToSelectedDefaultText()
				)
				
				
				on dncSelectField KeyUp sender args do
				(
					if args.KeyCode == _Keys.Enter then (
						loadConfigIfInvalid()
						
						if isValidText dncSelectField.text then (
							selectAndOptionalLog dncSelectField.text (_config.get #showSelectCount)
							dncSelectField.selectAll()
							stopTimer()
						) else
							resetToSelectedDefaultText()
					)
				)
				
				
				on dncSelectField LostFocus sender args do
				(
					if isValidText dncSelectField.text then (
						if _config.get #lostFocusSelect then
							selectAndOptionalLog dncSelectField.text (_config.get #showSelectCount)
						
						stopTimer()
					) else
						dncSelectField.text = _config.get #defaultText
				)
				
				
				on dncSelectField TextChanged sender args do 
				(
					if canTimerStart() then
						startTimer()
					else
						stopTimer()
					
					_dragDropTriggered = false
				)
				
				
				on dncSelectField GotFocus sender args do
				(
					loadConfigIfInvalid()
					
					if dncSelectField.text == _config.get #defaultText then
						dncSelectField.text = ""
					
					dncSelectField.selectAll()
				)
				
				
				on dncSelectField DragEnter sender args do
				(
					loadConfigIfInvalid()
					
					if args.Data.GetDataPresent (_DataFormats.Text) then
						args.Effect = _DragDropEffects.copy
				)
			)
		),
		
		
		public
		function setConfigDir inConfigDir =
		(
			_configDir = inConfigDir
		),
		
		
		public
		function getCurrentRolloutInstance =
		(
			_roMain
		),
		
		
		public
		function create =
		(
			/*
				Creates the dialog instance and docks it.
			 */
			
			createDialog _roMain escapeEnable:false width:120 height:34
			
			_roMain.initConfig _configDir
			
			CUI.registerDialogBar _roMain style:#(#cui_dock_horz, #cui_floatable, #cui_handles)
			CUI.dockDialogBar _roMain #cui_dock_top
		),
		
		
		public
		function destroy =
		(
			try(CUI.unRegisterDialogBar _roMain) catch()
			try(destroyDialog _roMain) catch()
		)
	)
)