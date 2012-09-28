(
	local TestHelper
	struct TestHelper
	(
		public
		function getListenerText =
		(
			setListenerSel #(0,-1)
			getListenerSelText()
		),
		
		
		public
		function getConfigDir =
		(
			return SysInfo.tempDir
		),
		
		
		public
		function getConfigPath =
		(
			local configDir = getConfigDir()
			return PathConfig.appendPath configDir @"MaxSpotlight.ini"
		),
		
		
		public
		function removeConfigIfExists =
		(
			local configPath = getConfigPath()
			if doesFileExist configPath then
				deleteFile configPath
		)
	)
)