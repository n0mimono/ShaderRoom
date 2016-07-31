Shader "Room/13_VertexColor" {
  SubShader {
    Pass {
      CGPROGRAM
      #include "UnityCG.cginc"
      #pragma vertex vert
      #pragma fragment frag

      struct v2f {
        float4 pos : SV_POSITION;
        float4 color : TEXCOORD0;
      };
      v2f vert (appdata_full v) {
        v2f o;
        o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
        o.color = v.color;
        return o;
      }

      fixed4 frag (v2f i) : SV_Target {
        return i.color;
      }
      ENDCG
    }
  }
}
