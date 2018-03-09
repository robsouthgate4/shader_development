Shader "TheMill/CustomImageEffect"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
        _Color ("Color", Color) = (1.0, 1.0, 1.0, 1.0)
        _Magnitude("Magnitude", Range(0.0, 1.0)) = 1.0
        _DisplacementTexture("Displacement Texture", 2D) = "white" {}
        _HeatSpeed("Heat Speed", Float) = 10
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
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
            sampler2D _DisplacementTexture;
			float4 _MainTex_ST;
            float4 _Color;
            float _Magnitude;
            float _HeatSpeed;
			
			v2f vert (appdata v)
			{
				v2f o;                
				o.vertex = UnityObjectToClipPos(v.vertex);                
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);                
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{                

                float2 displacement = tex2D(_DisplacementTexture, float2(i.uv.x + (_Time.x * _HeatSpeed), i.uv.y)).xy;                
                displacement = ((displacement * 2) - 1) * _Magnitude;

                fixed4 col = tex2D(_MainTex, i.uv + displacement);             

				return col;
			}
			ENDCG
		}
	}
}
