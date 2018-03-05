﻿// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "TheMill/6_HologramShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
        _Color ("Color", Color) = (1,0,0,1)
        _ScanningFrequency ("Scanning Frequncy", Float) = 80.0
        _ScanningSpeed ("Scanning Speed", Float) = 30.0
        _Bias ("Bias", Float) = 1.0
	}
	SubShader
	{
		Tags { "Queue" = "Transparent" "RenderType" = "Alpha" }
		LOD 100
        ZWrite Off
        Blend SrcAlpha One
        Cull Off

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
                float4 objVertex : TEXCOORD1;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

            // User defined variabled

            fixed4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;
            float _ScanningFrequency;
            float _ScanningSpeed;
            float _Bias;
			
			v2f vert (appdata v)
			{
				v2f o;


				o.vertex = UnityObjectToClipPos(v.vertex);

                // Convert object space to world
                o.objVertex = mul(unity_ObjectToWorld, v.vertex);

                //o.objVertex = o.vertex;

                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);

                col = _Color * max(0, cos((i.objVertex.y) * _ScanningFrequency + -(_Time.y * _ScanningSpeed)) + _Bias);

                //col *= 1 - max(0, cos((i.objVertex.x) * _ScanningFrequency + -(_Time.y * _ScanningSpeed)) + 0.9);

                col.b += i.objVertex.y;

				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}
