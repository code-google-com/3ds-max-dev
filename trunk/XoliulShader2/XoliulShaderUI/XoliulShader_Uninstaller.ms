/*
	XoliulShader 2 Uninstal
	------------------------------
	Version : 1.1
	Developed By : Robbert-Jan Brems
	Info:  www.nysuatro.com and http://www.laurenscorijn.com/
	Description: Uninstalling the fx and startupscripts
	Year : 2011
	-------------------------------
*/

(
	deletefile "$maps\\fx\\Xoliulshader_2.0.fx"
	deletefile "$maps\\fx\\Xoliulshader_2.0_max2009.fx"
	deletefile "$Scripts\\Startup\\XoliulShader_Startup.ms"

	m_Location = "scripts"
	m_ProjectName = "XoliulShaderUI"
	userScriptFolderPath = (pathConfig.GetDir (execute("#"+m_Location))+"\\" + m_ProjectName + "\\")
	if(DirectoryExists userScriptFolderPath)then(
		DeleteDosCommand = "RMDIR \""
		DeleteDosCommand = append DeleteDosCommand userScriptFolderPath
		DeleteDosCommand = append DeleteDosCommand "\" /S /Q"
		DOSCommand DeleteDosCommand
	)
)