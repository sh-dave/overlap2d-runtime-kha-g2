package o2drt;

class O2dSceneRenderer {
	public static function render( g : kha.graphics2.Graphics, scenes : Map<String, O2dRTScene>, ad : format.o2d.AtlasData.O2dAtlasData ) {
		for (s in scenes) {
			for (lo in s.layerOrder) {
				for (item in s.root.get(lo)) {
					renderItem(item, g, 0.0, 0.0, ad);
				}
			}
		}
	}

	static function renderItem( item : O2dLayerItem, g : kha.graphics2.Graphics, xoffset : Float, yoffset : Float, ad : format.o2d.AtlasData.O2dAtlasData ) {
		switch (item) {
			case O2dLayerItem.Image(i): renderImage(i, g, xoffset, yoffset, ad);
			case O2dLayerItem.Composite(i, children): {
				for (layer in children) {
					for (child in layer) {
						renderItem(child, g, i.x + xoffset, i.y + yoffset, ad);
					}
				}
			}
			default:
		}
	}

	static function renderImage( i : format.o2d.Data.O2dImageItem, g : kha.graphics2.Graphics, xoffset : Float, yoffset : Float, ad : format.o2d.AtlasData.O2dAtlasData ) {
		var h : Float = kha.System.windowHeight();
		var region = Lambda.find(ad.regions, function( r ) return r.id == i.imageName);
		var image = Reflect.field(kha.Assets.images, KhaUtility.fixAssetId(region.imagePack.imageFilename, true));

		var fx = i.x + xoffset;
		fx += region.width * (1 - i.scaleX) * 0.5;

		var fy = h - yoffset;
		fy -= i.y;
		fy -= region.height;
		fy += region.height * (1 - i.scaleY) * 0.5;

		g.drawScaledSubImage(image, region.x, region.y, region.width, region.height, fx, fy, i.scaleX * region.width, i.scaleY * region.height);
	}
}
