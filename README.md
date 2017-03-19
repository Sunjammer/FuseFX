# FuseFX
Extra image effects for Fuse

## Background
[Fuse](http://fusetools.com) is built on a proprietary programming language called Uno, which is based off C# and adds a number of features for platform agnostic programming and easy access to hardware accelerated rendering features.

Because of this, Fuse has a post processing effects pipeline that is fairly easy to extend, with a little grit and intuition. This repo contains additional post processing effects.

## Adding to your project
Just clone this repo and add a project reference to it in your unoproj:
```
"Projects":[
  "../FuseFX/FuseFX.unoproj"
]
```

## Current effects

### ChromaticAberration
This effect applies a naive spatial distortion to the individual color components of the rendered element, offsetting colors from their original location. Each component has an `Offset` property, taking a 2-component comma separated float list corresponding to the X and Y offsets.

```UX
<Image File="foo.png">
  <!-- Offset the red component of every pixel by 5 texels on the X axis -->
  <ChromaticAberration OffsetR="5,0" />
</Image>
```

### ColorGain
Add and then multiply the color components of the element (`color = (color+add)*multiply`);
Each component can be manipulated individually or as a whole with a color input. 

```UX
<Image File="foo.png">
  <!-- Add a little bit of red and make the whole thing darker-->
  <ColorGain AddColor="#300" MultiplyColor="#888" />
</Image>
```

### ContrastSaturationBrightness
Apply Photoshop-style contrast, saturation and brightness modifiers in one effect.
Every property is in a scalar range from 0 to 1. The range is unclamped for fun and weirdness.

```UX
<Image File="foo.png">
  <!-- Make it look like a harsh stencil-->
  <ContrastSaturationBrightness Contrast="4" Saturation="0" Brightness="3" />
</Image>
```

### Levels
Apply Photoshop-style color range remapping and gamma correction using input/output ranges and a gamma scalar.

```UX
<Image File="foo.png">
  <!-- Deepen black levels -->
  <Levels MinInput="0.1" />
</Image>
```

### Grayscale
Convert to graycale.

Algorithm can be on of:

- `Monochrome`
- `Average`, R+G+B / 3
- `Luma`, R * 0.2126 + g * 0.7152 + B * 0.0722
- `MaxDecomposition`, Max(R,G,B)
- `MinDecomposition`, Min(R,G,B)
- `Desaturate`, Max(R,G,B) + Min(R,G,B) / 2
- `RedChannel`, R
- `GreenChannel`, G
- `BlueChannel`, B

```UX
<Image File="foo.png">
  <Grayscale Algorithm="Average" />
</Image>
```
