# BiMaps.jl

Simple bidirectional maps in Julia using immutable dictionaries.

```julia
using BiMaps

english_names = ["Cat", "Purse", "Printer"]
italian_names = ["Gatto", "Borsa", "Stampante"]

bimap = BiMap(english_names, italian_names)

@assert bimap.getleft("Cat") == "Gatto"
@assert bimap.getright("Borsa") == "Purse"
```

## LICENSE

Copyright © 2023 Guido Masella

MIT. See the [LICENSE](LICENSE) file for more information.
