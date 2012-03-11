(
	local CURRENT_SCRIPT_DIR = getFilenamePath (getSourceFileName())
	local GUIWrapper = fileIn (CURRENT_SCRIPT_DIR + @"..\gui.ms")
	
	
	local TestHelper = fileIn @"testhelper.ms"
	local testHelper = TestHelper()
	
	
	global IntegrationtestGUIWrapperCreate
	struct IntegrationtestGUIWrapperCreate
	(
		_gui,
		
		
		function setUp = 
		(
			local configDir = testHelper.getConfigDir()
			_gui = GUIWrapper()
			_gui.setConfigDir configDir
		),
		
		
		function tearDown =
		(
			try(_gui.destroy()) catch()
			testHelper.removeConfigIfExists()
 		),
		
		
		function test_create_notRaises =
		(
			Assert2.notRaises _gui.create
		),
		
		
		function xtest_destroy_notRaises =
		(
			_gui.create()
			Assert2.notRaises _gui.destroy
 		),
		
		
		function test_create_pos =
		(
			local ro = _gui.create()
			local pos = getDialogPos ro
			Assert2.notEquals pos [0,0]
		),
		
		
		function test_create_configFileExists =
		(
			local configPath = testHelper.getConfigPath()
			Assert2.assertFalse (doesFileExist configPath)
			_gui.create()
			Assert2.assertTrue (doesFileExist configPath)
		)
	)
	
	
	global IntegrationtestGUIWrapperBehavior
	struct IntegrationtestGUIWrapperBehavior
	(
		_gui,
		_rollout,
		
		
		function setUp = 
		(
			local configDir = testHelper.getConfigDir()
			_gui = GUIWrapper()
			_gui.setConfigDir configDir
			_rollout = _gui.create()
		),
		
		
		function tearDown =
		(
			try(_gui.destroy()) catch()
			testHelper.removeConfigIfExists()
 		),
		
		
		function test_GotFocus_RemoveDefault =
		(
			local dncSelectField = _rollout.dncSelectField
			Assert2.notEquals dncSelectField.text ""
			
			dncSelectField.focus()
			
			Assert2.equals dncSelectField.text ""
		),
		
		
		function test_GotFocus_KeepCurrent =
		(
			local dncSelectField = _rollout.dncSelectField
			dncSelectField.text = "a"
			
			dncSelectField.focus()
			
			Assert2.equals dncSelectField.text "a"
		),
		
		
		function test_TextChanged_timerActive =
		(
			Assert2.assertFalse (_rollout.tTypingTimer.active)
			_rollout.dncSelectField.text = "a"
			Assert2.assertTrue (_rollout.tTypingTimer.active)
		),
		
		
		function test_LostFocus_Default =
		(
			_rollout.dncSelectField.focus()
			setFocus _rollout.btConfig
			Assert2.notEquals _rollout.dncSelectField.text ""
		)
	)
)