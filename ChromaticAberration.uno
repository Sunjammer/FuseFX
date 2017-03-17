using Uno;
using Uno.Graphics;
using Uno.UX;
using Fuse.Effects;
using Fuse;

public sealed class ChromaticAberration : BasicEffect
{
	float2 _offsetR;
	float2 _offsetG;
	float2 _offsetB;
	
	public float2 OffsetR
	{
		get 
		{
			return _offsetR;
		}
		set
		{
			if(value != _offsetR)
			{
				_offsetR = value;
				OnRenderingChanged();
			}
		}
	}
	
	public float2 OffsetG
	{
		get 
		{
			return _offsetG;
		}
		set
		{
			if(value != _offsetG)
			{
				_offsetG = value;
				OnRenderingChanged();
			}
		}
	}
	
	public float2 OffsetB
	{
		get 
		{
			return _offsetB;
		}
		set
		{
			if(value != _offsetB)
			{
				_offsetB = value;
				OnRenderingChanged();
			}
		}
	}
	
	public ChromaticAberration() : base(EffectType.Composition)
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
			float2 texelSize: 1.0f/Size;
			float2 uv2: float2(TexCoord.X, 1 - TexCoord.Y);
			float2 offsetR: _offsetR * texelSize;
			float2 offsetG: _offsetG * texelSize;
			float2 offsetB: _offsetB * texelSize;
			float4 r: sample(Texture, TexCoord+offsetR, Uno.Graphics.SamplerState.LinearClamp);
			float4 g: sample(Texture, TexCoord+offsetG, Uno.Graphics.SamplerState.LinearClamp);
			float4 b: sample(Texture, TexCoord+offsetB, Uno.Graphics.SamplerState.LinearClamp);
			float4 a: sample(Texture, TexCoord, Uno.Graphics.SamplerState.LinearClamp);
			PixelColor: float4(r.X, g.Y, b.Z, a.W);
		};
		
		FramebufferPool.Release(original);
	}
}
