/*
	XoliulShader 2 Installer
	------------------------------
	Version : 1.0
	Developed By : Robbert-Jan Brems
	Info: www.nysuatro.com
	Description: Putting fx files and startup scripts in the right folder.
	Year : 2011
	-------------------------------
*/

deletefile "$maps\\fx\\Xoliulshader_2.0.fx"
deletefile "$maps\\fx\\Xoliulshader_2.0_max2009.fx"
deletefile "$Scripts\\Startup\\XoliulShader_Startup.ms"

copyfile "$Scripts\\XoliulShaderUI\\Xoliulshader_2.0.fx" "$maps\\fx\\Xoliulshader_2.0.fx"
copyfile "$Scripts\\XoliulShaderUI\\Xoliulshader_2.0_max2009.fx" "$maps\\fx\\Xoliulshader_2.0_max2009.fx"
copyfile "$Scripts\\XoliulShaderUI\\XoliulShader_Startup.ms" "$Scripts\\Startup\\XoliulShader_Startup.ms"

if IDisplayGamma.colorCorrectionMode == #gamma or IDisplayGamma.colorCorrectionMode == #LUT then
(
	IDisplayGamma.colorCorrectionMode = #none
	messagebox "Gamma Correction was enabled, it has been disabled to improve XoliulShader II functionality."
)

try(
	if NitrousGraphicsManager.IsEnabled() then messagebox "Nitrous is Enabled! Xoliul Shader II does not work with Nitrous, please switch driver now and then reboot!"
else messagebox "Please reboot 3DS Max before trying to use the Xoliul Shader"
	
	)
catch(
	messagebox "Please reboot 3DS Max before trying to use the Xoliul Shader"
	)
	

