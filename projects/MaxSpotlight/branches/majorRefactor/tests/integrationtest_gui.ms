(
	local CURRENT_SCRIPT_DIR = getFilenamePath (getSourceFileName())
	local GUIWrapper = fileIn (CURRENT_SCRIPT_DIR + @"..\gui.ms")
	
	
	global IntegrationtestGUIWrapper
	struct IntegrationtestGUIWrapper
	(
		_gui,
		
		
		function setUp = 
		(
			_gui = GUIWrapper()
			_gui.setConfigDir CURRENT_SCRIPT_DIR
		),
		
		
		function tearDown =
		(
			try(_gui.destroy()) catch()
 		),
		
		
		function test_create_notRaises =
		(
			Assert2.notRaises _gui.create
		),
		
		
		function test_destroy_notRaises =
		(
			_gui.create()
			Assert2.notRaises _gui.destroy
 		),
		
		
		function test_create_pos =
		(
			local ro = _gui.create()
			
		)
	)
)