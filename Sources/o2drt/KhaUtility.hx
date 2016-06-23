package o2drt;

class KhaUtility {
	public static function fixAssetId( id : String, stripExtension : Bool ) : String {
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
