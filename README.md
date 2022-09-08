# Asset Manager

### Asset manager is an dart cli application to auto-generate the assets code and add it to your pubspec.yaml .

// gif of asset generation

## Quick start

```DART

dart pub global activate asset_manager_cli

```

## Overview

To auto-generate and add assets code to your pubspec.yaml, run the following command at the root of your project.
```DART

asset_manager add

```
## ❕Note

The cli assumes the following structure for your assets folder.

```
---assets/
     |---any_other_assets_folder_that_isn't_fonts
     |
     |---fonts/
           | 
           |---font1/
           |    |---font1-style-weight.ttf
           |    |---font1-style-weight.ttf
           |    |---font1-style-weight.ttf
           |
           |
           |---font2/
                |---font2-style-weight.ttf
                |---font2-style-weight.ttf
                |---font2-style-weight.ttf
       
```

Any other assets except fonts can have any name you desire for those assets. But for fonts, you should add them within a folder named `fonts` within `assets` folder. And each folder within `fonts` should be named according to the `font-family`. Every fonts file should be named in the following way -

```
Font file name ---> font1-style-weight.ttf
                      ^     ^     ^
                      |     |     |
                      |     |   Weight of the font
                      |     |
                      |    Style of the font
                      |
                     Font family name

```

