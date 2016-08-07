Shader "Room/41_Stencil" {
  SubShader {
    Tags { "Queue"="AlphaTest" }
    LOD 100

    Pass {
      Stencil {
        Ref 2
      }
      ZWrite Off

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
        return fixed4(1,1,1,1);
      }
      ENDCG
    }

    Pass {
      Stencil {
        Ref 1
        Comp Greater
      }

      CGPROGRAM
      #include "UnityCG.cginc"
      #pragma vertex vert
      #pragma fragment frag

      struct v2f {
        float4 pos : SV_POSITION;
      };

      v2f vert (appdata_full v) {
        v2f o;
        v.vertex.w *= 1.2;
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
