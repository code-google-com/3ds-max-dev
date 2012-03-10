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
			Wrapper for not polluting the global scope with the rollout definition.
			
			Local scope alone is not enough.
			The first execute of the rollout creates a global with the rollout name:
			globalVars.isGlobal #_roMain
			The second execute writes the rollout definition in the previously created global roMain.
			Overwriting whatever was stored in ::_roMain.
			
			The struct does not prevent that ::_roMain is created, 
			but it prevents it from being filled with the rollout definition
			and preserves whatever was stored in ::_roMain before.
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
				DotNetControl dntSelectField "System.Windows.Forms.RichTextBox" pos:[2,7] width:93 height:20
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
					return _initSelectFieldFinished and not _dragDropTriggered and isValidText dntSelectField.text
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
					dntSelectField.text = _config.get #defaultText
					dntSelectField.selectAll()
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
					dntSelectField.BackColor = dntSelectField.BackColor.FromARGB bgCol[1] bgCol[2] bgCol[3]
					
					dntSelectField.AcceptsTab = false
					dntSelectField.AllowDrop = true
					dntSelectField.DetectUrls = false
					dntSelectField.MultiLine = false
					dntSelectField.Visible = true
					dntSelectField.RichTextShortcutsEnabled = false
					
					if _config != undefined then 
						dntSelectField.Text = _config.get #defaultText
					
					dntSelectField.Update()
					
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
				
				
				on btConfig pressed do
				(
					_config.showConfig()
				)
				
				
				on tTypingTimer tick do
				(
					if canListenerBeCleared() then 
						clearListener()
					
					logNodesWhichMatch dntSelectField.text
					
					if _config.get #autoSelect then
						selectAndOptionalLog dntSelectField.text (_config.get #showSelectCount)
					
					stopTimer()
				)
				
				
				-- SelectField Events
				on dntSelectField DragDrop sender args do 
				( 
					loadConfigIfInvalid()
					
					local txt = args.data.GetData (_DataFormats.text)
					if isValidText txt then (
						local withLogFlag = not _config.get #silentOnDrop and _config.get #showSelectCount
						selectAndOptionalLog dntSelectField.text withLogFlag
						
						if _config.get #silentOnDrop then
							_dragDropTriggered = true
						
						-- Triggers Even TextChanged
						dntSelectField.text = txt
						
						stopTimer()
					) else
						resetToSelectedDefaultText()
				)
				
				
				on dntSelectField KeyUp sender args do
				(
					if args.KeyCode == _Keys.Enter then (
						loadConfigIfInvalid()
						
						if isValidText dntSelectField.text then (
							selectAndOptionalLog dntSelectField.text (_config.get #showSelectCount)
							dntSelectField.selectAll()
							stopTimer()
						) else
							resetToSelectedDefaultText()
					)
				)
				
				
				on dntSelectField LostFocus sender args do
				(
					loadConfigIfInvalid()
					
					if isValidText dntSelectField.text then (
						if _config.get #lostFocusSelect then
							selectAndOptionalLog dntSelectField.text (_config.get #showSelectCount)
						
						stopTimer()
					) else
						dntSelectField.text = _config.get #defaultText
				)
				
				
				on dntSelectField TextChanged sender args do 
				(
					loadConfigIfInvalid()
					
					if canTimerStart() then
						startTimer()
					else
						stopTimer()
					
					_dragDropTriggered = false
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
		),
		
		
		public
		function setConfigDir inConfigDir =
		(
			_configDir = inConfigDir
		),
		
		
		public
		function create =
		(
			/*
				Creates the Dialog and docks it.
				@note: Does a late intialization of the config to allow changing the configDir.
				
				@return: The created rollout instance
				@rtype: Rollout
			 */
			
			createDialog _roMain escapeEnable:false width:120 height:34
			
			_roMain.initConfig _configDir
			
			CUI.registerDialogBar _roMain style:#(#cui_dock_horz, #cui_floatable, #cui_handles)
			CUI.dockDialogBar _roMain #cui_dock_top
			
			_roMain
		),
		
		
		public
		function destroy =
		(
			try(CUI.unRegisterDialogBar _roMain) catch()
			try(destroyDialog _roMain) catch()
		)
	)
)