# Entrega 1 Proyecto Tamagotchi
## Integrantes 
* Julian David Monsalve Sanchez
* Jonathan Andres Jimenez Trujillo
* Daniel Esteban Hostos
## Características Generales

El dispositivo cuenta con los siguientes botones para la interacción del ususario:

- Reset
- Alimentar
- Jugar
- Acelerar

Y los siguientes sensores de entorno para interactuar con el mundo real:

- Sensor digital de sonido
- Sensor digital de luz

Toda la información se desplegará en una pantalla monocromática de 48x84 píxeles

## Descripción General

La mascota cuenta con dos estados básicos: dormido y despierto

La mascota cuenta 3 variables cuyo estado depende de las interacciones del usuario a lo largo del tiempo:

- Salud - Medida en corazones, con un máximo de 3
- Felicidad - Medida en caritas felices, con un máximo de 3
- Energía - Medida en niveles de batería, con valores posibles siendo 0%, 25%, 50%, 75% y 100%

La mascota se ve afectada por dos variables del mundo real: sonido y ruido

Se considera que la mascota muere y se debe reiniciar el juego cuando su salud llega a 0, las otras dos variables determinan la velocidad a la cual disminuye su salud. 

### Tiempo

Inicialmente 1 día en tiempo de juego es equivalente a un día real, sin embargo esta equivalencia puede alterarse con el botón de aceleración, al presionarlo una vez se puede variar entre 4 duraciones de un día completo en el tiempo del juego, las cuales son: 24h, 12h, 3h y 1h. 

### Salud, Felicidad y Energía

La mascota inicia el juego con las tres variables en su valor máximo. Y se considera que el instante en el que se inicia el juego es el instante en el que jugó, comió y durmió por última vez

- Su nivel de Felicidad disminuye a un ritmo de una carita feliz cada tres horas de tiempo de juego desde la última vez que jugó.
- Su nivel de Energía disminuye a un ritmo de un nivel cada dos horas de tiempo de juego desde la última vez que durmió.

La velocidad a la cual decae lu salud depende de su nivel de energía y felicidad, en condiciones óptimas su salud decae a un ritmo de un corazón cada 8 horas (en tiempo de juego) desde que fue aimentado o desde que inició la partida, sin embargo sus niveles de felicidad y energía influyen a la velocidad a la que su salud de cae a modo de multiplicador de la siguiente manera:

- 3 caritas felices: 1x (Ritmo por defecto)
- 2 caritas felices: 1.25x
- 1 carita feliz: 1.5x
- 0 caritas felices: 2x

Respecto a la energía:

- 100% de energía: 1x
- 75% de energía: 1.25x
- 50% de energía: 1.5x
- 25% de energía: 1.75x
- 0% de energía: 2x

Los multiplicadores son acumulativos de tal manera que en sus peores condiciones disminuirá un corazón de salud cada 2 horas en tiempo de juego.

Como limitante de dificultad, la mascota no puede ser alimentada más de una vez por hora en tiempo de juego

Los niveles de energía y felicidad pueden ser restaurados mediante las interacciones del usuario, su energía se recupera al dormir a ritmo de un nivel de energía cada hora (en tiempo de juego) que duerma sin interrupciones.

Su nivel de felicidad se aumenta a un ritmo de una carita feliz cada vez que se apriete el botón de juego, para limitar la dificultad, para poder jugar nuevamente se deben esperar dos horas desde la última vez que lo hizo (en tiempo de juego).

Si su felicidad o energía se encuentran en 0 y se ha cumplido el plazo para que disminuya una unidad más el valor permanecerá en 0 y el multiplicador de velocidad de disinución de salud no se verá afectado.

### Luz y Sonido

La mascota se ve afectada por dos variables que dependen de sensores digitales de luz y sonido, estas variables son digitales de 1 bit, por lo cual cada una cuenta con tan solo dos estados: oscuridad, luz para el sensor de luminosidad y silencio, sonido para el sensor de sonido.

La sensibilidad de los sensores para obtener un 1 lógico en el juego está dictada por un potenciómetro que debe ser ajustado para una dificultad de juego abierta a discusión.

### Dormido, Despierto

La mascota inicia el juego despierta, para que se duerma deben pasar 3 minutos consecutivos sin que se activen los sensores de sonido o luz y sin comer o jugar.

- Una vez dormido, la mascota recuperará un nivel de energía por cada hora en tiempo de juego que duerma de manera consecutiva. 

- Su nivel de energía no disminuirá mientras duerma.

- Estar dormido no afecta la velocidad a la que sus niveles de salud o felicidad disminuyen.

La mascota se despertará al cumplir al menos una de las siguientes condiciones:

- El sensor de sonido es activado durante más de 10 segundos de tiempo de juego consecutivos.

- El sensor de luz es activado durante más de 10 segundos de tiempo de juego consecutivos.

- Se presiona el botón de alimentar.

- Se presiona el botón de juego.

Si se despierta a la mascota alimentandola o jugando con ella se ejecutará la acción de manera normal.

Si se despierta a la mascota al activar el sensor de sonido al hacerlo se disminuirán dos caritas feliz de nivel de felicidad (si el número de caritas disponibles al momento de despertarlo es menor a 2 su nivel de felicidad quedará en 0), pues se considera que se despertó de mal humor.

## Pantalla

La pantalla utilizada es monocrómatica de resolución 48x84 píxeles, por lo que se considera espacio suficiente para mostrar todos los posibles estados en la pantalla:

![image](https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo09-2024-1/assets/159467200/071a6211-deaf-4704-81aa-536f0d26153f)

Los indicadores de luz y sonido se activarán únicamente cuando exista 1 lógico en su respectivo sensor, de lo contrario no serán dibujados.

Ya que el sprite de la mascota es un plagio directo a Pokémon Gold, cuando la mascota duerma, se dibujará en cambio una Pokébola.

![image](https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo09-2024-1/assets/159467200/460b9b8f-9db6-4a00-a613-f3576833416a)

Nótese la agrupación de los sprites en grupos de 8 filas, hecho así entendiendo el sistema de transmisión SPI que utiliza la pantalla en el cual cada byte de información corresponde a una columna de 8 píxeles, así se simplifica la tarea del dibujado en la futura implementación.





