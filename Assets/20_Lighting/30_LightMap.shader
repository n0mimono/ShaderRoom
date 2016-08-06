Shader "Room/30_LightMap" {
  Properties {
    [Toggle] _UseDir ("_UseDir", Float) = 0
  }
  SubShader {
    Pass {
      Tags { "LightMode" = "ForwardBase" }

      CGPROGRAM
      #include "UnityCG.cginc"
      #include "AutoLight.cginc"
      #pragma vertex vert
      #pragma fragment frag

      uniform float _UseDir;

      struct v2f {
        float4 pos : SV_POSITION;
        float3 normal : TEXCOORD0;
        half4 uv0 : TEXCOORD1;
        half2 uv1 : TEXCOORD2;
        half4 uv2 : TEXCOORD3;
        half4 uv3 : TEXCOORD4;
      };

      half4 DecodeGI(half4 texcoord) {
        half2 uv = texcoord.xy * unity_LightmapST.xy + unity_LightmapST.zw;
        return half4(uv, 0, 0);
      }

      v2f vert (appdata_full v) {
        v2f o;
        o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
        o.normal = UnityObjectToWorldNormal(v.normal);
        o.uv0 = DecodeGI(v.texcoord);
        o.uv1 = DecodeGI(v.texcoord1);
        o.uv2 = DecodeGI(v.texcoord2);
        o.uv3 = DecodeGI(v.texcoord3);
        return o;
      }

      fixed4 frag (v2f i) : SV_Target {
        float4 color = UNITY_SAMPLE_TEX2D(unity_Lightmap, i.uv1);
        if (_UseDir) {
          color = UNITY_SAMPLE_TEX2D_SAMPLER(unity_LightmapInd, unity_Lightmap, i.uv1);
        }
        return color;
      }
      ENDCG
    }

  }

}
