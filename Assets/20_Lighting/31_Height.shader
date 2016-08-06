Shader "Room/31_Height" {
  Properties {
    _HeightMap ("Heith Map", 2D) = "white" {}
    _HeightScale ("Height Scale", Range(0,1)) = 0.2
  }
  SubShader {
    Pass {
      Tags { "LightMode" = "ForwardBase" }

      CGPROGRAM
      #include "UnityCG.cginc"
      #include "AutoLight.cginc"
      #pragma vertex vert
      #pragma fragment frag

      uniform sampler2D _HeightMap;
      uniform float _HeightScale;

      struct v2f {
        float4 pos : SV_POSITION;
        float2 uv : TEXCOORD0;
        float3 normal : TEXCOORD1;
        float3 tangent : TEXCOORD2;
        float3 bitangent : TEXCOORD3;
        float4 worldPos : TEXCOORD4;
        float4 vertex : TEXCOORD5;
      };
      v2f vert (appdata_full v) {
        v2f o;

        o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
        o.uv = v.texcoord;
        o.worldPos = mul(unity_ObjectToWorld, v.vertex);

        o.normal = UnityObjectToWorldNormal(v.normal);
        o.tangent = normalize(mul(unity_ObjectToWorld, float4(v.tangent.xyz, 0)).xyz);
        o.bitangent = normalize(cross(o.normal, o.tangent) * v.tangent.w);

        o.vertex = v.vertex;
        return o;
      }

      fixed4 frag (v2f i) : SV_Target {
        float3 lightDir = _WorldSpaceLightPos0;
        float3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);
        float3x3 tanTrans = float3x3(i.tangent, i.bitangent, i.normal);

        float3 camPosLocal = mul(unity_WorldToObject, float4(_WorldSpaceCameraPos.xyz, 1)).xyz - i.vertex.xyz;
        float3 viewDirLocal = mul(tanTrans, camPosLocal);

        half h = (tex2D (_HeightMap, i.uv).g - 0.5) * _HeightScale;
        half2 offset = h * (viewDirLocal.xy / (viewDirLocal.z + 0.42));
        return half4(offset,0,1);
      }
      ENDCG
    }

  }

}
