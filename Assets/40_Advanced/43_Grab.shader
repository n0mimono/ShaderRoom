Shader "Room/43_Grab" {
  Properties {
    _Color ("Color", Color) = (1,1,1,1)
    _BumpTex ("Bump Tex", 2D) = "bump" {}
    _Distortion ("Distortion", Range(0,1)) = 0
  }
  SubShader {
    Tags { "Queue" = "Transparent" }

    GrabPass { }

    Pass {
      CGPROGRAM
      #include "UnityCG.cginc"
      #pragma vertex vert
      #pragma fragment frag

      uniform sampler2D _GrabTexture;

      uniform float4 _Color;
      uniform sampler2D _BumpTex;
      uniform float _Distortion;

      struct v2f {
        float4 pos : SV_POSITION;
        float4 spos : TEXCOORD0;
        float2 uv : TEXCOORD1;
      };

      v2f vert (appdata_full v) {
        v2f o;
        o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
        o.spos = ComputeScreenPos(o.pos);
        o.uv = v.texcoord;
        return o;
      }

      fixed4 frag (v2f i) : SV_Target {
        float3 bump = UnpackNormal(tex2D(_BumpTex, i.uv));
        i.spos.xy += bump.xy * _Distortion;
        fixed4 col = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.spos));
        return col * _Color;
      }
      ENDCG
    }

  }
}
