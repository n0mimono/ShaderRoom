﻿Shader "Room/04_Projection" {
  SubShader {
    Pass {
      CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag

      struct appdata {
        float4 vertex : POSITION;
      };
      struct v2f {
        float4 vertex : SV_POSITION;
      };

      v2f vert (appdata v) {
        v2f o;
        o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
        return o;
      }

      fixed4 frag (v2f i) : SV_Target {
        return fixed4(1,1,1,1);
      }
      ENDCG
    }
  }
}
