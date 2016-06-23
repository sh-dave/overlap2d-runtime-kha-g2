var project = new Project('OverlapDemo');

project.addAssets('Assets/**');

project.addLibrary('haxe-format-o2d');
project.addLibrary('spriter'); // https://github.com/wighawag/spriter
project.addLibrary('spriterkha'); // https://github.com/sh-dave/spriterkha/tree/scaling (= 'scaling' branch of my spriterkha fork)

//project.addLibrary('overlay2d-runtime-kha-g2');
project.addSources('../Sources');
project.addSources('Sources');

project.windowOptions.width = 800;
project.windowOptions.height = 480;

return project;
