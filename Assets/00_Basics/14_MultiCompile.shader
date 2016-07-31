Shader "Room/14_MultiCompile" {
  Properties {
    [KeywordEnum(None, Vertex, Uv, Normal)] _Display ("Display mode", Float) = 0
  }
  SubShader {
    Pass {
      CGPROGRAM
      #include "UnityCG.cginc"
      #pragma vertex vert
      #pragma fragment frag

      #pragma multi_compile _DISPLAY_NONE _DISPLAY_VERTEX _DISPLAY_UV _DISPLAY_NORMAL

      struct v2f {
        float4 pos : SV_POSITION;
        float4 vertex : TEXCOORD0;
        float2 uv : TEXCOORD1;
        float3 normal : TEXCOORD2;
      };
      v2f vert (appdata_full v) {
        v2f o;
        o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
        o.vertex = v.vertex;
        o.uv = v.texcoord;
        o.normal = v.normal;
        return o;
      }

      fixed4 frag (v2f i) : SV_Target {
        #ifdef _DISPLAY_VERTEX
          return i.vertex;
        #elif _DISPLAY_UV
          return fixed4(i.uv.x, 0, i.uv.y, 1);
        #elif _DISPLAY_NORMAL
          return fixed4(i.normal * 0.5 + 0.5, 1);
        #else
          return fixed4(1,1,1,1) * 0.5;
        #endif
      }
      ENDCG
    }
  }
}
