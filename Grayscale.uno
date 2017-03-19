using Uno;
using Uno.Math;
using Uno.Graphics;
using Uno.UX;
using Fuse.Effects;
using Fuse;


// @author https://github.com/bolav/
// Based on http://www.tannerhelland.com/3643/grayscale-image-algorithm-vb6/

	public enum GrayscaleAlgorithm
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

	public sealed class Grayscale : BasicEffect
	{
		public Grayscale() : base(EffectType.Composition)
		{
		}

		GrayscaleAlgorithm _algo = GrayscaleAlgorithm.Average;
		public GrayscaleAlgorithm Algorithm
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
					Algorithm == GrayscaleAlgorithm.Average ? (TextureColor.X + TextureColor.Y + TextureColor.Z) / 3 :
					Algorithm == GrayscaleAlgorithm.Luma ? (TextureColor.X * 0.2126f + TextureColor.Y * 0.7152f + TextureColor.Z * 0.0722f) :
					Algorithm == GrayscaleAlgorithm.Monochrome ? ((TextureColor.X + TextureColor.Y + TextureColor.Z) / 3 > 0.5 ? 1f : 0f) :
					Algorithm == GrayscaleAlgorithm.MaxDecomposition ? Max(Max(TextureColor.X, TextureColor.Y), TextureColor.Z) :
					Algorithm == GrayscaleAlgorithm.MinDecomposition ? Min(Min(TextureColor.X, TextureColor.Y), TextureColor.Z) :
					Algorithm == GrayscaleAlgorithm.Desaturate ? (Max(Max(TextureColor.X, TextureColor.Y), TextureColor.Z) + Min(Min(TextureColor.X, TextureColor.Y), TextureColor.Z)) / 2 :
					Algorithm == GrayscaleAlgorithm.RedChannel ? TextureColor.X :
					Algorithm == GrayscaleAlgorithm.BlueChannel ? TextureColor.Y :
					Algorithm == GrayscaleAlgorithm.GreenChannel ? TextureColor.Z : 0f;

				PixelColor: float4(col, col, col, TextureColor.W);
			};

			FramebufferPool.Release(original);
		}
	}
