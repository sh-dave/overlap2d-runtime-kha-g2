package o2drt;

import format.o2d.Data;

enum O2dLayerItem {
	Image( data : O2dImageItem );
	Ninepatch( data : O2dNinepatchItem );
	Composite( data : O2dCompositeItem, children : Map<String, Array<O2dLayerItem>> );
	SpriterAnimation( data : O2dSpriterAnimationItem, entity : spriter.EntityInstance );
}
