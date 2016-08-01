Shader "Room/28_Fog" {
  SubShader {
    Pass {
      Tags { "LightMode" = "ForwardBase" }

      CGPROGRAM
      #include "UnityCG.cginc"
      #pragma vertex vert
      #pragma fragment frag

      #pragma multi_compile_fog

      struct v2f {
        float4 pos : SV_POSITION;
        float3 normal : TEXCOORD0;
        UNITY_FOG_COORDS(1)
      };
      v2f vert (appdata_full v) {
        v2f o;
        o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
        o.normal = UnityObjectToWorldNormal(v.normal);

        UNITY_TRANSFER_FOG(o,o.pos);
        return o;
      }

      fixed4 frag (v2f i) : SV_Target {
        float3 normalDir = normalize(i.normal);
        float3 lightDir = _WorldSpaceLightPos0;

        float NdotL = max(0,dot(normalDir, lightDir));
        float4 col = float4(1,1,1,1) * NdotL;

        UNITY_APPLY_FOG(i.fogCoord, col);
        return col;
      }
      ENDCG
    }
  }
}
