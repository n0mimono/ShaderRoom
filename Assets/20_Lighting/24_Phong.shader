Shader "Room/24_Phong" {
  Properties {
    _Color ("Tint", Color) = (1,0,0,0)
    _MainTex ("Texture", 2D) = "white" {}
    _Gloss ("Gloss", Float) = 1
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
      uniform float _Gloss;

      uniform float4 _LightColor0;

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

        float NdotL = max(0,dot(normalDir, lightDir));
        float RdotL = max(0,dot(reflectDir, lightDir));

        float diff = NdotL;
        float spec = pow(RdotL, _Gloss);
        float emission = unity_AmbientSky * 0.5;

        float4 col = tex2D(_MainTex, i.uv) * _Color;
        return col * (diff + spec) * _LightColor0 + emission;
      }
      ENDCG
    }
  }
}
