Shader "Room/29_Shadow" {
  SubShader {
    Pass {
      Tags { "LightMode" = "ForwardBase" }

      CGPROGRAM
      #include "UnityCG.cginc"
      #include "AutoLight.cginc"
      #pragma vertex vert
      #pragma fragment frag

      #pragma multi_compile_fwdbase_fullshadows
      #pragma multi_compile_fog

      struct v2f {
        float4 pos : SV_POSITION;
        float3 normal : TEXCOORD0;
        LIGHTING_COORDS(1,2)
        UNITY_FOG_COORDS(3)
      };
      v2f vert (appdata_full v) {
        v2f o;
        o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
        o.normal = UnityObjectToWorldNormal(v.normal);

        UNITY_TRANSFER_FOG(o,o.pos);
        TRANSFER_VERTEX_TO_FRAGMENT(o)
        return o;
      }

      fixed4 frag (v2f i) : SV_Target {
        float atten = LIGHT_ATTENUATION(i);

        float3 normalDir = normalize(i.normal);
        float3 lightDir = _WorldSpaceLightPos0;

        float NdotL = max(0.5,dot(normalDir, lightDir));
        float4 col = float4(atten,1,1,1) * NdotL;

        UNITY_APPLY_FOG(i.fogCoord, col);
        return col;
      }
      ENDCG
    }

    Pass {
      Tags { "LightMode" = "ShadowCaster" }

      CGPROGRAM
      #include "UnityCG.cginc"
      #include "AutoLight.cginc"
      #pragma vertex vert
      #pragma fragment frag
      #pragma multi_compile_shadowcaster

      struct v2f {
        V2F_SHADOW_CASTER;
      };

      v2f vert(appdata_base v) {
        v2f o;
        TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
        return o;
      }

      float4 frag(v2f i) : COLOR {
        SHADOW_CASTER_FRAGMENT(i)
      }
      ENDCG

    }
  }

}
