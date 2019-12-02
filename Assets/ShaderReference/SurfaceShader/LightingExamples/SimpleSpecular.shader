Shader "FL/Surface Shader/Lighting/Simple Specular"
{
	/*
		示例显示了一个简单的镜面照明模型，类似于内置的BlinnPhong光照模型。
	*/

	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}

	SubShader
	{
		Tags { "RenderType" = "Opaque" }

		CGPROGRAM

		#pragma surface surf Specular

		struct Input 
		{
			float2 uv_MainTex;
		};

		sampler2D _MainTex;

		void surf(Input IN, inout SurfaceOutput o)
		{
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
		}

		half4 LightingSpecular(SurfaceOutput s, half3 lightDir, half atten)
		{

			half3 h = normalize(s.Normal + lightDir);

			half diff = max(0, dot(s.Normal, lightDir));

			half nh = max(0, dot(s.Normal, h));
			half spec = pow(nh, 48.0);

			half4 c;
			c.rgb = (s.Albedo * _LightColor0.rgb * diff + _LightColor0.rgb * spec) * atten;
			c.a = s.Alpha;
			return c;
		}

		ENDCG
	}

	Fallback "Diffuse"
}
