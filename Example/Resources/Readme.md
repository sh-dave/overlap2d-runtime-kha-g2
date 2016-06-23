(DK)

- this is a copy of the overlap-0.1.3/examples/OverlapDemo
- i renamed the sprite animation sheep to sa-sheep and spine animation sheep to sp-sheep
	- kha currently flattens the assets folder and therefore can't really handle duplicate filenames
- it is also neccessary to delete the Assets/small folder after an export for now (again, flattening the folder produces duplicate filenames)

- texturepacker settings for spriter-animations
	data.prepend_folder_name: true => dog/legs.png

- export:
	- delete /Assets/small
	- deleta /Assets/orig/spriter_animations/dog/*.png
	- run texturepacker for /Resources/OverlapDemo/assets/orig/spriter-animations/dog.tps
