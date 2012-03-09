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
	struct MaxSpotlightConfig
	(
		private _configPath = @"",
		private _configFilename = @"MaxSpotlight.ini",
		private _sectionName = "Settings",
		
		private _valid = true,
		
		
		private _Config = (
			struct _Config
			(
				name,
				type,
				default,
				val
			)
		),
		
		
		private _configs = #(
			_Config name:#defaultText 		type:String 		default:"MaxSpotlight*",
			_Config name:#autoSelect 		type:BooleanClass 	default:false,
			_Config name:#clearListener 	type:BooleanClass 	default:true,
			_Config name:#showNames 		type:BooleanClass 	default:true,
			_Config name:#showCount 		type:BooleanClass 	default:true,
			_Config name:#showSelectCount 	type:BooleanClass 	default:true,
			_Config name:#lostFocusSelect 	type:BooleanClass 	default:true,
			_Config name:#silentOnDrop 		type:BooleanClass 	default:true,
			_Config name:#autoMarkAll 		type:BooleanClass 	default:true,
			_Config name:#typingTimerInMs	type:Integer		default:300,
			_Config name:#limitPrintedLines	type:Integer		default:100
		),
		
		
		public
		function invalidateConfig =
		(
			_valid = false
		),
		
		
		public
		function isValid =
		(
			return _valid
		),
		
		
		private
		function getConfigPath =
		(
			local userScripts = getDir #userScripts
			return PathConfig.appendPath userScripts _configFilename
		),
		
		
		private
		function setConfigValue inKey inVal =
		(
			setINISetting _configPath _sectionName inKey (inVal as String)
			
		),
		
		
		private
		function isSet val =
		(
			return val != ""
		),
		
		
		private
		function getConfigFromINI inKey =
		(
			return getINISetting _configPath _sectionName inKey
		),
		
		
		public
		function init =
		(
			_configPath = getConfigPath()
			
			for configOn in _configs do (
				local val = getConfigFromINI configOn.name
				
				if not isSet val then (
					val = configOn.default
					setConfigValue configOn.name val
				)
				
				configOn.val = val as (configOn.type)
			)
			
			_valid = true
		),
		
		
		public
		function get configName =
		(
			local config = undefined
			for configOn in _configs while config == undefined where configOn.name == configName do config = configOn
			
			if config == undefined then
				throw "Config doesn't exist: " configName
			
			return config.val
		),
		
		
		public
		function showConfig =
		(
			edit _configPath
		),
		
		
		on create do
		(
			init()
		)
	)
)