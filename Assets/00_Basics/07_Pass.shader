Shader "Room/07_Pass" {
  SubShader {
    CGINCLUDE
      struct appdata {
        float4 vertex : POSITION;
      };
      struct v2f {
        float4 vertex : SV_POSITION;
        float height : TEXCOORD0;
      };
      v2f vert (appdata v) {
        v2f o;
        o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
        o.height = v.vertex.y;
        return o;
      }
    ENDCG

    Pass {
      CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag

      fixed4 frag (v2f i) : SV_Target {
        if (i.height < 0) discard;
        return fixed4(1,0,0,1);
      }
      ENDCG
    }

    Pass {
      CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag

      fixed4 frag (v2f i) : SV_Target {
        if (i.height > 0) discard;
        return fixed4(0,0,1,1);
      }
      ENDCG
    }
  }
}
