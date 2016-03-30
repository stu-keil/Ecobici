# Proyecto Ecobici para la Ciudad de México

- Limpieza de los datos

Después de descargar los datos, hay que correr el siguiente script en R

```

ecobici_transform_data.R

```

- Posteriormente, se cargan a NEO4J con los siguientes scripts en el siguiente orden:

```

import.py
importDist.py
importViajes.py

```

También está el código que agrega estos scripts:

```

import_toNeo4j_denny.py

```


Ojo se intentó cargar la información de los viajes en paralelo, sin embargo, arrojó un error.

- Una vez cargados a NEO4J debemos hacer un query para obtener los diferentes subgrafos y aplicar los distintos algoritmos por subgrafo, según los distintos períodos de tiempo, por lo que se debe correr el script:

```

Query_final.py

```

Los resultados se almacenan en /resultados


- El análisis de los resultados se puede ver en


```
analisis_resultados.R

```




