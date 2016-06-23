package o2drt;

class KhaUtility {
	public static function image( filename : String ) : kha.Image {
		var images = kha.Assets.images;
		var image = Reflect.field(images, fixAssetId(filename, true));
		return image;
	}

	public static function blobString( filename : String ) : String {
		var blobs = kha.Assets.blobs;
		var blob = Reflect.field(blobs, fixAssetId(filename, false));
		return blob.toString();
	}

	static function fixAssetId( id : String, stripExtension : Bool ) : String {
		var fullPath = '$id';
		var stripDirectory = haxe.io.Path.withoutDirectory(fullPath);
		var stripped : String;

		if (stripExtension) {
			stripped = haxe.io.Path.withoutExtension(stripDirectory);
		} else {
			stripped = stripDirectory;
		}

		var replaceMinus = StringTools.replace(stripped, '-', '_');
		var replaceDot = StringTools.replace(replaceMinus, '.', '_');
		var final = replaceDot;

		var underscorePrefixRequired = Std.parseInt(final.charAt(0));

		if (underscorePrefixRequired != null) {
			final = '_${final}';
		}

		return final;
	}
}
