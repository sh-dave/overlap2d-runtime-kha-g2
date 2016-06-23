package;

class OverlapDemo {
	var projectData : format.o2d.Data.O2dProject;
	var atlasData : format.o2d.AtlasData.O2dAtlasData;

	var scenes : Map<String, o2drt.O2dRTScene>;

	public function new() {
		// load main project
		projectData = new format.o2d.Reader(kha.Assets.blobs.project_dt.toString()).read();

		// load scenes
		for (scene in projectData.scenes) {
			new format.o2d.Reader(Reflect.field(kha.Assets.blobs, o2drt.KhaUtility.fixAssetId('scenes/${scene.name}.dt', false))).readScene(scene);
		}

		// load atlas
		atlasData = new format.o2d.AtlasReader(kha.Assets.blobs.pack_atlas.toString()).read();

		// build scenegraph
		scenes = o2drt.O2dSceneBuilder.buildScenes(projectData);

		kha.System.notifyOnRender(render);
	}

	function render( fb : kha.Framebuffer ) {
		var g = fb.g2;

		g.begin();
			o2drt.O2dSceneRenderer.render(g, scenes, atlasData);
		g.end();
	}
}
