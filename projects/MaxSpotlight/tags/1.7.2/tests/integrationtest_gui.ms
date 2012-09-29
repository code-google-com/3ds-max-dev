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
			_gui = GUIWrapper.getInstance()
			_gui.setConfigDir configDir
		),
		
		
		function tearDown =
		(
			try(_gui.destroy()) catch()
			testHelper.removeConfigIfExists()
 		),
		
		
		function test_create_notRaises =
		(
			assert2.notRaises _gui.create
		),
		
		
		function xtest_destroy_notRaises =
		(
			_gui.create()
			assert2.notRaises _gui.destroy
 		),
		
		
		function test_create_pos =
		(
			_gui.create()
			local ro = _gui.getCurrentRolloutInstance()
			local pos = getDialogPos ro
			assert2.notEquals pos [0,0]
		),
		
		
		function test_create_configFileExists =
		(
			local configPath = testHelper.getConfigPath()
			assert2.assertFalse (doesFileExist configPath)
			_gui.create()
			assert2.assertTrue (doesFileExist configPath)
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
			_gui = GUIWrapper.getInstance()
			_gui.setConfigDir configDir
			_gui.create()
			_rollout = _gui.getCurrentRolloutInstance()
		),
		
		
		function tearDown =
		(
			try(_gui.destroy()) catch()
			testHelper.removeConfigIfExists()
 		),
		
		
		function test_GotFocus_RemoveDefault =
		(
			local dncSelectField = _rollout.dncSelectField
			assert2.notEquals dncSelectField.text ""
			
			dncSelectField.focus()
			
			assert2.equals dncSelectField.text ""
		),
		
		
		function test_GotFocus_KeepCurrent =
		(
			local dncSelectField = _rollout.dncSelectField
			dncSelectField.text = "a"
			
			dncSelectField.focus()
			
			assert2.equals dncSelectField.text "a"
		),
		
		
		function test_TextChanged_timerActive =
		(
			assert2.assertFalse (_rollout.tTypingTimer.active)
			_rollout.dncSelectField.text = "a"
			assert2.assertTrue (_rollout.tTypingTimer.active)
		),
		
		
		function test_LostFocus_Default =
		(
			_rollout.dncSelectField.focus()
			setFocus _rollout.btConfig
			assert2.notEquals _rollout.dncSelectField.text ""
		)
	)
)