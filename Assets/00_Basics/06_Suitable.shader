Shader "Room/06_Suitable" {
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

    fixed4 frag_red (v2f i) : SV_Target {
      return fixed4(1,0,0,1);
    }
    fixed4 frag_blue (v2f i) : SV_Target {
      return fixed4(0,0,1,1);
    }
  ENDCG

  SubShader {
    Pass {
      CGPROGRAM
      #pragma only_renderers ps4
      #pragma vertex vert
      #pragma fragment frag_red
      ENDCG
    }
  }
  SubShader {
    Pass {
      CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag_blue
      ENDCG
    }
  }

}
