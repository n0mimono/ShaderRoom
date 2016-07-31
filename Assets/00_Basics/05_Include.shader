Shader "Room/05_Include" {
  CGINCLUDE
    #define HALF 0.5
  ENDCG

  SubShader {
    CGINCLUDE
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
      return fixed4(HALF,HALF,HALF,1);
    }
    ENDCG

    Pass {
      CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag
			ENDCG
    }
  }
}
