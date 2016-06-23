package;

class OverlapDemo {
	var assets : o2drt.O2dRTAssets;
	var scenes : Map<String, o2drt.O2dRTScene>;

	var lastTime : Float;

	public function new() {
		// load main project
		var projectData = new format.o2d.Reader(o2drt.KhaUtility.blobString('project.dt')).read();

		// load scenes
		for (scene in projectData.scenes) {
			new format.o2d.Reader(o2drt.KhaUtility.blobString('scenes/${scene.name}.dt')).readScene(scene);
		}

		assets = new o2drt.O2dRTAssets();

		// load atlas
		// TODO (DK)
		//	-i'm not quite sure how we are supposed to now what atlas packs to load
		//		-is there only this one pack with everything inside?
		//	-for now we just load the one in '/Assets/orig'
		assets.atlasData = new format.o2d.AtlasReader(o2drt.KhaUtility.blobString('orig/pack.atlas')).read();

		var dogSheet = imagesheet.ImageSheet.fromTexturePackerJsonArray(o2drt.KhaUtility.blobString('orig/spriter_animations/dog-sheet.json'));
		dogSheet.image = o2drt.KhaUtility.image('orig/spriter_animations/dog-sheet.png');

		assets.spriterAnimationSheets.set('dog', dogSheet);

		// build scenegraph
		scenes = o2drt.O2dSceneBuilder.buildScenes(projectData, assets);

		kha.Scheduler.addTimeTask(update, 0, 1 / 60);
		kha.System.notifyOnRender(render);

		lastTime = kha.Scheduler.time();
	}

	function render( fb : kha.Framebuffer ) {
		var g = fb.g2;

		g.begin();
			o2drt.O2dSceneRenderer.render(g, scenes, assets);
		g.end();
	}

	function update() {
		var now = kha.Scheduler.time();
		var delta = now - lastTime;
		lastTime = now;

		o2drt.O2dSceneRenderer.step(scenes, delta);
	}
}
