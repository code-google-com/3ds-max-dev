struct BasePreset
(
	m_ParameterCollection = undefined,
	m_FilePathFolderPresets=undefined,
	m_NamePreset = undefined
	fn SavePreset=
	(
		--We take the parameters from the shader and save it to an initfile
	),
	fn LoadPreset=
	(
		--Read the right initfile and load this data into the variables of the shader
	)
)