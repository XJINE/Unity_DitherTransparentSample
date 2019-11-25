Shader "Unlit/DitherTransparent"
{
    Properties
    {
        _MainTex ("Texture",         2D) = "white" {}
        _Alpha   ("Alpha",  Range(0, 1)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM

            #pragma vertex   vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv     : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv     : TEXCOORD0;
            };

            sampler2D _MainTex;
            sampler3D _DitherMaskLOD;
            float     _Alpha;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 vpos = i.vertex.xy / i.vertex.w;
                // return float4(vpos.xy / _ScreenParams.xy, 0, 1);
                vpos *= 0.25;

                clip(tex3D(_DitherMaskLOD, float3(vpos.xy, _Alpha * 0.9375)).a - 0.5);

                return tex2D(_MainTex, i.uv);
            }

            ENDCG
        }
    }
}