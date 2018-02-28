// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'
Shader "TheMill/2b_Ambient" {
    Properties {
        _Color ("Color", Color) = (1.0, 1.0, 1.0, 1.0)
        _animateLightStrength ("Animate light strength", Range (0.0, 1.0)) = 0.0
        _Cube("Cube map", Cube) = "" {}
    }
    SubShader {
        Pass {
            Tags { "LightMode" = "ForwardBase" }
            CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #include "UnityCG.cginc"

                // User defined variables
                uniform float4 _Color;
                uniform float _animateLightStrength;
                uniform samplerCUBE _Cube;  
                // Unity defined variables
                uniform float4 _LightColor0;
                // Unity 3 definitions

                //float4x4 _Object2World;
                //float4x4 _World2Object;
                //float4 _WorldSpaceLightPos0;

                // base input structs
                struct vertexInput {
                    float4 vertex : POSITION;
                    float3 normal : NORMAL;
                };

                struct vertexOutput {
                    float4 pos : SV_POSITION;
                    float4 col : COLOR;
                    float3 texDir : TEXCOORD0;
                };

                // vertex function
                vertexOutput vert(vertexInput v) {

                    vertexOutput o;

                    float3 normalDirection = normalize( mul( float4(v.normal, 0.0), unity_WorldToObject).xyz );
                    float3 lightDirection;
                    float atten =  _animateLightStrength == 1.0 ? _SinTime : 1.0;

                    lightDirection = normalize( _WorldSpaceLightPos0.xyz );

                    float3 diffuseReflection = atten 
                                                * _LightColor0.xyz
                                                * _Color.rgb
                                                * max(0.0, dot(normalDirection, lightDirection));

                    // For realistic lighting
                    float3 lightFinal = diffuseReflection + UNITY_LIGHTMODEL_AMBIENT.xyz;

                    o.col = float4(lightFinal * _Color, 1.0);
                    o.pos = UnityObjectToClipPos(v.vertex);
                    return o;

                }

                // fragment function
                float4 frag(vertexOutput i) : COLOR {
                    return i.col;
                }

            ENDCG
        }
    }

    //Fallback "Diffuse"
}