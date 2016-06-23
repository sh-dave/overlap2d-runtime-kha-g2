class Main {
	public static function main() {
		kha.System.init(
			{ title : 'OverlapDemo', width : 800, height : 480 },
			kha.Assets.loadEverything.bind(assets_loadedHandler)
		);
	}

	static function assets_loadedHandler() {
		new OverlapDemo();
	}
}
