package o2drt;

import format.o2d.Data;

typedef Items = Map<String, Array<O2dLayerItem>>;

class O2dSceneBuilder {
	public static function buildScenes( project : O2dProject, assets : O2dRTAssets ) : Map<String, O2dRTScene> {
		return [
			for (s in project.scenes)
				s.name => buildScene(s, assets)
		];
	}

	static function buildScene( s : O2dScene, assets : O2dRTAssets )  : O2dRTScene {
		return {
			layerOrder : s.composite.layers.map(function( l ) return l.name),
			root : buildComposite(s.composite, new Items(), assets),
		}
	}

	static function buildComposite( c : O2dComposite, items : Items, assets : O2dRTAssets ) : Items {
		Lambda.iter(c.images, makeImage.bind(_, items));
		Lambda.iter(c.ninepatches, makeNinepatch.bind(_, items));
		Lambda.iter(c.composites, makeComposite.bind(_, items, assets));
		Lambda.iter(c.spriterAnimations, makeSpriterAnimation.bind(_, items, assets));

		for (i in items) {
			i.sort(function( a, b ) return zof(a) - zof(b));
		}

		return items;
	}

	static function ensureLayerExists( items : Items, layerName : String ) : Array<O2dLayerItem> {
		var l = items.get(layerName);

		if (l == null) {
			items.set(layerName, l = new Array<O2dLayerItem>());
		}

		return l;
	}

	static function makeImage( i : O2dImageItem, items : Items ) {
		ensureLayerExists(items, i.layerName)
			.push(O2dLayerItem.Image(i));
	}

	static function makeNinepatch( i : O2dNinepatchItem, items : Items ) {
		ensureLayerExists(items, i.layerName)
			.push(O2dLayerItem.Ninepatch(i));
	}

	static function makeComposite( i : O2dCompositeItem, items : Items, assets : O2dRTAssets ) {
		ensureLayerExists(items, i.layerName)
			.push(O2dLayerItem.Composite(i, buildComposite(i.composite, new Items(), assets)));
	}

	static function makeSpriterAnimation( i : O2dSpriterAnimationItem, items : Items, assets : O2dRTAssets ) {
		var sp = spriter.Spriter.parseScml(KhaUtility.blobString('orig/spriter_animations/${i.animationName}.scml'));
		var ei = sp.createEntityById(i.entityId);

		ensureLayerExists(items, i.layerName)
			.push(O2dLayerItem.SpriterAnimation(i, ei));
	}

	inline static function zof( item : O2dLayerItem ) : Int {
		return switch (item) {
			case O2dLayerItem.Image(i): i.zIndex;
			case O2dLayerItem.Ninepatch(i): i.zIndex;
			case O2dLayerItem.Composite(i, _): i.zIndex;
			case O2dLayerItem.SpriterAnimation(i, _): i.zIndex;
		}
	}
}
