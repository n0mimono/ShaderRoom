Shader "Room/40_AlphaTest" {
  Properties {
    _Color ("Tint", Color) = (1,0,0,0.5)
    _MainTex ("Texture", 2D) = "white" {}
    _Mask ("Mask", 2D) = "white" {}
    _CutOff ("_CutOff", Range(0,1)) = 0
  }
  SubShader {
    Tags { "Queue"="AlphaTest" }
    LOD 100
    Cull Off

    Pass {
      CGPROGRAM
      #include "UnityCG.cginc"
      #pragma vertex vert
      #pragma fragment frag

      uniform float4 _Color;
      uniform sampler2D _MainTex;
      uniform sampler2D _Mask;
      uniform float _CutOff;

      struct v2f {
        float4 pos : SV_POSITION;
        float2 uv : TEXCOORD0;
      };
      v2f vert (appdata_full v) {
        v2f o;
        o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
        o.uv = v.texcoord;
        return o;
      }

      fixed4 frag (v2f i) : SV_Target {
        float mask = tex2D(_Mask, i.uv).r;
        clip(mask - _CutOff);

        float4 col = tex2D(_MainTex, i.uv) * _Color;
        return col;
      }
      ENDCG
    }
  }
}
