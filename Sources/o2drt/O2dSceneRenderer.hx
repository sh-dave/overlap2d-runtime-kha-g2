package o2drt;

import kha.graphics2.Graphics;
import format.o2d.Data;

class O2dSceneRenderer {
	public static function render( g : Graphics, scenes : Map<String, O2dRTScene>, assets : o2drt.O2dRTAssets ) {
		for (s in scenes) {
			for (lo in s.layerOrder) {
				for (item in s.root.get(lo)) {
					renderItem(g, item, 0.0, 0.0, assets);
				}
			}
		}
	}

	public static function step( scenes : Map<String, O2dRTScene>, dt : Float ) {
		for (s in scenes) {
			for (lo in s.layerOrder) {
				for (item in s.root.get(lo)) {
					stepItem(item, dt);
				}
			}
		}
	}

	static function renderItem( g : Graphics, item : O2dLayerItem, xoffset : Float, yoffset : Float, assets : o2drt.O2dRTAssets ) {
		switch (item) {
			case O2dLayerItem.Image(i): renderImage(g, i, xoffset, yoffset, assets);
			case O2dLayerItem.Composite(i, children): {
				for (layer in children) {
					for (child in layer) {
						renderItem(g, child, i.x + xoffset, i.y + yoffset, assets);
					}
				}
			}
			case O2dLayerItem.SpriterAnimation(i, ei): renderSpriterAnimation(g, i, ei, xoffset, yoffset, assets);
			case O2dLayerItem.Ninepatch(i): throw 'TODO (DK) implement me: render O2dSceneRenderer.renderNinepatch';
		}
	}

	static function renderImage( g : Graphics, i : O2dImageItem, xoffset : Float, yoffset : Float, assets : o2drt.O2dRTAssets ) {
		var h : Float = kha.System.windowHeight();
		var pack = assets.atlasData;
		var region = Lambda.find(pack.regions, function( r ) return r.id == i.imageName);
		var image = KhaUtility.image(region.imagePack.imageFilename);

		var fx = i.x + xoffset;
		fx += region.width * (1 - i.scaleX) * 0.5;

		var fy = h - yoffset;
		fy -= i.y;
		fy -= region.height;
		fy += region.height * (1 - i.scaleY) * 0.5;

		g.drawScaledSubImage(image, region.x, region.y, region.width, region.height, fx, fy, i.scaleX * region.width, i.scaleY * region.height);
	}

	static function renderSpriterAnimation( g : Graphics, i : O2dSpriterAnimationItem, entity : spriter.EntityInstance, xoffset : Float, yoffset : Float, assets : o2drt.O2dRTAssets ) {
		var h : Float = kha.System.windowHeight();

		var fx = i.x + xoffset;
		//fx += region.width * (1 - i.scaleX) * 0.5;

		var fy = h - yoffset;
		fy -= i.y;
		//fy -= region.height;
		//fy += region.height * (1 - i.scaleY) * 0.5;

		spriterkha.SpriterG2.drawSpriter(g, assets.spriterAnimationSheets.get(i.animationName), entity, fx, fy);
	}

	static function stepItem( i : O2dLayerItem, dt : Float ) {
		switch (i) {
			case O2dLayerItem.Image(i):
			case O2dLayerItem.Ninepatch(i):
			case O2dLayerItem.Composite(i, children): {
				for (layer in children) {
					for (child in layer) {
						stepItem(child, dt);
					}
				}
			}
			case O2dLayerItem.SpriterAnimation(_, ei): ei.step(dt);
		}
	}
}
