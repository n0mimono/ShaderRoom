Shader "Room/33_Blending" {
  Properties {
    _Base ("Base", 2D) = "bump" {}
    _Detail ("Detail", 2D) = "bump" {}
    [Enum(None,0,Linear,1,Unity,2)] _BlendMode ("Use Unity Blend", Float) = 2
  }
  SubShader {
    Pass {
      Tags { "LightMode" = "ForwardBase" }

      CGPROGRAM
      #include "UnityCG.cginc"
      #include "AutoLight.cginc"
      #pragma vertex vert
      #pragma fragment frag

      uniform sampler2D _Base; uniform float4 _Base_ST;
      uniform sampler2D _Detail; uniform float4 _Detail_ST;
      uniform float _BlendMode;

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

      float3 blnedLinear(float3 n1, float3 n2) {
        return (n1 + n2) * 0.5;
      }
      float3 blendUnity(float3 n1, float3 n2) {
        // http://blog.selfshadow.com/publications/blending-in-detail/
        float3x3 nBasis = float3x3(
          float3(n1.z, n1.y, -n1.x),
          float3(n1.x, n1.z, -n1.y),
          float3(n1.x, n1.y,  n1.z)
        );
        return normalize(n2.x*nBasis[0] + n2.y*nBasis[1] + n2.z*nBasis[2]);
      }

      fixed4 frag (v2f i) : SV_Target {
        float3x3 tanTrans = float3x3(i.tangent, i.bitangent, i.normal);
        float3 normalLocal = UnpackNormal(tex2D(_Base, TRANSFORM_TEX(i.uv, _Base)));
        float3 normalDetail = UnpackNormal(tex2D(_Detail, TRANSFORM_TEX(i.uv, _Detail)));

        if (_BlendMode == 1) {
          normalLocal = blnedLinear(normalLocal, normalDetail);
        } else if (_BlendMode == 2) {
          normalLocal = blendUnity(normalLocal, normalDetail);
        }

        float3 normalDir = normalize(mul(normalLocal, tanTrans));
        return float4(normalDir * 0.5 + 0.5, 1);
      }
      ENDCG
    }

  }

}
