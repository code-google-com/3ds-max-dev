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
			rollout _roMain "v1.7.2"
			(
				/*
					The input text field for querying nodes in the current scene.
					@note:  when dialog is created,
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
				
				function _isValidText txt =
				(
					return txt != "" and not isSpace txt and txt != (_config.get #defaultText)
				)
				
				
				function _canTimerStart =
				(
					return _initSelectFieldFinished and not _dragDropTriggered and _isValidText dncSelectField.text
				)
				
				
				function _startTimer =
				(
					tTypingTimer.interval = _config.get #typingTimerInMs
					tTypingTimer.active = true
				)
				
				
				function _stopTimer =
				(
					tTypingTimer.active = false
				)
				
				
				function _canListenerBeCleared =
				(
					return (_config.get #clearListener) and _initSelectFieldFinished
				)
				
				
				function _logNodesWhichMatch txt =
				(
					local nodeNames = _util.getNodeNamesWithExactOrPatternMatch txt
					
					if _config.get #showNames then
						_util.logNodeNames nodeNames (_config.get #lineLimit)
					
					if _config.get #showCount then
						_util.logFoundNumNodes nodeNames.count
				)
				
				
				function _resetToSelectedDefaultText =
				(
					dncSelectField.text = _config.get #defaultText
					dncSelectField.selectAll()
				)
				
				
				function _selectAndOptionalLog txt withLog =
				(
					if withLog then
						_util.selectNodesAndLog txt
					else
						_util.selectNodes txt
				)
				
				
				function _loadConfigIfInvalid =
				(
					if not _config.isValid() then (
						_config.init()
						tTypingTimer.interval = _config.get #typingTimerInMs
					)
				)
				
				
				function _initSelectField =
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
				
				
				function initConfig inConfigDir =
				(
					_config = _Configurator inConfigDir
					_initSelectField()
				)
				
				
				-- Event
				--------
				on _roMain open do 
				(
					_initSelectField()
				)
				
				
				on _roMain close do
				(
					_config.dispose()
				)
				
				
				on btConfig pressed do
				(
					_config.showConfig()
				)
				
				
				on tTypingTimer tick do
				(
					if _canListenerBeCleared() then 
						clearListener()
					
					_logNodesWhichMatch dncSelectField.text
					
					if _config.get #autoSelect then
						_selectAndOptionalLog dncSelectField.text (_config.get #showSelectCount)
					
					_stopTimer()
				)
				
				
				-- SelectField Events
				on dncSelectField DragDrop sender args do 
				( 
					local txt = args.data.GetData (_DataFormats.text)
					
					if _isValidText txt then (
						local withLogFlag = not _config.get #silentOnDrop and _config.get #showSelectCount
						_selectAndOptionalLog txt withLogFlag
						
						if _config.get #silentOnDrop then
							_dragDropTriggered = true
						
						-- Triggers Event TextChanged
						dncSelectField.text = txt
						
						_stopTimer()
					) else
						_resetToSelectedDefaultText()
				)
				
				
				on dncSelectField KeyUp sender args do
				(
					if args.KeyCode == _Keys.Enter then (
						_loadConfigIfInvalid()
						
						if _isValidText dncSelectField.text then (
							_selectAndOptionalLog dncSelectField.text (_config.get #showSelectCount)
							dncSelectField.selectAll()
							_stopTimer()
						) else
							_resetToSelectedDefaultText()
					)
				)
				
				
				on dncSelectField LostFocus sender args do
				(
					if _isValidText dncSelectField.text then (
						if _config.get #lostFocusSelect then
							_selectAndOptionalLog dncSelectField.text (_config.get #showSelectCount)
						
						_stopTimer()
					) else
						dncSelectField.text = _config.get #defaultText
				)
				
				
				on dncSelectField TextChanged sender args do 
				(
					if _canTimerStart() then
						_startTimer()
					else
						_stopTimer()
					
					_dragDropTriggered = false
				)
				
				
				on dncSelectField GotFocus sender args do
				(
					_loadConfigIfInvalid()
					
					if dncSelectField.text == _config.get #defaultText then
						dncSelectField.text = ""
					
					dncSelectField.selectAll()
				)
				
				
				on dncSelectField DragEnter sender args do
				(
					_loadConfigIfInvalid()
					
					if args.Data.GetDataPresent _DataFormats.Text then
						args.Effect = _DragDropEffects.Copy
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
			return _roMain
		),
		
		
		public
		function create =
		(
			/*
				Creates the dialog instance and docks it.
			 */
			
			try(::maxSpotlight.destroy()) catch()
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
		),
		
		
		public
		function getInstance =
		(
			if ::maxSpotlight == undefined then
				GUIWrapper()
			return ::maxSpotlight
		),
		
		
		on create do
		(
			try(::maxSpotlight.destroy()) catch()
			global maxSpotlight = this
		)
	)
)