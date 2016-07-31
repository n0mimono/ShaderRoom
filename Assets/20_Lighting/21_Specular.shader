Shader "Room/21_Specular" {
  Properties {
    [Toggle(_USE_HALF_VECTOR)] _UseHalfVector ("Use Half Vector", Float) = 0
  }
  SubShader {
    Pass {
      Tags { "LightMode" = "ForwardBase" }

      CGPROGRAM
      #include "UnityCG.cginc"
      #pragma vertex vert
      #pragma fragment frag

      #pragma multi_compile __ _USE_HALF_VECTOR

      struct v2f {
        float4 pos : SV_POSITION;
        float3 normal : TEXCOORD0;
        float4 worldPos : TEXCOORD1;
      };
      v2f vert (appdata_full v) {
        v2f o;
        o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
        o.worldPos = mul(unity_ObjectToWorld, v.vertex);
        o.normal = UnityObjectToWorldNormal(v.normal);
        return o;
      }

      fixed4 frag (v2f i) : SV_Target {
        float3 normalDir = normalize(i.normal);
        float3 lightDir = _WorldSpaceLightPos0;
        float3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);
        float3 halfDir = normalize(lightDir + viewDir);

        #ifdef _USE_HALF_VECTOR
          float NdotH = max(0,dot(normalDir, halfDir));
          return float4(1,1,1,1) * NdotH;
        #else
          float3 reflectDir = reflect(-viewDir, normalDir);
          float RdotL = max(0,dot(reflectDir, lightDir));
          return float4(1,1,1,1) * RdotL;
        #endif
      }
      ENDCG
    }
  }
}
