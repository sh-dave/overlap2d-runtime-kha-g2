package o2drt;

import format.o2d.Data.O2dComposite;
import format.o2d.Data.O2dCompositeItem;
import format.o2d.Data.O2dImageItem;
import format.o2d.Data.O2dNinepatchItem;
import format.o2d.Data.O2dProject;
import format.o2d.Data.O2dScene;

class O2dSceneBuilder {
	public static function buildScenes( project : O2dProject ) : Map<String, O2dRTScene> {
		return [
			for (s in project.scenes)
				s.name => buildScene(s)
		];
	}

	static function buildScene( s : O2dScene )  : O2dRTScene {
		return {
			layerOrder : s.composite.layers.map(function( l ) return l.name),
			root : buildComposite(s.composite, new Map<String, Array<O2dLayerItem>>()),
		}
	}

	static function buildComposite( c : O2dComposite, items : Map<String, Array<O2dLayerItem>> ) : Map<String, Array<O2dLayerItem>> {
		Lambda.iter(c.images, makeImage.bind(_, items));
		Lambda.iter(c.ninepatches, makeNinepatch.bind(_, items));
		Lambda.iter(c.composites, makeComposite.bind(_, items));

		for (i in items) {
			i.sort(function( a, b ) return zof(a) - zof(b));
		}

		return items;
	}

	static function ensureLayerExists( items : Map<String, Array<O2dLayerItem>>, layerName : String ) : Array<O2dLayerItem> {
		var l = items.get(layerName);

		if (l == null) {
			items.set(layerName, l = new Array<O2dLayerItem>());
		}

		return l;
	}

	static function makeImage( i : O2dImageItem, items : Map<String, Array<O2dLayerItem>> ) {
		ensureLayerExists(items, i.layerName)
			.push(O2dLayerItem.Image(i));
	}

	static function makeNinepatch( i : O2dNinepatchItem, items : Map<String, Array<O2dLayerItem>> ) {
		ensureLayerExists(items, i.layerName)
			.push(O2dLayerItem.Ninepatch(i));
	}

	static function makeComposite( i : O2dCompositeItem, items : Map<String, Array<O2dLayerItem>> ) {
		ensureLayerExists(items, i.layerName)
			.push(O2dLayerItem.Composite(i, buildComposite(i.composite, new Map <String, Array<O2dLayerItem>>())));
	}

	inline static function zof( item : O2dLayerItem ) : Int {
		return switch (item) {
			case O2dLayerItem.Image(i): i.zIndex;
			case O2dLayerItem.Ninepatch(i): i.zIndex;
			case O2dLayerItem.Composite(i, _): i.zIndex;
		}
	}
}
