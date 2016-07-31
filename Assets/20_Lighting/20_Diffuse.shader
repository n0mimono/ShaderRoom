Shader "Room/20_Diffuse" {
  SubShader {
    Pass {
      Tags { "LightMode" = "ForwardBase" }

      CGPROGRAM
      #include "UnityCG.cginc"
      #pragma vertex vert
      #pragma fragment frag

      struct v2f {
        float4 pos : SV_POSITION;
        float3 normal : TEXCOORD0;
      };
      v2f vert (appdata_full v) {
        v2f o;
        o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
        o.normal = UnityObjectToWorldNormal(v.normal);
        return o;
      }

      fixed4 frag (v2f i) : SV_Target {
        float3 normalDir = normalize(i.normal);
        float3 lightDir = _WorldSpaceLightPos0;

        float NdotL = max(0,dot(normalDir, lightDir));
        return float4(1,1,1,1) * NdotL;
      }
      ENDCG
    }
  }
}
