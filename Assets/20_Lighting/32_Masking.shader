Shader "Room/32_Masking" {
  Properties {
    _Mask ("Mask", 2D) = "white" {}
    _Tex0 ("Tex 0", 2D) = "white" {}
    _Tex1 ("Tex 1", 2D) = "white" {}
    _Offset ("Offset", Range(-1,1)) = 0
  }
  SubShader {
    Pass {
      Tags { "LightMode" = "ForwardBase" }

      CGPROGRAM
      #include "UnityCG.cginc"
      #include "AutoLight.cginc"
      #pragma vertex vert
      #pragma fragment frag

      uniform sampler2D _Mask;
      uniform sampler2D _Tex0;
      uniform sampler2D _Tex1;
      uniform float _Offset;

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
        float mask = saturate(round(tex2D(_Mask, i.uv).r + _Offset));
        return tex2D(_Tex0, i.uv) * mask + tex2D(_Tex1, i.uv) * (1 - mask);
      }
      ENDCG
    }

  }

}
