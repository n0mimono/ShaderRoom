﻿Shader "Room/03_SubShader" {
  SubShader {
    Pass {
      CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag

      struct appdata {
      };
      struct v2f {
      };

      v2f vert (appdata v) {
        v2f o;
        return o;
      }

      fixed4 frag (v2f i) : SV_Target {
        return fixed4(1,1,1,1);
      }
      ENDCG
    }
  }
}
