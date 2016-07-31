Shader "Room/08_Cginc" {
  SubShader {
    Pass {
      CGPROGRAM
      #include "UnityCG.cginc"
      #pragma vertex vert
      #pragma fragment frag

      struct v2f {
        float4 pos : SV_POSITION;
      };
      v2f vert (appdata_full v) {
        v2f o;
        o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
        return o;
      }

      fixed4 frag (v2f i) : SV_Target {
        return fixed4(1,0,0,1);
      }
      ENDCG
    }
  }
}
