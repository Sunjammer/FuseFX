using Uno;
using Uno.Graphics;
using Uno.UX;
using Fuse.Effects;
using Fuse;
using Uno.Math;

public sealed class Vignette : BasicEffect
{
	
	public Vignette() : base(EffectType.Composition)
	{
		_falloff = 0.25f;
		_pow = 1.0f;
	}
	
	float _pow;
	public float Power
	{
		get {
			return _pow;
		}
		set {
			if(value != _pow)
			{
				_pow = value;
				OnRenderingChanged();
			}
		}
	}
	
	float _falloff;
	public float Falloff
	{
		get {
			return _falloff;
		}
		set {
			if(value != _falloff)
			{
				_falloff = value;
				OnRenderingChanged();
			}
		}
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
			float2 uv2: pixel float2(TexCoord.X, 1 - TexCoord.Y);
			
			float2 coord : (uv2 - float2(0.5f)) * (Size.X/Size.Y) * 2.0f;
			float rf : Math.Pow(Math.Sqrt(Vector.Dot(coord, coord)) * _falloff, _pow);
			float rf2_1 : rf * rf + 1.0f;
			float e : 1.0f / (rf2_1 * rf2_1);
			PixelColor: float4(TextureColor.XYZ*e, TextureColor.W);
		};

		FramebufferPool.Release(original);
	}
}
