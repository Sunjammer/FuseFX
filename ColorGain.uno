using Uno;
using Uno.Graphics;
using Uno.UX;
using Fuse.Effects;
using Fuse;

public sealed class ColorGain : BasicEffect
{
	float4 _add;
	public float4 AddColor
	{
		get 
		{
			return _add;
		}
		set
		{
			if (_add != value)
			{
				_add = value;
				OnRenderingChanged();
			}
		}
	}
	
	public float AddR
	{
		get {
			return _add.X;
		}
		set {
			if(value != _add.X)
			{
				_add.X = value;
				OnRenderingChanged();
			}
		}
	}
	public float AddG
	{
		get {
			return _add.Y;
		}
		set {
			if(value != _add.Y)
			{
				_add.Y = value;
				OnRenderingChanged();
			}
		}
	}
	public float AddB
	{
		get {
			return _add.Z;
		}
		set {
			if(value != _add.Z)
			{
				_add.Z = value;
				OnRenderingChanged();
			}
		}
	}
	public float AddA
	{
		get {
			return _add.W;
		}
		set {
			if(value != _add.W)
			{
				_add.W = value;
				OnRenderingChanged();
			}
		}
	}
	
	float4 _mul;
	public float4 MultiplyColor
	{
		get 
		{
			return _mul;
		}
		set
		{
			if (_mul != value)
			{
				_mul = value;
				OnRenderingChanged();
			}
		}
	}
	
	public float MultiplyR
	{
		get {
			return _mul.X;
		}
		set {
			_mul.X = value;
			MultiplyColor = _mul;
		}
	}
	public float MultiplyG
	{
		get {
			return _mul.Y;
		}
		set {
			if(value != _mul.Y)
			{
				_mul.Y = value;
				OnRenderingChanged();
			}
		}
	}
	public float MultiplyB
	{
		get {
			return _mul.Z;
		}
		set {
			if(value != _mul.Z)
			{
				_mul.Z = value;
				OnRenderingChanged();
			}
		}
	}
	public float MultiplyA
	{
		get {
			return _mul.W;
		}
		set {
			if(value != _mul.W)
			{
				_mul.W = value;
				OnRenderingChanged();
			}
		}
	}
	
	public ColorGain() : base(EffectType.Composition)
	{
		_mul = float4(1,1,1,1);
		_add = float4();
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
			PixelColor: (TextureColor + _add) * _mul;
		};

		FramebufferPool.Release(original);
	}
}
