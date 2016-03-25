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

- Una vez cargados a NEO4J debemos hacer un query para obtener los datos en formato "graphml" y poder correr algún algoritmo y tener una mejor visualización, por lo que se debe correr el script:

```

prueba_neo4j_to_gt.py

```



