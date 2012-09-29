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
	local Configurator
	struct Configurator
	(
		/*
			Struct for loading and storing the settings.
			
			@note: To prevent FileSystemWatcher to call its event functions,
			make sure to call dispose when you are done with the Configurator.
		 */
		
		public inConfigDir,
		
		private _configDir,		
		private _configFilename = @"MaxSpotlight.ini",
		private _configPath = @"",
		private _sectionName = "Settings",
		
		private _watcher,
		
		private _valid = true,
		
		private _Setting = (
			struct _Setting
			(
				name,
				type,
				default,
				val
			)
		),
		
		
		private _settings = #(
			_Setting name:#defaultText 		type:String 		default:"MaxSpotlight*",
			_Setting name:#autoSelect 		type:BooleanClass 	default:false,
			_Setting name:#clearListener 	type:BooleanClass 	default:true,
			_Setting name:#showNames 		type:BooleanClass 	default:true,
			_Setting name:#showCount 		type:BooleanClass 	default:true,
			_Setting name:#showSelectCount 	type:BooleanClass 	default:true,
			_Setting name:#lostFocusSelect 	type:BooleanClass 	default:false,
			_Setting name:#silentOnDrop 	type:BooleanClass 	default:true,
			_Setting name:#typingTimerInMs	type:Integer		default:300,
			_Setting name:#lineLimit		type:Integer		default:100
		),
		
		
		public
		function isValid =
		(
			return _valid
		),
		
		
		public
		function get settingName =
		(
			local setting = undefined
			for settingOn in _settings while setting == undefined where settingOn.name == settingName do setting = settingOn
			
			if setting == undefined then
				throw "Setting doesn't exist: " settingName
			
			return setting.val
		),
		
		
		public
		function showConfig =
		(
			edit _configPath
		),
		
		
		public
		function dispose =
		(
			_watcher.EnableRaisingEvents = false
			DotNet.removeAllEventHandlers _watcher
			_watcher = undefined
		),
		
		
		public
		function invalidateConfig =
		(
			_valid = false
		),
		
		
		private
		function watcher_OnChanged source args =
		(
			local this = source.Tag.value
			this.invalidateConfig()
		),
		
		
		private
		function createFileSystemWatcherWithTag =
		(
			/*
				Adds the tag object property to the FileSystemWatcher.
				Credit for goes to denisT from CGTalk.
			 */
			
			local source = "
				namespace MXS
				{
					public class FileSystemWatcher: System.IO.FileSystemWatcher 
					{ 
						public System.Object Tag; 
					}
				}
				"
			
			local csharpProvider = DotNetObject "Microsoft.CSharp.CSharpCodeProvider"
			local compilerParams = DotNetObject "System.CodeDom.Compiler.CompilerParameters"
			compilerParams.ReferencedAssemblies.Add("System.dll");
			compilerParams.GenerateInMemory = true
			
			local compilerResults = csharpProvider.CompileAssemblyFromSource compilerParams #(source)
			
			return compilerResults.CompiledAssembly.CreateInstance "MXS.FileSystemWatcher"
		),
		
		
		private
		function initFileSystemWatcher =
		(
			_watcher = createFileSystemWatcherWithTag()
			_watcher.Tag = DotNetMXSValue this
			_watcher.Path = _configDir
			_watcher.Filter = _configFilename
			
			_watcher.NotifyFilter = _watcher.NotifyFilter.LastWrite
			
			DotNet.addEventHandler _watcher "Changed" watcher_OnChanged
			DotNet.addEventHandler _watcher "Deleted" watcher_OnChanged
			DotNet.addEventHandler _watcher "Renamed" watcher_OnChanged
			
			_watcher.EnableRaisingEvents = true
		),
		
		
		private
		function castValue val config =
		(
			local castedVal
			try (castedVal = val as (config.type)) catch ()
			
			if castedVal == undefined then (
				castedVal = config.default
				
				local pattern = "<MaxSpotlight> Setting '%' with value '%' couldn't be cast to %. " +
					"Using default: %. Check your setting file.\n"
				format pattern (config.name as String) val config.type config.default
			)
			
			return castedVal
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
			for settingOn in _settings do (
				local val = getConfigFromINI settingOn.name
				
				if not isSet val then (
					val = settingOn.default
					setConfigValue settingOn.name val
				)
				
				local castedVal = castValue val settingOn				
				settingOn.val = castedVal
			)
			
			_valid = true
		),
		
		
		private
		function getConfigPath inConfigDir =
		(
			return PathConfig.appendPath inConfigDir _configFilename
		),
		
		
		on create do
		(
			if not (DotNetClass "System.IO.Directory").Exists (inConfigDir as String) then
				throw "Exception on construction. Directory doesn't exist: " inConfigDir
			
			_configDir = inConfigDir
			_configPath = getConfigPath _configDir		
			
			init()
			initFileSystemWatcher()
		)
	)
)