# 3D Gabor Segmentator
Segmentation tool based on 3D Gabor filtering. It was developed to segment the whole breast in DCE-MRI images.

Please cite our [paper](https://link.springer.com/chapter/10.1007%2F978-3-319-92639-1_37):
```
    @INPROCEEDINGS{illan2018,
  	       series = {Lecture {Notes} in {Computer} {Science}},
         	title = {3D {Gabor} {Filters} for {Chest} {Segmentation} in {DCE}-{MRI}},
         	author = {Illan, I. A. and Matos, J. Perez and Ramirez, J. and Gorriz, J. M. and Foo, S. and Meyer-Baese, A.},
  	       year = {2018},
          pages = {446--454},
    }
```

# Run

Use the following parameters to run on Example2:
```Matlab

load Example2

[segmented_mask] = SegmentBreast3D( mean_img , 12 , 1.6 , 3, 0.4 , 8 ,3);
```

# License

This code is released under the license [GPL-3.0+](https://choosealicense.com/licenses/gpl-3.0/). 
