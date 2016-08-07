Shader "Room/27_Reflection" {
  Properties {
    [Toggle(_USE_BUITIN_MAP)] _UseBuiltinMap ("Use Buit-in Map", Float) = 0
    _CubeMap ("Cube Map", Cube) = "_Skybox" {}
    _Mip ("Mip", Range(0.1, 10)) = 4
  }
  SubShader {
    Pass {
      Tags { "LightMode" = "ForwardBase" }

      CGPROGRAM
      #include "UnityCG.cginc"
      #pragma vertex vert
      #pragma fragment frag

      #pragma multi_compile __ _USE_BUITIN_MAP
      uniform samplerCUBE _CubeMap;
      uniform float _Mip;

      struct v2f {
        float4 pos : SV_POSITION;
        float2 uv : TEXCOORD0;
        float3 normal : TEXCOORD1;
        float4 worldPos : TEXCOORD2;
      };
      v2f vert (appdata_full v) {
        v2f o;
        o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
        o.uv = v.texcoord;
        o.worldPos = mul(unity_ObjectToWorld, v.vertex);
        o.normal = UnityObjectToWorldNormal(v.normal);
        return o;
      }

      fixed4 frag (v2f i) : SV_Target {
        float3 normalDir = normalize(i.normal);
        float3 lightDir = _WorldSpaceLightPos0;
        float3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);
        float3 reflectDir = reflect(-viewDir, normalDir);

        #ifdef _USE_BUITIN_MAP
          half4 rgbm = UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, reflectDir, _Mip);
          return rgbm * 2;
        #else
          half4 rgbm = texCUBElod(_CubeMap, float4(reflectDir, _Mip));
          return rgbm * 2;
        #endif
      }

      ENDCG
    }
  }
}
