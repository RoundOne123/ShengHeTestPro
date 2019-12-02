Shader "FL/Surface Shader/Lighting/Diffuse Texture"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }

		CGPROGRAM
		
#pragma surface surf SimpleLambert	// 自定义简单的光照模型

		struct Input {
			float2 uv_MainTex;
		};

		sampler2D _MainTex;

		void surf(Input IN, inout SurfaceOutput o) 
		{
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
		}

		// 使用了光照方向
		half4 LightingSimpleLambert(SurfaceOutput s, half3 lightDir, half atten)
		{
			half NdotL = dot(s.Normal, lightDir);
			half4 c;
			// _LightColor0 是根据 LigthMode 不同 而 代表不同的光源的颜色
			c.rgb = s.Albedo * _LightColor0.rgb * (NdotL * atten);
			c.a = s.Alpha;
			return c;
		}

		ENDCG

	}

	Fallback "Diffuse"
}
