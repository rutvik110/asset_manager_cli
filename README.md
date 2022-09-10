# Asset Manager

<p align="center">
	<a href="https://github.com/rutvik110/asset_manager_cli"  target="_blank"><img src="https://img.shields.io/pub/v/asset_manager_cli.svg" alt="Pub.dev Badge"></a>
	<a href="https://opensource.org/licenses/MIT" rel="noopener" target="_blank"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="MIT License Badge"></a>
</p>

Asset manager helps you auto-generate the assets code and add it to your pubspec.yaml .

<img src="https://github.com/rutvik110/asset_manager_cli/blob/master/assets/add_demo.gif?raw=true">

## Quick start

```DART

dart pub global activate asset_manager_cli

```

## Overview

To auto-generate and add assets code to your pubspec.yaml, run the following command at the root of your project.
```

asset_manager add

```

To update to latest version, run the following command.
```

asset_manager update

```

## ❕Note

The cli assumes the following structure for your assets folder.

```
---assets/
     |---any_other_assets_folder
     |
     |---fonts/
           | 
           |---font1/
           |    |---font1-style-weight1.ttf
           |    |---font1-style-weight2.ttf
           |    |---font1-style-weight3.ttf
           |
           |
           |---font2/
                |---font2-style-weight1.ttf
                |---font2-style-weight2.ttf
                |---font2-style-weight3.ttf
       
```

Any other assets folders except fonts can have any name you desire for those assets. But for fonts, you should add them within a folder named `fonts` within `assets` folder. And each folder within `fonts` should be named according to the `font-family`. Every fonts file should be named in the following way -

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

## Support the project

[!["Buy Me A Coffee"](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/takrutvik)

