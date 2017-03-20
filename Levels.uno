using Uno;
using Uno.Math;
using Uno.Graphics;
using Uno.UX;
using Fuse.Effects;
using Fuse;

// Based on https://mouaif.wordpress.com/2009/01/05/photoshop-math-with-glsl-shaders/
public sealed class Levels : BasicEffect
{
	float4 _gamma = float4(1.0f);
	public float4 Gamma
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
	float4 _minInput = float4(0.0f);
	public float4 MinInput
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
	float4 _maxInput = float4(1.0f);
	public float4 MaxInput
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
	float4 _minOutput = float4(0.0f);
	public float4 MinOutput
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
	float4 _maxOutput = float4(1.0f);
	public float4 MaxOutput
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
			float4 gammaR: 1.0f / _gamma;
			PixelColor: Lerp(_minOutput, _maxOutput, Pow(Min(Max(TextureColor - _minInput, float4(0.0f)) / (_maxInput - _minInput), float4(1.0f)), gammaR));
		};

		FramebufferPool.Release(original);
	}
}
