using Uno;
using Uno.Math;
using Uno.Graphics;
using Uno.UX;
using Fuse.Effects;
using Fuse;

// Based on https://mouaif.wordpress.com/2009/01/05/photoshop-math-with-glsl-shaders/
public sealed class Levels : BasicEffect
{
	float _gamma = 1.0f;
	public float Gamma
	{
		get
		{
			return _gamma;
		}
		set
		{
			if(value!=_gamma)
			{
				_gamma = value;
				OnRenderingChanged();
			}
		}
	}
	float _minInput = 0.0f;
	public float MinInput
	{
		get
		{
			return _minInput;
		}
		set
		{
			if(value!=_minInput)
			{
				_minInput = value;
				OnRenderingChanged();
			}
		}
	}
	float _maxInput= 1.0f;
	public float MaxInput
	{
		get
		{
			return _maxInput;
		}
		set
		{
			if(value!=_maxInput)
			{
				_maxInput = value;
				OnRenderingChanged();
			}
		}
	}
	float _minOutput = 0.0f;
	public float MinOutput
	{
		get
		{
			return _minOutput;
		}
		set
		{
			if(value!=_minOutput)
			{
				_minOutput = value;
				OnRenderingChanged();
			}
		}
	}
	float _maxOutput = 1.0f;
	public float MaxOutput
	{
		get
		{
			return _maxOutput;
		}
		set
		{
			if(value!=_maxOutput)
			{
				_maxOutput = value;
				OnRenderingChanged();
			}
		}
	}
	
	public Levels() : base(EffectType.Composition)
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
			TextureColor: prev TextureColor;
			float3 minIn: float3(_minInput);
			float3 maxIn: float3(_maxInput);
			float3 minOut: float3(_minOutput);
			float3 maxOut: float3(_maxOutput);
			float3 levelsControlInputRange: Min(Max(TextureColor.XYZ - minIn, float3(0.0f)) / (maxIn - minIn), float3(1.0f));
			float3 levelsControlInput: Pow(levelsControlInputRange, float3(1.0f / _gamma));
			float3 color: Lerp(minOut, maxOut, levelsControlInput);
			PixelColor: float4(color, TextureColor.W);
		};

		FramebufferPool.Release(original);
	}
}
