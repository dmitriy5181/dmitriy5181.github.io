---
title: "Automatic swap file management"
---

Just install *dphys-swapfile* and it will do the rest:

```
# apt install dphys-swapfile
```

By default, it creates swapfile twice as big as the present RAM amount. Settings can be customized by editing the config file */etc/dphys-swapfile*.
For more details see ``dphys-swapfile(8)``.