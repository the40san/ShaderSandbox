// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/ToonLit" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
	}

	SubShader {
		Pass {
		Name "Forward"

		Tags {
			"RenderType"="Opaque"
		}
		LOD 200

		CGPROGRAM
		#pragma vertex vertex
		#pragma fragment fragment
		#pragma target 3.0

		#include "UnityCG.cginc"
		#include "Lighting.cginc"
		#include "Autolight.cginc"

		uniform float4 _Color;

		struct VertexInput
		{
			float4 vertex : POSITION;
			float2 texcoord : TEXCOORD0;
			float3 normal : NORMAL;
		};

		struct VertexOutput
		{
			float4 pos : SV_POSITION;
			float2 uv0 : TEXCOORD0;
			float3 normal : TEXCOORD1;
			float3 lightDir : TEXCOORD2;
			LIGHTING_COORDS(3,4)
			UNITY_FOG_COORDS(5)
		};

		VertexOutput vertex(VertexInput i)
		{
			VertexOutput o = (VertexOutput)0;
			o.pos = UnityObjectToClipPos(i.vertex);
			o.uv0 = i.texcoord;
			o.normal = UnityObjectToWorldNormal(i.normal);
			o.lightDir = normalize(WorldSpaceLightDir(i.vertex));
			UNITY_TRANSFER_FOG(o, o.pos);
			TRANSFER_VERTEX_TO_FRAGMENT(o);
			return o;
		}

		float4 fragment(VertexOutput i) : COLOR
		{
			float attenuation = LIGHT_ATTENUATION(i);
			float4 finalColor = 0;
			float3 ambient = UNITY_LIGHTMODEL_AMBIENT;
			float4 lightColor = _LightColor0 * saturate( dot ( i.lightDir, i.normal ) );

			finalColor.rgb = (lightColor * _Color * attenuation).rgb + ambient;
			finalColor.a = 1;
			return finalColor;
		}
		ENDCG
		}
	}
	FallBack "Diffuse"
}
