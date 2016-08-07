Shader "Room/42_RealtimeReflection" {
  Properties {
    _ReflectionTex ("", 2D) = "white" {}
  }
  SubShader {
    Pass {
      CGPROGRAM
      #include "UnityCG.cginc"
      #pragma vertex vert
      #pragma fragment frag

      uniform sampler2D _ReflectionTex;

      struct v2f {
        float4 pos : SV_POSITION;
        float4 spos : TEXCOORD0;
      };

      v2f vert (appdata_full v) {
        v2f o;
        o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
        o.spos = ComputeScreenPos(o.pos);
        return o;
      }

      fixed4 frag (v2f i) : SV_Target {
        fixed4 refl = tex2Dproj(_ReflectionTex, UNITY_PROJ_COORD(i.spos));
        return refl;
      }
      ENDCG
    }

    Pass {
      Cull front
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
        return fixed4(0,0,0,1);
      }
      ENDCG
    }
  }
}
