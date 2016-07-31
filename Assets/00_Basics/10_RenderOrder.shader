Shader "Room/10_RenderOrder" {
  Properties {
    _Color ("Tint", Color) = (1,0,0,0)
    _MainTex ("Texture", 2D) = "white" {}
  }
  SubShader {
    Tags { "RenderType"="Opaque" "Queue"="Geometry" }
		LOD 100
    ZTest True
    ZWrite False

    Pass {
      CGPROGRAM
      #include "UnityCG.cginc"
      #pragma vertex vert
      #pragma fragment frag

      uniform float4 _Color;
      uniform sampler2D _MainTex;

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

      fixed4 frag (v2f i) : SV_Target {
        return tex2D(_MainTex, i.uv) * _Color;
      }
      ENDCG
    }
  }
}
