using Uno;
using Uno.Graphics;
using Uno.UX;
using Fuse.Effects;
using Fuse;

// Based on https://mouaif.wordpress.com/2009/01/05/photoshop-math-with-glsl-shaders/
public sealed class ContrastSaturationBrightness : BasicEffect
{
	
	float _brightness = 1.0f;
	public float Brightness
	{
		get
		{
			return _brightness;
		}
		set
		{
			if(value!=_brightness)
			{
				_brightness = value;
				OnRenderingChanged();
			}
		}
	}
	
	float _saturation = 1.0f;
	public float Saturation
	{
		get
		{
			return _saturation;
		}
		set
		{
			if(value!=_saturation)
			{
				_saturation = value;
				OnRenderingChanged();
			}
		}
	}
	
	float3 _contrast = float3(1.0f);
	public float3 Contrast
	{
		get
		{
			return _contrast;
		}
		set
		{
			if(value!=_contrast)
			{
				_contrast = value;
				OnRenderingChanged();
			}
		}
	}
	
	public ContrastSaturationBrightness() : base(EffectType.Composition)
	{
	}

	protected override void OnRender(DrawContext dc, Rect elementRect)
	{
		
		var original = Element.CaptureRegion(dc, elementRect, int2(0));
		if (original == null)
			return;
			
		draw Fuse.Drawing.Planar.Image
		{
			DrawContext: dc;
			Visual: Element;
			Position: elementRect.Minimum;
			Invert: true;
			Size: elementRect.Size;
			Texture: original.ColorBuffer;
			float3 lumCoeff: float3(0.2125f, 0.7154f, 0.0721f);
			float3 brightnessColor: TextureColor.XYZ * _brightness;
			float intensityf: Uno.Vector.Dot(brightnessColor, lumCoeff);
			float3 intensity: float3(intensityf, intensityf, intensityf);
			float3 satColor: Uno.Math.Lerp(intensity, brightnessColor, _saturation);
			float3 conColor: Uno.Math.Lerp(float3(0.5f,0.5f,0.5f), satColor, _contrast);
			PixelColor: float4(conColor.XYZ, TextureColor.W);
		};
		
		FramebufferPool.Release(original);
	}
}
