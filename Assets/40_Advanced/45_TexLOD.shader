Shader "Room/45_TexLOD" {
  Properties {
    _MainTex ("Texture", 2D) = "white" {}
    _Mip ("Mip", Range(0,5)) = 0
  }
  SubShader {
    Pass {
      CGPROGRAM
      #include "UnityCG.cginc"
      #pragma vertex vert
      #pragma fragment frag

      uniform sampler2D _MainTex;
      uniform float4 _MainTex_ST;

      uniform float _Mip;

      struct v2f {
        float4 pos : SV_POSITION;
        float2 uv : TEXCOORD1;
      };
      v2f vert (appdata_full v) {
        v2f o;
        o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
        o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
        return o;
      }

      fixed4 frag (v2f i) : SV_Target {
        float4 col = tex2Dlod(_MainTex, float4(i.uv, 1, _Mip));
        return col;
      }
      ENDCG
    }
  }
}
