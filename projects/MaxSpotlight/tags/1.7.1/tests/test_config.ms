(
	local CURRENT_SCRIPT_DIR = getFilenamePath (getSourceFileName())
	local Configurator = fileIn (CURRENT_SCRIPT_DIR + @"..\config.ms")
	
	
	local TestHelper = fileIn @"testhelper.ms"
	local testHelper = TestHelper()
	
	
	local AssertHelper
	struct AssertHelper
	(
		public
		function assertConfigPath =
		(
			local configPath = testHelper.getConfigPath()
			Assert2.assertTrue (doesFileExist configPath)
		),
		
		
		public
		function assertDefaultText configInst defaultText:"MaxSpotlight*" =
		(
			local defaultText = configInst.get #defaultText
			Assert2.equals defaultText defaultText
		),
		
		
		public
		function assertLineLimit configInst default:100 =
		(
			local lineLimit = configInst.get #lineLimit
			Assert2.equals lineLimit default
		)
	)
	
	assertHelper = AssertHelper()
	
	
	global TestConfiguratorConstructor
	struct TestConfiguratorConstructor
	(
		function tearDown =
		(
			testHelper.removeConfigIfExists()
		),
		
		
		function test_constructor_notRaises =
		(
			Assert2.notRaises Configurator args:#(CURRENT_SCRIPT_DIR)
		),
		
		
		function test_constructor_raisesInvalidDir =
		(
			local exceptionPattern = "*Exception on construction. Directory doesn't exist:*"
			Assert2.raises exceptionPattern Configurator args:#(@"c:\_invalidDir_\")
		),
		
		
		function test_constructor_INICreated =
		(
			Configurator CURRENT_SCRIPT_DIR
			assertHelper.assertConfigPath()
		)
	)
	
	
	global TestConfigurator
	struct TestConfigurator
	(
		_config,
		
		
		function setUp =
		(
			_config = Configurator CURRENT_SCRIPT_DIR
		),
		
		
		function tearDown =
		(
			testHelper.removeConfigIfExists()
		),
		
		
		function test_isValid =
		(
			Assert2.assertTrue (_config.isValid())
		),
		
		
		function test_invalidateConfig =
		(
			_config.invalidateConfig()
			Assert2.assertFalse (_config.isValid())
		),
		
		
		function test_init_validateConfig =
		(
			_config.invalidateConfig()
			_config.init()
			Assert2.assertTrue (_config.isValid())			
		),
		
		
		function test_get_string =
		(
			assertHelper.assertDefaultText _config
		),
		
		
		function test_get_bool =
		(
			local autoSelect = _config.get #autoSelect
			Assert2.assertTrue (isKindOf autoSelect BooleanClass)
		),
		
		
		function test_get_integer =
		(
			local lineLimit = _config.get #lineLimit
			Assert2.assertTrue (isKindOf lineLimit Integer)
		),
		
		
		function test_init_newSetting =
		(
			assertHelper.assertDefaultText _config
			
			local configPath = testHelper.getConfigPath()
			setINISetting configPath "Settings" "defaultText" "newDefaultText"
			
			assertHelper.assertDefaultText _config
			
			_config.init()
			
			assertHelper.assertDefaultText _config defaultText:"newDefaultText"
		),
		
		
		function test_init_invalidSetting =
		(
			assertHelper.assertLineLimit _config
			
			local configPath = testHelper.getConfigPath()
			setINISetting configPath "Settings" "lineLimit" "notANumber"
			
			assertHelper.assertLineLimit _config
			
			local val = getINISetting configPath "Settings" "lineLimit"
			Assert2.equals val "notANumber"
		)
	)
)