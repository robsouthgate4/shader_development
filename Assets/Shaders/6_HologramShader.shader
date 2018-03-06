// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "TheMill/6_HologramShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
        _Color ("Color", Color) = (1,0,0,1)
        _ScanningFrequency ("Scanning Frequncy", Float) = 80.0
        _ScanningSpeed ("Scanning Speed", Float) = 30.0
        _Bias ("Bias", Float) = 1.0

        _Transparency("Transparency", Range(0.0, 1.0)) = 1.0
        _Tint("Tint", Range(0.0, 1.0)) = 0.0
        _Amount("Amount", Float) = 1.0
        _Amplitude("Amplitude", Float) = 1.0
        _Speed("Speed", Float) = 1.0
        _Distance("Distance", Float) = 1.0

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
            float _ScanningFrequency;
            float _ScanningSpeed;
            float _Bias;
            float _Transparency;
            float _Tint;
            float _Amount;
            float _Amplitude;
            float _Speed;
            float _Distance;
			
			v2f vert (appdata v)
			{
				v2f o;

                v.vertex.x += sin((_Time.y * _Speed) + v.vertex.y * _Amplitude) * _Amount * _Distance * v.vertex.y;

				o.vertex = UnityObjectToClipPos(v.vertex); //o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);

                // Convert object space to world

                o.objVertex = mul(unity_ObjectToWorld, v.vertex);

                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

				UNITY_TRANSFER_FOG(o,o.vertex);
                
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
                
				fixed4 col = tex2D(_MainTex, i.uv);

                col = _Color;

                //col = fixed4(i.uv.x, i.uv.y, 1.0, 1.0);

                col *= max(0, cos(i.objVertex.y * _ScanningFrequency + -(_Time.y * _ScanningSpeed )) + _Bias) + _Tint;

                col.a = _Transparency;

				return col;
			}
			ENDCG
		}
	}
}
