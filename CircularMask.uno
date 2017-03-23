using Uno;
using Uno.Graphics;
using Uno.UX;
using Fuse.Effects;
using Fuse;
using Uno.Math;

public sealed class CircularMask : BasicEffect
{
	float2 _pos;
	public float2 Position{
		get{
			return _pos;
		}
		set{
			if(value==_pos)return;
			_pos = value;
			OnRenderingChanged();
		}
	}
	
	float _softness = 0.001f;
	public float EdgeSoftness
	{
		get{
			return _softness;
		}
		set{
			if(value==_softness)return;
			_softness = value;
			OnRenderingChanged();
		}
	}
	
	bool _ignoreAspect = true;
	public bool IgnoreAspect{
		get{
			return _ignoreAspect;
		}
		set{
			if(value==_ignoreAspect)return;
			_ignoreAspect = value;
			OnRenderingChanged();
		}
	}
	
	bool _cutout;
	public bool Cutout{
		get{
			return _cutout;
		}
		set{
			if(value==_cutout)return;
			_cutout = value;
			OnRenderingChanged();
		}
	}
	
	float _radius = 0.0f;
	public float Radius
	{
		get {
			return _radius;
		}
		set{
			if(value==_radius)return;
			_radius = value;
			OnRenderingChanged();
		}
	}
	
	public CircularMask() : base(EffectType.Composition)
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
			float2 uv2: pixel float2(TexCoord.X, 1 - TexCoord.Y);
			float aspect: _ignoreAspect ? 1.0f : Size.Y / Size.X;
			float2 uv3: float2(uv2.X, uv2.Y * aspect);
			float2 p: float2(_pos.X, _pos.Y * aspect);
			float2 diff: uv3 - p;
			float dist: Sqrt(diff.X * diff.X + diff.Y * diff.Y);
			float step: SmoothStep(_radius - _softness * 0.5f, _radius + _softness * 0.5f, dist);
			float a: _cutout ? step : 1.0f - step;
			PixelColor: float4(TextureColor.XYZ, TextureColor.W * a);
		};

		FramebufferPool.Release(original);
	}
}
