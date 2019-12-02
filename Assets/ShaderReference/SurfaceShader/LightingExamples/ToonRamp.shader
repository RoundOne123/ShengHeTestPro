Shader "FL/Surface Shader/Lighting/Toon Ramp"
{
	/*
		以下示例显示了一个“渐变”照明模型，该模型使用“纹理”渐变来定义曲面如何响应灯光和法线之间的角度。 这可以用于多种效果，并且在与Toon照明一起使用时特别有效。
	*/

	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Ramp("Ramp", 2D) = "ramp" {}
	}


	SubShader
	{
		Tags { "RenderType"="Opaque" }

		CGPROGRAM
#pragma surface surf Ramp

		struct Input {
			float2 uv_MainTex;
		};

		sampler2D _MainTex;
		sampler2D _Ramp;

		void surf(Input IN, inout SurfaceOutput o) 
		{
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
		}

		half4 LightingRamp(SurfaceOutput s, half3 lightDir, half atten) {
			half NdotL = dot(s.Normal, lightDir);
			half diff = NdotL * 0.5 + 0.5;
			// 官方的例子 这里 可以用 float2(diff)
			// 但 我自己写的时候 会报错 故改成了 float2(diff, diff)
			half3 ramp = tex2D(_Ramp, float2(diff, diff)).rgb;
			half4 c;
			c.rgb = s.Albedo * _LightColor0.rgb * ramp * atten;
			c.a = s.Alpha;
			return c;
		}

		ENDCG
	}

	Fallback "diffuse"
}
