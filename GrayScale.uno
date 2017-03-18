using Uno;
using Uno.Math;
using Uno.Graphics;
using Uno.UX;
using Fuse.Effects;
using Fuse;


// @author https://github.com/bolav/
// Based on http://www.tannerhelland.com/3643/grayscale-image-algorithm-vb6/

	public enum GreyscaleAlgorithm
	{
		Monochrome,
		Average,
		Luma,
		Desaturate,
		MaxDecomposition,
		MinDecomposition,
		RedChannel,
		BlueChannel,
		GreenChannel,
	}
	/** Converts to GreyScale @Element.
	*/

	public sealed class GrayScale : BasicEffect
	{
		public GrayScale() : base(EffectType.Composition)
		{
		}

		GreyscaleAlgorithm _algo = GreyscaleAlgorithm.Average;
		public GreyscaleAlgorithm Algorithm
		{
			get { return _algo; }
			set 
			{
				if (_algo != value)
				{
					_algo = value;
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
				float col:
					Algorithm == GreyscaleAlgorithm.Average ? (TextureColor.X + TextureColor.Y + TextureColor.Z) / 3 :
					Algorithm == GreyscaleAlgorithm.Luma ? (TextureColor.X * 0.2126f + TextureColor.Y * 0.7152f + TextureColor.Z * 0.0722f) :
					Algorithm == GreyscaleAlgorithm.Monochrome ? ((TextureColor.X + TextureColor.Y + TextureColor.Z) / 3 > 0.5 ? 1f : 0f) :
					Algorithm == GreyscaleAlgorithm.MaxDecomposition ? Max(Max(TextureColor.X, TextureColor.Y), TextureColor.Z) :
					Algorithm == GreyscaleAlgorithm.MinDecomposition ? Min(Min(TextureColor.X, TextureColor.Y), TextureColor.Z) :
					Algorithm == GreyscaleAlgorithm.Desaturate ? (Max(Max(TextureColor.X, TextureColor.Y), TextureColor.Z) + Min(Min(TextureColor.X, TextureColor.Y), TextureColor.Z)) / 2 :
					Algorithm == GreyscaleAlgorithm.RedChannel ? TextureColor.X :
					Algorithm == GreyscaleAlgorithm.BlueChannel ? TextureColor.Y :
					Algorithm == GreyscaleAlgorithm.GreenChannel ? TextureColor.Z : 0f;

				PixelColor: float4(col, col, col, TextureColor.W);
			};

			FramebufferPool.Release(original);
		}
	}
}
