// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "TheMill/6_HologramShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
        _Color ("Color", Color) = (0, 1, 0.84, 1)
        _Transparency("Transparency", Range(0.0, 1.0)) = 0.5
        _ScanningFrequency("Scanning Frequency", Float) = 100
        _ScanningSpeed("Scanning Speed", Float) = 10

        _WaveSpeed("Wave Speed", Float) = 1
        _WaveAmount("Wave Amount", Float) = 1
        _WaveAmplitude("Wave Amplitude", Range(0.0, 30.0)) = 0.5
        _WaveDistance("Wave Distance", Float) = 1
        _Tint("Tint", Float) = 0
	}
	SubShader
	{
		Tags { "Queue" = "Transparent" "RenderType" = "Opaque" }
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
				float4 vertex : SV_POSITION;
			};

            // User defined variables

            fixed4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;
            float _Transparency;
            float _ScanningFrequency;
            float _ScanningSpeed;
            float _WaveSpeed;
            float _WaveAmplitude;
            float _WaveAmount;
            float _WaveDistance;
            float _Tint;
			
			v2f vert (appdata v)
			{
				v2f o;
				
				
				/*if (v.vertex.y > 0.8) {
				    v.vertex.x += frac(sin(_Time.y * 8)) * 0.05;
				}
                if (v.vertex.y < 0.3) {
				    v.vertex.x += frac(sin(_Time.y * 8)) * 0.05;
				}*/		

                v.vertex.x += sin(_Time.y * _WaveSpeed  + v.vertex.y * _WaveAmplitude) * _WaveDistance * _WaveAmount;
                
				o.vertex = UnityObjectToClipPos(v.vertex); //o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);

                // Convert object space to world

                o.objVertex = mul(unity_ObjectToWorld, v.vertex);

                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

				UNITY_TRANSFER_FOG(o,o.vertex);
                
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// Sample the texture
                
				fixed4 col = tex2D(_MainTex, i.uv);

                col = fixed4(i.uv.x, i.uv.y, 1.0, 1.0);

                col = _Color * max(0, cos((i.objVertex.y * _ScanningFrequency) + -(_Time.y * _ScanningSpeed))) + _Tint;

                col *= _Color * max(0.5, cos(i.objVertex.y + -_Time.y * 4));

                col *= _Color * max(0.3, cos(i.objVertex.y + _Time.y * 4));
                
                //col *= _Color * max(0.3, frac(i.objVertex.y + _Time.y * 2));

                col.a = _Transparency;

				return col;
			}
			ENDCG
		}
	}
}
