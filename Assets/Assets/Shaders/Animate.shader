Shader "Unlit/Animate"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_TintTex ("Tint Texture", 2D) = "white" {}
		_ScrollSpeeds ("Scroll Speeds", vector) = (-5, -20, 0, 0)
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _TintTex;
			float4 _TintTex_ST;
			float4 _ScrollSpeeds;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv - 0.5f;
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float2 polar = float2(
					atan2(i.uv.y, i.uv.x) / (2.0f * 3.141592653589f),
					length(i.uv)
				);
				float2 tintUVs = polar * _TintTex_ST.xy;
				tintUVs += _ScrollSpeeds.zw * _Time.x;

				polar *= _MainTex_ST.xy;
				polar += _ScrollSpeeds.xy * _Time.x;

				// sample the texture
				fixed4 col = tex2D(_MainTex, polar);
				col *= tex2D(_TintTex, tintUVs);

				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}
