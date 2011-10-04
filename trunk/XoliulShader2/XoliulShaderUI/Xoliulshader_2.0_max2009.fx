
//3DS Max viewport shader by Laurens Corijn, http://www.laurenscorijn.com
//Big thanks to Ben Cloward for always being the guy to ask shader questions to; http://www.bencloward.com
//thanks to Jeroen Maton and Lumonix ShaderFX, http://www.jeroenmaton.net, http://www.lumonix.net
//thanks to Brice Vandemoortele for informing me about texCUBElod, made IBL easier and reflection gloss possible! http://www.mentalwarp.com
//thanks to Romain Dura aka Romz for the HSL conversion functions! http://blog.mouaif.org/?p=94
//thanks to CW for pointing out the code to get quality normals with max 2011 working.


string ParamID = "0x003"; //use DXSAS compiler

float4x4 World 					: WORLD;
float4x4 View					: VIEW;
float4x4 Projection				: PROJECTION;
float4x4 WorldInvTrans			: WorldIT;
float4x4 ViewInv				: ViewInverse;
float4 cameraPos				: WORLDCAMERAPOSITION;

//***************************************************************** DATAMEMBERS
//motherload of stuff here, most is straightforward so uncommented


struct LightStruct  //struct with lightinfo, easier to work with.
{
	float4 LightVec;
	float4 LightColor; //this value is 32 bit: it is NOT clamped by Max to 8bit per channel, so light color also includes the intensity, since they are mutliplied before Max hads them over
};

float4x4 WorldViewProj;					
LightStruct lightsarray[3]; //3-light array


// these elements are required for projected shadows 
//SHADOWCODE
#include <shadowMap.fxh> 

float  ShadowFloats[3];
float  ShadowStrengths[3];

float Gamma
<
	string UIName = "Gamma Correction";
	string UIWidget = "FloatSpinner";
	float UIMin = 0.0f;
	float UIMax = 10.0f;
	float UIStep = 0.1f;
> = {2.2f};


//===========LIGHTS

int numberOfActiveLights
<
string UIName = "Active Lights";
string UIType = "FloatSpinner";
float UIMin = 0.0f;
float UIMax = 3.0f;
float UIStep = 1.0;
> = 1;

float4 light1_Position : POSITION
<
	string UIName = "  Light 1 Position";
	string Object = "PointLight";
	string Space = "World";
	int refID = 1; 								//refID for automatic lightcolor input
>;// = {100.0f, 100.0f, 100.0f, 0.0f};

//lightcolor = lightrgb x lightmultiplier, done by Max
float4 light1Color : LIGHTCOLOR <int LightRef = 1; string UIWidget = "None"; > = { 1.0f, 1.0f, 1.0f, 1.0f}; 	//lightref ID makes sure that max fills in this value automatically



//SHADOWCODE

//bullcrap maxversion isnt defined...
/*
#ifndef _3DSMAX_VERSION
	sampler2D g_ShadowSampler;
	#define SHADOW_FUNCTOR(name)	\
		float name(float4 wpos) { return tex2Dproj(g_ShadowSampler,wpos).x; }
#elif _3DSMAX_VERSION < 10000
	#define SHADOW_FUNCTOR(name)	\
		float name(float4 pos) { return 1;}
#elif _3DSMAX_VERSION <= 11000
	#define SOFT_SHADOW_FUNCTOR(name)	\
			float name(float4 pos, int lighttype, bool linearsupport) { return 1;}
#endif
*/

SHADOW_FUNCTOR(HardshadowTerm); //Only 1 shadow supported, more is just not necessary and not worth the effort and trouble. the shader would also become too slow and messy because of it
/*
//SOFTSHADOW
SOFT_SHADOW_FUNCTOR(SoftshadowTerm, OMNI_LGT, true); // NOTE: '000' or OMNI_LGT represents omni light, '001' or SPOT_LGT is spot, and '002' or DIR_LGT is direct.
//AREASHADOW
AREA_SHADOW_FUNCTOR(AreashadowTerm, OMNI_LGT, true); // NOTE: '000' or OMNI_LGT represents omni light, '001' or SPOT_LGT is spot, and '002' or DIR_LGT is direct.
*/

bool bUseShadow
<
    string gui = "slider";
    string UIName = "     Use Shadow for Light1";
> = false;

uint Shadow1Type
<
	string UIName = "     Shadow type (0:hard,1:soft,2:area)";
	string UIWidget = "FloatSpinner";
	float UIMin = 0;
	float UIMax = 0;
> = {0};

float Shadow1Strength
<
	string UIName = "     Shadow Intensity";
	string UIWidget = "FloatSpinner";
	float UIMin = 0.0f;
	float UIMax = 1.0f;
> = {1.0f};



float4 light2_Position : POSITION
<
	string UIName = "  Light 2 Position";
	string Object = "PointLight";
	string Space = "World";
	int refID = 2;
>;// = {100.0f, 100.0f, 100.0f, 1.0f};

float4 light2Color : LIGHTCOLOR <int LightRef = 2; string UIWidget = "None"; > = { 1.0f, 1.0f, 1.0f, 1.0f}; 

float4 light3_Position : POSITION
<
	string UIName = "  Light 3 Position";
	string Object = "PointLight";
	string Space = "World";
	int refID = 3;
>;// = {100.0f, 100.0f, 100.0f, 1.0f};

float4 light3Color : LIGHTCOLOR <int LightRef = 3; string UIWidget = "None"; > = { 1.0f, 1.0f, 1.0f, 1.0f}; 

float HueAdjust
<
	string UIName = "Shaded Hue Adjustment";
	string UIWidget = "FloatSpinner";
	float UIMin = 0.0f;
	float UIMax = 2.0f;
	float UIStep = 0.1f;
> = {0.3f};


bool bUseHalfLambert
<
    string gui = "slider";
    string UIName = "     Half Lambert Shading";
> = false;

float HalfLambertPower
<
string UIName = "         Half Lambert Power";
string UIType = "FloatSpinner";
float UIMin = 0.0f;
float UIMax = 10.0f;
float UIStep = 0.1;
> = 2;

float3 ambientcolor
<
	string UIName = "     Ambient Color";
	string UIWidget = "Color";
> = {0.0f, 0.0f, 0.0f};



texture Envcubemap
<
	string ResourceName = "";
	string UIName = "Enviro Cubemap";
	string ResourceType = "Cube";
>;

samplerCUBE EnvcubemapSampler = sampler_state
{
	Texture = <Envcubemap>;
	MinFilter=LINEAR;
	MagFilter=LINEAR;
	MipFilter=LINEAR;
	MipLODBias=0;
	AddressU = WRAP;
	AddressV = WRAP;
};

bool UseIBLambient
<
	string gui = "slider";
    string UIName = "     Use Env Cube for ambient";
> = false;

float IBLBlur
<
string UIName = "         Ambient Cube Blur";
string UIType = "FloatSpinner";
float UIMin = 0.0f;
float UIMax = 10.0f;
float UIStep = 0.1f;
> = 7.6f;

float IBLmultiplier
<
string UIName = "         Ambient Cube Strength";
string UIType = "FloatSpinner";
float UIMin = 0.0f;
float UIMax = 10.0f;
float UIStep = 0.05;
> = 0.5;

float CubeMapGamma
<
string UIName = "         Ambient Cube Gamma";
string UIType = "FloatSpinner";
float UIMin = 0.1f;
float UIMax = 10.0f;
float UIStep = 0.01;
> = 1.0f;

bool UseGradientRamp
<
	string gui = "slider";
    string UIName = "Use Ramped Shading";
> = false;

texture gradientMap
<
	string name ="";
	string UIName = "     Gradient Ramp";	
>;

sampler2D gradientSampler = sampler_state
{
	Texture = <gradientMap>;
	MinFilter=LINEAR;
	MagFilter=LINEAR;
	MipFilter=LINEAR;
	MipLODBias=-1;
	AddressU = CLAMP;
	AddressV = CLAMP;
};

//==========LightMAP

//DEPRECATED

//==========DIFFUSEMAP

bool bUseDiffuseMap
<
    string gui = "slider";
    string UIName = "Diffuse Map";
> = false;

half4 diffuseColor : DIFFUSECOLOR
<
	string UIWidget = "Color";
    string UIName = "     Diffuse Color";
> = {0.5f, 0.5f, 0.5f, 1.0f};

texture diffuseMap : DIFFUSEMAP
<
	string name ="";
	string UIName = "     Diffuse Map";	
>;

int DiffuseMapUV
<
string UIName = "         Diffusemap UV Channel";
string UIType = "FloatSpinner";
float UIMin = 1;
float UIMax = 4;
float UIStep = 1;
> = 1;

float VertexDiffuse
<
	string UIWidget = "Spinner";
	float UIMin = 0.0;
	float UIMax = 2.0;
	float UIStep = 0.1;
	string UIName = "     Vertex Color Strength";
> = 0.0;


bool bColorDiffuse
<
    string gui = "slider";
    string UIName = "     Color Diffuse Map";
> = false;


sampler2D diffuseSampler = sampler_state
{
	Texture = <diffuseMap>;
	MinFilter=LINEAR;
	MagFilter=LINEAR;
	MipFilter=LINEAR;
	MipLODBias=-1;
	AddressU = WRAP;
	AddressV = WRAP;
};

half4 diffusefresnelColor : DIFFUSECOLOR
<
	string UIWidget = "Color";
    string UIName = "     Diffuse Fresnel Color";
> = {0.2f, 0.2f, 0.2f, 1.0f};

float diffuseFresnelPower
<
	string UIWidget = "Spinner";
	float UIMin = 0.0;
	float UIMax = 100.0;
	float UIStep = 0.1;
	string UIName = "     Fresnel Power";
> = 3.0;

float diffuseFresnelMult
<
	string UIWidget = "Spinner";
	float UIMin = 0.0;
	float UIMax = 100.0;
	float UIStep = 0.1;
	string UIName = "     Fresnel Multiplier";
> = 0.0;

//==========OPACITYMAP

bool bUseAlpha
<
    string gui = "slider";
    string UIName = "     Enable alpha channel";
> = false;

bool bClip
<
    string gui = "slider";
    string UIName = "     Clip (improve hard sorting)";
> = false;

float ClipTreshold
<
string UIName = "         Clipping treshold";
string UIType = "FloatSpinner";
float UIMin = 0.0f;
float UIMax = 1.0f;
float UIStep = 0.01;
> = 0.3;

float GlobalOpacity
<
string UIName = "         Global Opacity Level";
string UIType = "FloatSpinner";
float UIMin = 0.0f;
float UIMax = 1.0f;
float UIStep = 0.05;
> = 1;


//==========SPECULARMAP

bool bUseSpecMap
<
    string gui = "slider";
    string UIName = "Spec Map";
> = false;

half4 specularColor : SPECULARCOLOR
<
	string UIWidget = "Color";
    string UIName = "     Specular Color";
> = {1.0f, 1.0f, 1.0f, 1.0f};

float speclevel
<
string UIName = "     Specular Global Level";
string UIType = "FloatSpinner";
float UIMin = 0.0f;
float UIMax = 10.0f;
float UIStep = 0.05;
> = 1.0f;

texture specularMap : SPECULARMAP
<
	string name ="";
	string UIName = "     Specular Map";
	string ResourceType = "2D";

>;

sampler2D specularSampler = sampler_state
{
	Texture = <specularMap>;
	MinFilter=LINEAR;
	MagFilter=LINEAR;
	MipFilter=LINEAR;
	MipLODBias=-1;
	AddressU = WRAP;
	AddressV = WRAP;
};

//==========GLOSSMAP

bool bUseGlossMap
<
    string gui = "slider";
    string UIName = "Gloss Map";
> = false;

texture glossMap : GLOSSINESS
<
	string name ="";
	string UIName = "     Gloss Map";
	string ResourceType = "2D";

>;

sampler2D glossinessSampler = sampler_state
{
	Texture = <glossMap>;
	MinFilter=LINEAR;
	MagFilter=LINEAR;
	MipFilter=LINEAR;
	MipLODBias=-1;
	AddressU = WRAP;
	AddressV = WRAP;
};

float glossiness
<
	string UIName = "     Glossiness Level";
	string UIType = "FloatSpinner";
	float UIMin = 0.0f;
	float UIMax = 100.0f;
	float UIStep = 0.05;
> = 25.0f;

float glossoffset
<
	string UIName = "     Glossmap Offset";
	string UIType = "FloatSpinner";
	float UIMin = 0.0f;
	float UIMax = 100.0f;
	float UIStep = 0.05;
> = 10.0f;
 
//==========NORMALMAP
 
bool bUseNormalMap
<
    string gui = "slider";
    string UIName = "Normal Map";
> = false;

bool bUseObjectNormals
<
    string gui = "slider";
    string UIName = "     Object Space";
> = false;


texture normalMap : NORMALMAP
<
	string name ="";
	string UIName = "     Normal Map";
	string ResourceType = "2D";
>;

int NormalMapUV
<
string UIName = "         Normalmap UV Channel";
string UIType = "FloatSpinner";
float UIMin = 1;
float UIMax = 4;
float UIStep = 1;
> = 1;

bool bFlipGreenChannel
<
    string gui = "slider";
    string UIName = "     Flip Green";
> = true;
/*
bool bFlipRG
<
    string gui = "slider";
    string UIName = "     Switch RG Channels ";
> = false;
*/
sampler2D normalSampler = sampler_state
{
	Texture = <normalMap>;
	MinFilter=LINEAR;
	MagFilter=LINEAR;
	MipFilter=LINEAR;
	MipLODBias=-1;
	AddressU = WRAP;
	AddressV = WRAP;
};

//==========GLOWMAP

bool bUseSIMap
<
    string gui = "slider";
    string UIName = "Self Illumination Map";
> = false;

texture siMap : SIMAP
<
	string name ="";
	string UIName = "     SI Map";
	string ResourceType = "2D";

>;

sampler2D siMapSampler = sampler_state
{
	Texture = <siMap>;
	MinFilter=LINEAR;
	MagFilter=LINEAR;
	MipFilter=LINEAR;
	MipLODBias=-1;
	AddressU = WRAP;
	AddressV = WRAP;
};

float siMapMult<
	string UIName = "     SI Map Multiply";
	string UIType = "FloatSpinner";
	float UIMin = 0.0f;
	float UIMax = 10.0f;
> = 1.0f;



//==========Reflections

bool bUseFresnel
<
    string gui = "slider";
    string UIName = "Use Fresnel Reflections";
> = false;

bool bAlphaMasksFresnel
<
    string gui = "slider";
    string UIName = "     Opacity Affects Reflections";
> = false;

float FresnelPower
<
	string UIWidget = "Spinner";
	float UIMin = 0.0;
	float UIMax = 100.0;
	float UIStep = 0.1;
	string UIName = "     Fresnel Power";
> = 3.0;
 
 
float FresnelBias
<
	string UIWidget = "Spinner";
	float UIMin = 0.0;
	float UIMax = 1.0;
	float UIStep = 0.01;
	string UIName = "     Fresnel Bias";
> = 0.0;

float FresnelMult
<
	string UIWidget = "Spinner";
	float UIMin = 0.0;
	float UIMax = 100.0;
	float UIStep = 0.1;
	string UIName = "     Fresnel Multiplier";
> = 2.0;

float3 FresnelColor 
<
	string UIWidget = "Color";
    string UIName = "     Rim Color";
> = {1.0f, 1.0f, 1.0f};

float FresnelMaskHardness
<
	string UIWidget = "Spinner";
	float UIMin = 0.0;
	float UIMax = 100.0;
	float UIStep = 0.1;
	string UIName = "     Fresnel Mask Hardness";
> = 4.0;

bool bUseWorldMask
<
    string gui = "slider";
    string UIName = "     Use Hard-Type World Masking";
> = true;

bool bUseReflMap
<
    string gui = "slider";
    string UIName = "     Reflection Map";
> = false;

texture ReflMap 
<
	string name ="";
	string UIName = "     Reflect Map";

>;

sampler2D ReflMapSampler = sampler_state
{
	Texture = <ReflMap>;
	MinFilter=LINEAR;
	MagFilter=LINEAR;
	MipFilter=LINEAR;
	MipLODBias=-1;
	AddressU = WRAP;
	AddressV = WRAP;
};

bool bUseCubeMap
<
    string gui = "slider";
    string UIName = "     Reflect Environment Cubemap";
> = false;

float CubeMapBlur
<
	string UIWidget = "Spinner";
	float UIMin = 0.0;
	float UIMax = 10.0;
	float UIStep = 0.1;
	string UIName = "     Reflected Cubemap Blur";
> = 0.0;
bool bUseReflGloss
<
    string gui = "slider";
    string UIName = "         Use Glossmap for blur";
> = false;

float EnvRotation
<
	string UIWidget = "Spinner";
	float UIMin = -180.0;
	float UIMax = 180.0;
	float UIStep = 1.0;
	string UIName = "     Environment Z-rotation";
> = 0.0;

//----------------------------------MAXSCRIPT UI VARS
//This value only serves for UI value indexing, as the only surefire way to save shader-related data, is AS A SHADER VARIABLE.


bool UseLight1
<
	string UIWidget = "slider";
> = true;

bool UseLight2
<
	string UIWidget = "slider";
> = false;

bool UseLight3
<
	string UIWidget = "slider";
> = false;


bool UseShadow1
<
	string UIWidget = "slider";
> = false;

bool UseShadow2
<
	string UIWidget = "slider";
> = false;

bool UseShadow3
<
	string UIWidget = "slider";
> = false;


//----------------------------------TEXCOORD MAGIC
//this is silly random crap to get 3DS Max to intialize the texcoords. If you don't do this, it'll only init one UV set. With this in mind, the below code is pretty straightforward.
//Note that these vars are not used in the shader directly, they're just there to force app input into the app input struct.

int texcoord0 : Texcoord
<
	string UIWidget = "none";
	int Texcoord = 0;
	int MapChannel = 1;
>;

int texcoord1 : Texcoord
<
	string UIWidget = "none";
	int Texcoord = 1;
	int MapChannel = 2;
>;

int texcoord2 : Texcoord
<
	string UIWidget = "none";
	int Texcoord = 2;
	int MapChannel = 3;
>;

int texcoord3 : Texcoord
<
	string UIWidget = "none";
	int Texcoord = 3;
	int MapChannel = 4;
>;

int texcoord4 : Texcoord
<
	string UIWidget = "none";
	int Texcoord = 4;
	int MapChannel = 0;
>;

int texcoord5 : Texcoord
<
	string UIWidget = "none";
	int Texcoord = 5;
	int MapChannel = 0;
>;




//----------------------------------VS & PS structs 


// input from application for Vertex Shader
struct VS_InputStruct {
	half4 position		: POSITION;
	half2 texCoord		: TEXCOORD0;
	half2 texCoord2		: TEXCOORD1;
	half2 texCoord3		: TEXCOORD2;
	half2 texCoord4		: TEXCOORD3;
	float3 vertcol		: TEXCOORD4; 
	float vertalpha 	: TEXCOORD5;
	half3 tangent		: TANGENT;
	half3 binormal		: BINORMAL;
	half3 normal		: NORMAL;
};

// Vertex Shader output for Pixel Shader
struct VS_To_PS_Struct {
        half4 position   	: POSITION;
		float4 texCoord    	: TEXCOORD0;
		float4 texCoord2	: TEXCOORD1;
		half3 eyeVec		: TEXCOORD2;
		half3 worldNormal	: TEXCOORD3;
		half3 worldTangent	: TEXCOORD4;
		half3 worldBinormal	: TEXCOORD5;
		half4 worldSpacePos	: TEXCOORD6;


		
		float4 color    		: COLOR0;
		
		
};


//==============Custom Functions

void SetupMatrices()
{
	WorldViewProj = mul(mul(World, View), Projection); //just create WVP by multipying
}

//standard diffuse lighting by dot product
float diffuselight( float3 normal, float3 lightvec)
	{
		normal = normalize(normal);
		lightvec = normalize(lightvec);
		
		return saturate(dot(normal,lightvec)); //dot product between surface and light returns how lit the pixel is. clamp between 0 and 1 because intensity is multiplied later
	}

//Half Lambert lighting, function by Valve Software.
//see http://www.valvesoftware.com/publications/2007/NPAR07_IllustrativeRenderingInTeamFortress2.pdf for more info
float halflambert(float3 normal, float3 lightvec) 
{
	normal = normalize(normal);
	lightvec = normalize(lightvec);
	
	float NdotL = dot(lightvec,normal);		//dot product for base diffuse light
	float HalfLamb = (NdotL * 0.5f)+0.5f;	//magic formula!
	HalfLamb = pow(HalfLamb,HalfLambertPower);		//power halflambert 

	return  saturate(HalfLamb); 
}

float halflambert(float value) 
{
	
	float HalfLamb = (value * 0.5f)+0.5f;	//magic formula!
	HalfLamb = pow(HalfLamb,HalfLambertPower);		//power halflambert 

	return  saturate(HalfLamb); 
}

//seperate specular calculation to make my life easier coding this thing
//color and masking is NOT done here; this is just for pure, raw specular calculation
//thanks to http://wiki.gamedev.net/index.php/D3DBook:(Lighting)_Blinn-Phong for the very clean and understandable explanation
float4 blinnspecular(float3 normal, float3 lightvec, float3 eyevec, float4 glossiness)
{
	normal = normalize(normal);
	lightvec = normalize(lightvec);
	eyevec = normalize(eyevec);
	
	float3 halfvector = normalize(eyevec+lightvec); //add eye and light together for half vector (Blinn)
	
	float4 specular;
	specular = dot(halfvector, normal); //dot between half and normal (Blinn)
	specular = float4( pow(specular.r, glossiness.r),pow(specular.g, glossiness.g), pow(specular.b, glossiness.b), pow(specular.a, glossiness.a)); //power specular to glossiness to sharpen highlight
	specular *= saturate(dot(normal,lightvec) * 4); //fix for Specular through surface bug. what this does is just make sure no specular happens on unlit parts. the multiplier works as a bias
	
	return specular;
	
}

//Fresnel falloff function for all round application
float fresnel(float3 normal, float3 eyevec, float power, float bias)
{
	normal = normalize(normal);
	eyevec = normalize(eyevec);
	
	float fresnel = saturate(abs(dot(normal,eyevec))); //get fallof by dot product between normal and eye, absolute to prevent falloff to go negative on backside of object 
	fresnel = 1-fresnel; //invert falloff to get white instead of black on edges
	fresnel = pow(fresnel, power); //power falloff to sharpen effect
	fresnel+=bias; // add bias to falloff, this is mostly for cubemap reflections like in carpaint
	
	return saturate(fresnel);
}

//desaturate/luminance value function
float desaturate(float3 color)
{
	float luminance;
	luminance = dot(color,float3(0.299,0.587,0.114)); //desaturate by dot multiplying with luminance weights.
	return luminance;
}

//Fill light array function
void CreateLights( float4 worldspacepos )
{
	
		lightsarray[0].LightVec = light1_Position - worldspacepos; // transform light position to world space position, put into array
		lightsarray[0].LightColor = light1Color; // set light color to array. light color is automatically updated by Max because we use RefId's.
		
		lightsarray[1].LightVec = light2_Position - worldspacepos;
		lightsarray[1].LightColor = light2Color;
		
		lightsarray[2].LightVec = light3_Position - worldspacepos;
		lightsarray[2].LightColor = light3Color;
	
}

float3 RGBToHSL(float3 color) //Romain's conversion function
{
	float3 hsl; // init to 0 to avoid warnings ? (and reverse if + remove first part)
	
	float fmin = min(min(color.r, color.g), color.b);    //Min. value of RGB
	float fmax = max(max(color.r, color.g), color.b);    //Max. value of RGB
	float delta = fmax - fmin;             //Delta RGB value

	hsl.z = (fmax + fmin) / 2.0; // Luminance

	if (delta == 0.0)		//This is a gray, no chroma...
	{
		hsl.x = 0.0;	// Hue
		hsl.y = 0.0;	// Saturation
	}
	else                                    //Chromatic data...
	{
		if (hsl.z < 0.5)
			hsl.y = delta / (fmax + fmin); // Saturation
		else
			hsl.y = delta / (2.0 - fmax - fmin); // Saturation
		
		float deltaR = (((fmax - color.r) / 6.0) + (delta / 2.0)) / delta;
		float deltaG = (((fmax - color.g) / 6.0) + (delta / 2.0)) / delta;
		float deltaB = (((fmax - color.b) / 6.0) + (delta / 2.0)) / delta;

		if (color.r == fmax )
			hsl.x = deltaB - deltaG; // Hue
		else if (color.g == fmax)
			hsl.x = (1.0 / 3.0) + deltaR - deltaB; // Hue
		else if (color.b == fmax)
			hsl.x = (2.0 / 3.0) + deltaG - deltaR; // Hue

		if (hsl.x < 0.0)
			hsl.x += 1.0; // Hue
		else if (hsl.x > 1.0)
			hsl.x -= 1.0; // Hue
	}

	return hsl;
}

float HueToRGB(float f1, float f2, float hue)
{
	if (hue < 0.0)
		hue += 1.0;
	else if (hue > 1.0)
		hue -= 1.0;
	float res;
	if ((6.0 * hue) < 1.0)
		res = f1 + (f2 - f1) * 6.0 * hue;
	else if ((2.0 * hue) < 1.0)
		res = f2;
	else if ((3.0 * hue) < 2.0)
		res = f1 + (f2 - f1) * ((2.0 / 3.0) - hue) * 6.0;
	else
		res = f1;
	return res;
}


float3 HSLToRGB(float3 hsl)
{
	float3 rgb;
	
	if (hsl.y == 0.0)
		rgb = float3(hsl.z, hsl.z, hsl.z); // Luminance
	else
	{
		float f2;
		
		if (hsl.z < 0.5)
			f2 = hsl.z * (1.0 + hsl.y);
		else
			f2 = (hsl.z + hsl.y) - (hsl.y * hsl.z);
			
		float f1 = 2.0 * hsl.z - f2;
		
		rgb.r = HueToRGB(f1, f2, hsl.x + (1.0/3.0));
		rgb.g = HueToRGB(f1, f2, hsl.x);
		rgb.b= HueToRGB(f1, f2, hsl.x - (1.0/3.0));
	}
	
	return rgb;
}

float3 NormalApplication(float3 normal, VS_To_PS_Struct In)
{
	float3 fixednormal = normal;
//normal application
	if(!bUseObjectNormals && bUseNormalMap) //tangentspace normalmap
	{
        const float3x3 basis = float3x3( normalize( In.worldTangent ), normalize( In.worldBinormal ), normalize( In.worldNormal ) );
        fixednormal = normalize( mul( normal, basis ) ); //big thanks to CW for showing me the working code for this.
	}
	if(bUseObjectNormals && bUseNormalMap) //if object space, pure sampling equals the normal
	{
		fixednormal = mul(normal, WorldInvTrans).xyz; // put objectspace normal in worldspace
	}

	return	normalize( fixednormal ) ;
}

//SHADOWCODE
//shadow blur lookup function
//special multisample function made by Laurens
//HEAVY ON PERFORMANCE due to crappy 3DS max shadow API
float ShadowLookUp(float4 position, int type)
{
	
			return HardshadowTerm(position); 


}




//Vertex And Pixel Shaders

//VERTEX SHADER
VS_To_PS_Struct vs_main(VS_InputStruct In) //vertexshader gets input struct from application, all automatically
{
	SetupMatrices(); //create WVP
	
	VS_To_PS_Struct Out; //define output struct
	
    Out.worldNormal = mul(In.normal, (float3x3)World).xyz; //transform normal to worldspace
	Out.worldTangent = mul(In.tangent, (float3x3)World).xyz; //transform tangent to worldspace
	Out.worldBinormal = mul(In.binormal, (float3x3)World).xyz; //transform binormal to worldspace
    
	Out.worldSpacePos = mul(In.position, World);	 //transform position to worldspace
  
	Out.texCoord.xy = In.texCoord; //pass texcoord to output
	Out.texCoord.zw = In.texCoord2;//pass texcoord2 to output
	Out.texCoord2.xy = In.texCoord3; //pass texcoord3 to output
	Out.texCoord2.zw = In.texCoord4; //pass texcoord4 to output
    Out.eyeVec = ViewInv[3].xyz -  Out.worldSpacePos; //calculate eyevector
    Out.position = mul(In.position, WorldViewProj); //special worldspacepos in texcoord slot for shadow code, will error otherwise
	
	Out.color = float4(In.vertcol.rgb, In.vertalpha.r);  //set vertexcolors for PS

    return Out;
}

//PIXEL SHADER
float4 ps_main(VS_To_PS_Struct In) : COLOR 
{ 
	//Map Checks
	//these just check if a map is used to overwrite the default value.
	

	
	//diffuse
	half2 diffUV = In.texCoord.xy;//this stuff unpacks "packed" Uv coordinates, I throw them together in pairs of 2. read vertex shader to understand better.
	if(DiffuseMapUV == 2)	diffUV=In.texCoord.zw;
	else if(DiffuseMapUV == 3) diffUV=In.texCoord2.xy;
	else if(DiffuseMapUV == 4) diffUV=In.texCoord2.zw;
	
	float4 color = float4(diffuseColor); //default diffusecolor
	if(bUseDiffuseMap)
	{
		color = tex2D(diffuseSampler, diffUV);
		
		float4 resprayalpha = lerp(color,color*diffuseColor, color.a); //same thing as down here, but blend between resprayed and untouched based on alpha
		float4 respray = color*diffuseColor; //multiply diffuse texturesample with color, useful for recoloring grayscale diffusemaps
		
		if(bColorDiffuse) color = bUseAlpha ? respray : resprayalpha;  //don't do alpha masked respray if alpha is meant for transparency instead
	} 
	color = lerp(color, color*In.color, VertexDiffuse);
	

	
	//opacity
	float opacity = GlobalOpacity; //default is global opacity
	if(bUseAlpha)
	{
		opacity = color.a; //sampled alpha from diffuse map
		if (bClip) clip(opacity < ClipTreshold ? -1:1);
	}
	
	
	//specular
	float4 speccolor = specularColor; //default is solid specular color
	if(bUseSpecMap)
	{
		speccolor = tex2D(specularSampler, diffUV);
	}
	speccolor = float4(pow(speccolor.x,Gamma),pow(speccolor.y,Gamma),pow(speccolor.z,Gamma),speccolor.a); //gamma correction for spec
	
	
	//glossiness
	float4 glossiness3 = float4(glossiness,glossiness,glossiness,glossiness);
	float4 glossoffset3 = float4(glossoffset,glossoffset,glossoffset,glossoffset);
	float4 gloss = glossiness;
	if(bUseGlossMap)
	{
		float4 glosstexRGB = tex2D(glossinessSampler, diffUV);
		float3 glosstexHSL = RGBToHSL(glosstexRGB.rgb);
		glosstexHSL.r -= 0.5f;
		glosstexRGB.rgb = HSLToRGB(glosstexHSL);
		gloss = glosstexRGB * (glossiness3 - glossoffset3); //overwrite glossiness global with texsample, multiplied with level
		gloss += glossoffset3; //offset gloss to prevent zero glossiness, allows for better control over glossiness map range
	}

	
	//normal
	
	half2 normalUV = In.texCoord.xy;
	if(NormalMapUV == 2)	normalUV=In.texCoord.zw;
	else if(NormalMapUV == 3) normalUV=In.texCoord2.xy;
	else if(NormalMapUV == 4) normalUV=In.texCoord2.zw;
	
	float3 normal = In.worldNormal; //default worldspace vertex normal
	if(bUseNormalMap)
	{
		normal = tex2D(normalSampler, normalUV).rgb;
		normal = (2*normal)-1; //expand into -1 to 1 range, since a normalmap is always returned in 0 to 1 space
		normal = normal.yxz;
		if (bFlipGreenChannel) normal.g =-normal.g; //flip green for texture instead of flipping tangent, works for object space normals also
		/*
		if (bFlipRG) 
		{
			float temp = normal.r;
			normal.r = normal.g;
			normal.g = temp;
		}*/
	}
	
	
	
	//rotated reflection vector
	
	float3 rotatednormal=float3(0,0,0);
	float3 rotangle=radians(EnvRotation);
	rotatednormal.x= (cos(rotangle) * normal.x) - (sin(rotangle)*normal.y);
	rotatednormal.y= (sin(rotangle) * normal.x) + (cos(rotangle)*normal.y);
	rotatednormal.z= normal.z;
	rotatednormal = NormalApplication(rotatednormal, In);
	
	
	
	//self illumination
	float4 selfillumination = (0.0f,0.0f,0.0f,0.0f); //default no self illum
	if(bUseSIMap)
	{
		selfillumination = tex2D(siMapSampler, diffUV);
	}
	selfillumination = float4(pow(selfillumination.x,Gamma),pow(selfillumination.y,Gamma),pow(selfillumination.z,Gamma),selfillumination.a);
	
	
	
	//Create Light Calculations
	CreateLights( In.worldSpacePos ); // fill lightstruct array DOES NOT WORK IN VERTEX SHADER, MUST HAPPEN IN PIXEL SHADER! ~0_o>
	
	normal = NormalApplication(normal, In);
	
	
	
	//Diffuse Fresnel
	
	float diffusefresnel = saturate(diffuseFresnelMult*fresnel(normal, In.eyeVec, diffuseFresnelPower, 0));
	color = lerp(color, diffusefresnelColor, diffusefresnel);
	
	//SHADOWCODE
	//Shadow calculations
	ShadowFloats[0]=ShadowStrengths[0]=ShadowFloats[1]=ShadowStrengths[1]=ShadowFloats[2]=ShadowStrengths[2]=1.0f; //set all shadow values to 1, fully lit no shadow as default
	
	if(bUseShadow) //if shadow 1 is on, only shadow 1 will be filled, the rest just stay at one
	{
		ShadowFloats[0] = ShadowLookUp(float4(In.worldSpacePos.xyz,1),Shadow1Type); // lookup shadows with special function
			
		ShadowStrengths[0] = ShadowFloats[0] + ((1-Shadow1Strength) * (1-ShadowFloats[0])); //calculate final shadow strength based on user settings
	}
	
	
	//Ambient setup, solid or cubemap sample
	float4 ambient;
		float4 ambientcubesample = (0,0,0,0);
		if( UseIBLambient )
		{
			ambientcubesample = texCUBElod(EnvcubemapSampler, float4(rotatednormal.x,rotatednormal.z,rotatednormal.y,IBLBlur));
			ambientcubesample = float4(pow(ambientcubesample.x,CubeMapGamma),pow(ambientcubesample.y,CubeMapGamma),pow(ambientcubesample.z,CubeMapGamma),ambientcubesample.a);
		}
			ambient = float4(ambientcolor,1.0f)+(ambientcubesample * IBLmultiplier);

		
	//SHADOWCODE
	//IBL Shadow hack
		if(IBLmultiplier!=0.0f && numberOfActiveLights == 0 && bUseShadow)
		{
			float4 ambientbase;
			ambientbase = texCUBElod(EnvcubemapSampler, float4(0,0,-1,IBLBlur)) * IBLmultiplier;
			ambientbase = float4(pow(ambientbase.x,CubeMapGamma),pow(ambientbase.y,CubeMapGamma),pow(ambientbase.z,CubeMapGamma),ambientbase.a);
			ambient = lerp(ambientbase,ambient,ShadowStrengths[0]);
		}
	
	float4 totaldiffuse =  ambient; //start off with ambient color
	float4 totaldiffuseRamped = ambient;
	float4 totalspecular = (0.0f,0.0f,0.0f,0.0f); //if the alpha value is not zero, messed up specular happens
	
	//Light Loop
	for(int i = 0; i < numberOfActiveLights; ++i) //for loop to iterate over our 3 lights
	{
		//diffuse term
		float diffuse;
		if(bUseHalfLambert) 
		{
			diffuse = halflambert(normal,lightsarray[i].LightVec);
			diffuse *= saturate(ShadowStrengths[i]+(1-(diffuselight(normal,lightsarray[i].LightVec)))); // apply shadow into diffuse, this is done for each light to prevent performance slowdown with IF statements due to varying instructioncount
			//this formula attempts to fix shadow bias issues with Half Lambert. the formula isn't perfect but it's better with than without...
		}
		else //regular blinn/phong diffuse
		{
			diffuse = diffuselight(normal,lightsarray[i].LightVec);
			diffuse *= ShadowStrengths[i]; // apply shadow into diffuse
		}
		
		int grad = UseGradientRamp ? 1 : 0;  //lilttle hack to circumvent the 16 boolea branch limit
		

		totaldiffuse += (diffuse*lightsarray[i].LightColor); //add every light to the total diffuse sum (lights are additive towards each other), multiplied with light color 
		
		totaldiffuseRamped += (tex2D(gradientSampler, (0.5,diffuse))*lightsarray[i].LightColor);  //same thing, but the diffuse is warped by a texture first

		totaldiffuse = lerp(totaldiffuse, totaldiffuseRamped, grad); //lerp to do the actual if logic :)
		
		//specular term
		float4 specular = (1.0,1.0,1.0,1.0);
		specular *= blinnspecular(normal,lightsarray[i].LightVec, In.eyeVec, gloss);
		specular *= speccolor; //apply specular color map
		
		specular *= ShadowFloats[i]; // reduce specular by shadow, since you don't want specular where light can't go. we use raw specular value because this effect is absolute
		
		specular *= lightsarray[i].LightColor; //multiply by light color
		
		totalspecular += (specular); //add every light specular to total specular level
	}
	totalspecular *= speclevel; // apply global specular multiplier to increase global strength
	
	
	

	
	//Apply Lighting
	
	float4 ret = color; // our final returned color starts as unlit diffuse color

		float adjust = HueAdjust/10; //value is divided since it's not very userfriendly to work with 0.01 increments
		float3 rethsl = RGBToHSL(ret.rgb); //convert to HSL
		rethsl.x -= adjust*(1-totaldiffuse); //Shift Hue
		rethsl.y += adjust*(1-totaldiffuse); //increase saturation
		rethsl.z -= adjust*(1-totaldiffuse); //decrease lightness, not too sure if this is all correct, with the multiplication following this...
		ret.rgb = HSLToRGB(rethsl);
	
	
	ret = float4(pow(ret.x,Gamma),pow(ret.y,Gamma),pow(ret.z,Gamma),ret.a);
	ret.rgb*=(totaldiffuse); //multiply diffuse with color
	ret+=totalspecular; // ADD specular to colored diffuse
	
	
	//Self Illumination
	
	if(bUseSIMap)
	{
		//get total SI amount by adding (desaturated) map contribution to global level and the clamping between 0 and 1
		float SItotal = saturate(desaturate(selfillumination.rgb)); 
		
		ret = lerp( ret, color * siMapMult,  SItotal); //lerp blend between normal shaded model and unlit multiplied by SImapmultiplier. no color contribution of glowmap yet....
	}
	


	if(!bAlphaMasksFresnel) opacity=saturate(opacity+totalspecular);
	ret.a = opacity; // finally set opacity
	
	ret = pow(ret,1.0/Gamma);
	
	return ret; //all done, return result :)
} 


//Fresnel effects PS pass function. Main reason for split is to avoid hitting the dynamic branching limit
float4 ps_fresnel(VS_To_PS_Struct In) : COLOR 
{ 
	float4 ret =(0,0,0,0);
	
	half2 diffUV = In.texCoord.xy;
	if(DiffuseMapUV == 2)	diffUV=In.texCoord.zw;
	else if(DiffuseMapUV == 3) diffUV=In.texCoord2.xy;
	else if(DiffuseMapUV == 4) diffUV=In.texCoord2.zw;
	
	//alpha
	float opacity = GlobalOpacity; //default is global opacity
	if(bUseAlpha)
	{
		opacity = tex2D(diffuseSampler, diffUV).a; //sampled alpha from diffuse map
		if(bAlphaMasksFresnel && bClip) clip( opacity < ClipTreshold ? -1:1 );
	}
	
	//specular
	float3 speccolor = specularColor.rgb; //default is solid specular color
	if(bUseSpecMap)
	{
		speccolor = tex2D(specularSampler, diffUV).rgb;
	}
	
	//glossiness
	float gloss = 1.0f;
	float glosscorrect = 1.0f;
	if(bUseGlossMap && bUseReflGloss)
	{
		gloss = desaturate(tex2D(glossinessSampler, diffUV)); //overwrite glossiness global with texsample
		glosscorrect = (glossoffset/glossiness);
	}
	
	//normal
	
	half2 normalUV = In.texCoord.xy;
	if(NormalMapUV == 2)	normalUV=In.texCoord.zw;
	else if(NormalMapUV == 3) normalUV=In.texCoord2.xy;
	else if(NormalMapUV == 4) normalUV=In.texCoord2.zw;
	
	float3 normal = In.worldNormal; //default worldspace vertex normal
	if(bUseNormalMap)
	{
		normal = tex2D(normalSampler, normalUV).rgb;
		normal = (2*normal)-1; //expand into -1 to 1 range, since a normalmap is always returned in 0 to 1 space
		normal = normal.yxz;
		if (bFlipGreenChannel) normal.g =-normal.g; //flip green for texture instead of flipping tangent, works for object space normals also
		/*
		if (bFlipRG) 
		{
			float temp = normal.r;
			normal.r = normal.g;
			normal.g = temp;
		}*/
	}
	
		//rotated reflection vector
		
		normal = NormalApplication(normal, In);
	
	float3 ReflectVector = reflect(In.eyeVec, normal); //compute reflection vector
	
	float3 rotatedreflection=ReflectVector;
	float3 rotangle=radians(EnvRotation);
	rotatedreflection.x= (cos(rotangle) * ReflectVector.x) - (sin(rotangle)*ReflectVector.y);
	rotatedreflection.y= (sin(rotangle) * ReflectVector.x) + (cos(rotangle)*ReflectVector.y);
	rotatedreflection.z= ReflectVector.z;
	
	
	ReflectVector= rotatedreflection;
	
	//reflection
	float3 reflectmap = speccolor.rgb; //use desaturated specmap for reflections if reflectmap is not enabled
	if(bUseReflMap)
	{
		reflectmap = tex2D(ReflMapSampler, diffUV).rgb; //use colored reflectmap to enable metal-like colored reflections
		
	}
	

	
	
	
	
		//SHADOWCODE
	//Shadow calculations
	
	ShadowFloats[0]=ShadowStrengths[0]=ShadowFloats[1]=ShadowStrengths[1]=ShadowFloats[2]=ShadowStrengths[2]=1.0f; //set all shadow values to 1, fully lit no shadow as default
	
	if(bUseShadow) //if shadow 1 is on, only shadow 1 will be filled, the rest just stay at one
	{
		ShadowFloats[0] = ShadowLookUp(float4(In.worldSpacePos.xyz,1),Shadow1Type); // lookup shadows with special function
			
		ShadowStrengths[0] = ShadowFloats[0] + ((1-Shadow1Strength) * (1-ShadowFloats[0])); //calculate final shadow strength based on user settings
	}
	
	if(bUseFresnel)
	{
		float3 reflectionamount = reflectmap * fresnel(normal, In.eyeVec, FresnelPower, FresnelBias); //start off by getting fresnel falloff
		//reflectmap *= reflectionamount; //mask reflectmap by fresnelrim, if no reflectmap is used, the value will be the specmap.
		
		
		ReflectVector.xyz = ReflectVector.xzy;  //swizzle required for Max 
	
		float worldmask =1.0f;
		if(!bUseWorldMask)
		{
			worldmask = 1 - saturate(dot(float3(0.0,1.0,0.0),-normal.xzy)); // invert, clamped dot product of normal and upward vector => only normals pointing upward will work
			worldmask = pow(worldmask, FresnelMaskHardness); // power to hardness factor to control effect. 0 equals no control
		}
		else
		{
			//hard type masking activated for reflection faking
			worldmask = (1 - saturate(dot(float3(0.0,(1.0/FresnelMaskHardness /*<=this softens the effect*/),0.0),ReflectVector))); // invert, clamped dot product of reflection and upward vector => only reflections tracing upward will work
			float limit =  saturate(dot(float3(0.0,1,0.0),normal.xzy)); //prevent top from reflecting,m effectively creating a studio HDRi in code only.
			worldmask -= saturate(pow(limit,0.8)); //subtract top mask from reflect mask, powered to 0.8 to soften the effect a bit
			worldmask = saturate(worldmask);
		}
		
		//final lerps, to blend between fresnel effect and lit color
		if(!bUseCubeMap) //if no cubemap, fake fresnel rim used
			ret.rgb = float4(FresnelColor,0.0f)*FresnelMult * reflectionamount * worldmask; //fresnel color masked by specmap, masked by worldmask, multiplied by intensity
		if(bUseCubeMap)
		{
			ReflectVector.yz = -ReflectVector.yz; //invert reflectionvector for cubemap sampling
			float reflectiongloss = lerp((CubeMapBlur*glosscorrect),CubeMapBlur,gloss); //calculate final reflection blur factor by rescaling gloss to max blur range
			float3 reflcubemap = texCUBElod(EnvcubemapSampler, float4(ReflectVector.x,ReflectVector.y,ReflectVector.z,reflectiongloss)); //sample from cubemap with reflection vector, LOD forced by reflection blur factor
																		//NOTE: using texCUBElod with ( ReflectVector.xyz, LODlevel) DOES NOT WORK AS IT SHOULD, split in components to fix ~0_o>
		//SHADOWCODE
		//IBL Shadow hack
		if(numberOfActiveLights == 0 && bUseShadow)
		{
			float3 reflbase = texCUBElod(EnvcubemapSampler, float4(0,-1,0,reflectiongloss));
			
				
			reflcubemap = lerp((0,0,0),reflcubemap,ShadowStrengths[0]);
		}
	
				ret.rgb = float4(FresnelMult*reflcubemap*reflectionamount,0); //add cubemap, multiplied with fresnel multiplier, masked by fresnel
		}
	}
	

	if(bAlphaMasksFresnel) ret.rgb *= opacity; //if opacity is used, you can reduce the fresnel effects strength to match the opacity. The is off by default since glass effects are better like this

	return ret;
}

float4 ps_glowmask(VS_To_PS_Struct In) : COLOR 
{ 
	float4 ret =(0,0,0,0);
	
	//self illumination
	float4 selfillumination = (0.0f,0.0f,0.0f,0.0f); //default no self illum
	if(bUseSIMap)
	{
		selfillumination = tex2D(siMapSampler, In.texCoord.xy);
	}
	
	ret.rgb = saturate(selfillumination.rgb);

	return ret;
}


technique Default  
{  
	pass  P0
    {		 
		ZEnable = true; 
		ZWriteEnable = true; 
		CullMode = cw; //clockwise culling
		AlphaBlendEnable = true; //alphablend allows for full range, smooth opacity masking
		AlphaTestEnable = false;
		ShadeMode = Gouraud; //required for smooth vertex colors
		VertexShader = compile vs_3_0 vs_main( );
		PixelShader = compile ps_3_0 ps_main( );
	}  
	pass P1
	{		 
		ZEnable = true; 
		ZWriteEnable = true; 
		CullMode = cw; //clockwise culling
		AlphaBlendEnable = true; //alphablend allows for full range, smooth opacity masking
		AlphaTestEnable = false; 
		SrcBlend = One; // additive blening of fresnel stuff
		DestBlend = One;
		VertexShader = compile vs_3_0 vs_main( );
		PixelShader = compile ps_3_0 ps_fresnel( );
	}

} 

technique TwoSided  
{  
	pass  P0
    {		 
		ZEnable = true; 
		ZWriteEnable = true; 
		CullMode = none; //clockwise culling
		AlphaBlendEnable = true; //alphablend allows for full range, smooth opacity masking
		AlphaTestEnable = false;
		ShadeMode = Gouraud; //required for smooth vertex colors
		VertexShader = compile vs_3_0 vs_main( );
		PixelShader = compile ps_3_0 ps_main( );
	}  
	pass P1
	{		 
		ZEnable = true; 
		ZWriteEnable = true; 
		CullMode = none; //clockwise culling
		AlphaBlendEnable = true; //alphablend allows for full range, smooth opacity masking
		AlphaTestEnable = false; 
		SrcBlend = One; // additive blening of fresnel stuff
		DestBlend = One;
		VertexShader = compile vs_3_0 vs_main( );
		PixelShader = compile ps_3_0 ps_fresnel( );
	}

} 
/*
technique Glow
<
	string script = 
			"RenderColorTarget0=ModelMap;"
			"RenderDepthStencilTarget=DepthTex;"
			"ClearSetColor=ClearColor;"
			"ClearSetDepth=ClearDepth;"
			"ScriptSignature=color;"
			"Pass=Model;"				
			"Pass=Reflections;"
			"Pass=GlowMask;";				
>   
{  
	pass  Model
	<
	   	string Script= "RenderColorTarget0=;"
						"Draw=Geometry;";
    >

    {		 
		ZEnable = true; 
		ZWriteEnable = true; 
		CullMode = none; //clockwise culling
		AlphaBlendEnable = true; //alphablend allows for full range, smooth opacity masking
		AlphaTestEnable = false;
		ShadeMode = Gouraud; //required for smooth vertex colors
		VertexShader = compile vs_3_0 vs_main( );
		PixelShader = compile ps_3_0 ps_main( );
	}  
	pass Reflections
	<
       	string Script= "RenderColorTarget0=;"
			//"Clear=Color;"
			"Draw=Geometry;";        	
    >
	{		 
		ZEnable = true; 
		ZWriteEnable = false; 
		CullMode = none; //clockwise culling
		AlphaBlendEnable = true; //alphablend allows for full range, smooth opacity masking
		AlphaTestEnable = false; 
		SrcBlend = One; // additive blening of fresnel stuff
		DestBlend = One;
		VertexShader = compile vs_3_0 vs_main( );
		PixelShader = compile ps_3_0 ps_fresnel( );
	}
	
	pass GlowMask
	<
       	string Script= "RenderColorTarget0=GlowMap;"
						"Clear=Color;"
						"Clear=Depth;"
						"Draw=Buffer;";        	
    >
	{		 
		ZEnable = true; 
		ZWriteEnable = false; 
		CullMode = none; //clockwise culling
		AlphaBlendEnable = true; //alphablend allows for full range, smooth opacity masking
		AlphaTestEnable = false; 
		SrcBlend = One; // additive blening of fresnel stuff
		DestBlend = One;
		VertexShader = compile vs_3_0 vs_main( );
		PixelShader = compile ps_3_0 ps_glowmask( );
	}

} */


