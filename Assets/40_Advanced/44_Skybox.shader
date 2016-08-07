Shader "Room/44_Skybox" {
  SubShader {
    Tags { "Queue"="Background" "RenderType"="Background" "PreviewType"="Skybox" }
    Cull Off
    ZWrite Off

    CGINCLUDE
      #include "UnityCG.cginc"
      struct v2f {
        float4 pos : SV_POSITION;
        float2 uv : TEXCOORD0;
      };
      v2f vert (appdata_full v) {
        v2f o;
        o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
        o.uv = v.texcoord;
        return o;
      }
      fixed4 frag_sky (v2f i, float g) {
        return fixed4(i.uv.x, g, i.uv.y, 1);
      }
    ENDCG

    Pass {
      CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag
      fixed4 frag (v2f i) : SV_Target { return frag_sky(i, 0.0/6.0); }
      ENDCG
    }
    Pass {
      CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag
      fixed4 frag (v2f i) : SV_Target { return frag_sky(i, 1.0/6.0); }
      ENDCG
    }
    Pass {
      CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag
      fixed4 frag (v2f i) : SV_Target { return frag_sky(i, 2.0/6.0); }
      ENDCG
    }
    Pass {
      CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag
      fixed4 frag (v2f i) : SV_Target { return frag_sky(i, 3.0/6.0); }
      ENDCG
    }
    Pass {
      CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag
      fixed4 frag (v2f i) : SV_Target { return frag_sky(i, 4.0/6.0); }
      ENDCG
    }
    Pass {
      CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag
      fixed4 frag (v2f i) : SV_Target { return frag_sky(i, 5.0/6.0); }
      ENDCG
    }

  }
}
