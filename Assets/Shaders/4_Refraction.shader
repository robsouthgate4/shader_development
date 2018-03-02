
Shader "TheMill/4_Refraction" {
    Properties {
        _Color ("Color", Color) = (1.0, 1.0, 1.0, 1.0)
        _Cube("Cube map", Cube) = "" {}
        _MainTex ("Main texture", 2D) = "white" { }
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
                uniform sampler2D _MainTex;

                // base input structs
                struct vertexInput {
                    float4 vertex : POSITION;
                    float3 normal : NORMAL;
                };

                struct vertexOutput {
                    float4 pos : SV_POSITION;
                    float4 col : COLOR;
                    half3 worldRefl : TEXCOORD0;
                };

                // vertex function
                vertexOutput vert(vertexInput v) {

                    vertexOutput o;

                    float3 normalDirection = normalize( mul( float4(v.normal, 0.0), unity_WorldToObject).xyz );
                    float3 lightDirection;
                    float atten = 1.0;

                    lightDirection = normalize( _WorldSpaceLightPos0.xyz );

                    float3 diffuseReflection = atten 
                                                * _LightColor0.xyz
                                                * _Color.rgb
                                                * max(0.0, dot(normalDirection, lightDirection));

                    // For realistic lighting
                    float3 lightFinal = diffuseReflection + UNITY_LIGHTMODEL_AMBIENT.xyz;

                    //v.vertex.x+= v.normal * ( sin(v.vertex.x + _Time) ) * 0.1;
                   

                    o.col = float4(lightFinal * _Color, 1.0);
                    o.pos = UnityObjectToClipPos(v.vertex);

                    float dist = _SinTime * 0.5 + 0.5;

                    // compute world space position of the vertex
                    float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

                    float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));

                    //v.vertex.xyz *= v.normal * _Color;

                    // world space normal
                    float3 worldNormal = UnityObjectToWorldNormal(v.normal);

                    o.worldRefl = reflect(-worldViewDir, worldNormal);

                   


                    return o;

                }

                // fragment function
                float4 frag(vertexOutput i) : SV_Target {
                    // sample the default reflection cubemap, using the reflection vector
                    half4 skyData = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, i.worldRefl);
                    // decode cubemap data into actual color
                    half3 skyColor = DecodeHDR (skyData, unity_SpecCube0_HDR);
                    // output it!
                    fixed4 c = 0;
                    //half3 newWorldRefl = mul(i.worldRefl, _SinTime * 2.0);
                    fixed4 texCol = tex2D (_MainTex, i.worldRefl);
                    //c.rgb = skyColor * texCol.rgb;
                    c.rgb = texCol;

                    return c;
                }

            ENDCG
        }
    }

    //Fallback "Diffuse"
}