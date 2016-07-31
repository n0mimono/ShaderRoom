Shader "Room/26_Gloss" {
  Properties {
    _Color ("Tint", Color) = (1,0,0,0)
    _MainTex ("Texture", 2D) = "white" {}
    _NormalTex ("Normal", 2D) = "bump" {}
    _SpecularTex ("Specular", 2D) = "white" {}
    _GlossTex ("Gloss", 2D) = "white" {}
  }
  SubShader {
    Pass {
      Tags { "LightMode" = "ForwardBase" }

      CGPROGRAM
      #include "UnityCG.cginc"
      #pragma vertex vert
      #pragma fragment frag

      uniform float4 _Color;
      uniform sampler2D _MainTex;
      uniform sampler2D _NormalTex;
      uniform sampler2D _SpecularTex;
      uniform sampler2D _GlossTex;

      uniform float4 _LightColor0;

      struct v2f {
        float4 pos : SV_POSITION;
        float2 uv : TEXCOORD0;
        float3 normal : TEXCOORD1;
        float3 tangent : TEXCOORD2;
        float3 bitangent : TEXCOORD3;
        float4 worldPos : TEXCOORD4;
      };
      v2f vert (appdata_full v) {
        v2f o;

        o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
        o.uv = v.texcoord;
        o.worldPos = mul(unity_ObjectToWorld, v.vertex);
        o.normal = UnityObjectToWorldNormal(v.normal);
        o.tangent = normalize(mul(unity_ObjectToWorld, float4(v.tangent.xyz, 0)).xyz);
        o.bitangent = normalize(cross(o.normal, o.tangent) * v.tangent.w);

        return o;
      }

      fixed4 frag (v2f i) : SV_Target {
        float3 lightDir = _WorldSpaceLightPos0;
        float3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);

        float3x3 tanTrans = float3x3(i.tangent, i.bitangent, i.normal);
        float3 normalLocal = UnpackNormal(tex2D(_NormalTex, i.uv));
        float3 normalDir = normalize(mul(normalLocal, tanTrans));
        float3 reflectDir = reflect(-viewDir, normalDir);

        float NdotL = max(0,dot(normalDir, lightDir));
        float RdotL = max(0,dot(reflectDir, lightDir));

        float gloss = tex2D(_GlossTex, i.uv);
        float diff = NdotL;
        float spec = pow(RdotL, gloss);
        float emission = unity_AmbientSky * 0.5;

        float4 diffColor = tex2D(_MainTex, i.uv) * _Color;
        float4 specColor = tex2D(_SpecularTex, i.uv);
        return (diffColor * diff + specColor * spec) * _LightColor0 + emission;
      }
      ENDCG
    }
  }
}
