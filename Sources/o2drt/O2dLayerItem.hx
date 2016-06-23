package o2drt;

import format.o2d.Data.O2dImageItem;
import format.o2d.Data.O2dNinepatchItem;
import format.o2d.Data.O2dCompositeItem;

enum O2dLayerItem {
	Image( data : O2dImageItem );
	Ninepatch( data : O2dNinepatchItem );
	Composite( data : O2dCompositeItem, children : Map<String, Array<O2dLayerItem>> );
}
